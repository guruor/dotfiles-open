#!/usr/bin/env bash
# resource-snapshot.sh - read-only resource ledger + watchdog for this Mac.
#
# Modes:
#   (no args)       daily briefing: appends to the ledger, then prints the full report. This is
#                   what a cron job's `script` field runs, so it deliberately takes no arguments.
#   --alert         watchdog. Prints NOTHING when healthy, a short breach list otherwise.
#                   ALWAYS exits 0: cron delivers stdout verbatim, and a non-zero exit would
#                   replace this report with the engine's own wording.
#   --record        append one snapshot to the ledger, print nothing. Cheap; safe frequently.
#   --report        print the full current state, healthy or not.
#   --drift [DAYS]  compare the last 24h with the preceding DAYS (default 7) and print what
#                   moved, plus tenants that are new since the ledger started.
#   --with-shell    also time one login+interactive zsh (~2s). Daily/weekly runs only, never
#                   the frequent watchdog.
#
# WHY THIS EXISTS: top/bottom rank by CPU and memory, so neither can see the two things that
# actually make this machine feel slow: zombie accumulation (0% CPU, ~0 RSS, invisible to every
# GUI task manager) and aggregate memory pressure expressed as compressor + swap I/O. Those are
# measured here, and written to a ledger so drift is visible over days instead of only at the
# moment it hurts.
#
# PRIVACY CONTRACT (do not weaken): this reports executable and .app bundle NAMES plus aggregate
# numbers. It must never emit process argv, command lines, environment blocks, file contents, or
# anything under AGENTIC_DENY_DIRS. `launchctl print` output is grepped for one numeric key at a
# time: the full output embeds the job's environment, which can carry tokens.
set -uo pipefail

STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/resource-snapshot"
HIST="$STATE_DIR/history.tsv"
APPS="$STATE_DIR/apps.tsv"
RETENTION_DAYS="${RESOURCE_RETENTION_DAYS:-45}"

# Thresholds: override in the environment, never by editing the script.
TH_FREE_MB="${TH_FREE_MB:-1024}"
TH_COMPRESSOR_MB="${TH_COMPRESSOR_MB:-2048}"
TH_SWAP_MB="${TH_SWAP_MB:-1024}"
TH_ZOMBIES="${TH_ZOMBIES:-100}"
TH_LOAD_PER_CORE="${TH_LOAD_PER_CORE:-2}"
TH_PROC_PCT="${TH_PROC_PCT:-70}"
TH_APP_MB="${TH_APP_MB:-1500}"
TH_APP_SHARE_PCT="${TH_APP_SHARE_PCT:-25}"
TH_DISK_GB="${TH_DISK_GB:-20}"
TH_LOOP_RUNS="${TH_LOOP_RUNS:-200}"

mode="daily"; drift_days=7; with_shell=0
case "${1:-}" in
    ""       )    mode="daily" ;;
    --record)     mode="record" ;;
    --report)     mode="report" ;;
    --drift)      mode="drift"; [ -n "${2:-}" ] && drift_days="$2" ;;
    --alert)      mode="alert" ;;
    --with-shell) with_shell=1 ;;
    -h|--help)    sed -n '2,20p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *)            printf 'unknown mode: %s\n' "$1"; exit 0 ;;
esac
case "${2:-}" in --with-shell) with_shell=1 ;; esac

now_ms() { perl -MTime::HiRes=time -e 'printf "%d", time*1000' 2>/dev/null || printf '%s000' "$(date +%s)"; }

# ---------------------------------------------------------------------------- collect
collect() {
    ncpu=$(sysctl -n hw.ncpu 2>/dev/null || echo 1)
    pagesize=$(sysctl -n hw.pagesize 2>/dev/null || echo 4096)
    memsize=$(sysctl -n hw.memsize 2>/dev/null || echo 0)
    mem_total_mb=$((memsize / 1048576))
    now=$(date +%s)
    iso=$(date '+%Y-%m-%d %H:%M %Z')
    boot=$(sysctl -n kern.boottime 2>/dev/null | awk '{print $4}' | tr -d ',')
    uptime_s=$((now - ${boot:-$now}))

    load1=$(sysctl -n vm.loadavg | awk '{print $2}')
    load5=$(sysctl -n vm.loadavg | awk '{print $3}')
    load15=$(sysctl -n vm.loadavg | awk '{print $4}')

    vms=$(vm_stat)
    vp() { printf '%s\n' "$vms" | awk -v k="$1" 'index($0,k)==1 {v=$NF; gsub(/[^0-9]/,"",v); print v+0; exit}'; }
    free_p=$(vp 'Pages free')
    wired_p=$(vp 'Pages wired down')
    comp_p=$(vp 'Pages occupied by compressor')
    comps_p=$(vp 'Pages stored in compressor')
    mem_free_mb=$((free_p * pagesize / 1048576))
    wired_mb=$((wired_p * pagesize / 1048576))
    compressor_mb=$((comp_p * pagesize / 1048576))
    comp_stored_mb=$((comps_p * pagesize / 1048576))
    # "Used" on macOS counts reclaimable file cache, which reads as alarmism. Report the
    # reclaimable pool alongside it so the number is interpretable.
    inact_p=$(vp 'Pages inactive')
    spec_p=$(vp 'Pages speculative')
    purge_p=$(vp 'Pages purgeable')
    reclaimable_mb=$(( (inact_p + spec_p + purge_p) * pagesize / 1048576 ))
    mem_used_mb=$((mem_total_mb - mem_free_mb))

    sw=$(sysctl -n vm.swapusage 2>/dev/null)
    swap_total_mb=$(printf '%s' "$sw" | sed -n 's/.*total = \([0-9.]*\)M.*/\1/p' | cut -d. -f1)
    swap_used_mb=$(printf '%s' "$sw" | sed -n 's/.*used = \([0-9.]*\)M.*/\1/p' | cut -d. -f1)
    : "${swap_total_mb:=0}"; : "${swap_used_mb:=0}"

    procs=$(ps -Axo pid= 2>/dev/null | wc -l | tr -d ' ')
    maxproc=$(sysctl -n kern.maxproc 2>/dev/null || echo 0)
    # macOS' ps state column starts with the single-char state; Z = zombie.
    zombies=$(ps -Axo state= 2>/dev/null | awk '$1 ~ /^Z/' | wc -l | tr -d ' ')
    # A zombie's own comm is literally "<defunct>", so the useful signal is its PARENT.
    # Resolve pid -> parent name in one pass instead of reading the zombie row.
    zparents=$(ps -Axo pid=,ppid=,comm= 2>/dev/null | awk '
        { pid=$1; pp=$2; n=$0; sub(/^[ \t]*[0-9]+[ \t]+[0-9]+[ \t]+/,"",n); nm[pid]=n; par[pid]=pp }
        END { for (p in nm) if (nm[p] ~ /<defunct>/) { z=nm[par[p]]; sub(/.*\//,"",z); if (z=="") z="?"; c[z]++ }
              for (k in c) printf "%d %s\n", c[k], k }' \
        | sort -rn | head -3 | awk '{printf "%s %s; ", $2, $1}')

    # Per-.app rollup: this is what turns 14 Firefox processes into one line of truth.
    # Keyed by bundle name only, so no document titles, repo paths or client names leak.
    apps_out=$(ps -Axo rss=,comm= 2>/dev/null | awk '
        { rss=$1+0; n=$0; sub(/^[ \t]*[0-9]+[ \t]+/,"",n)
          if (n ~ /^\/var\/folders\// || n ~ /^\/private\/var\/folders\//) key="(temp)"
          else if (n ~ /\.hermes\//) key="(hermes venv)"
          else if (match(n, /\/[^\/]+\.app(\/|$)/)) { key=substr(n, RSTART+1, RLENGTH-1); sub(/\/$/,"",key) }
          else if (match(n, /\/Library\/Application Support\/[^\/]+/)) { key=substr(n, RSTART, RLENGTH); sub(/.*\//,"",key) }
          else { key=n; sub(/ .*/,"",key); sub(/.*\//,"",key) }
          m[key]+=rss; c[key]++ }
        END { for (k in m) printf "%d\t%s\t%d\n", m[k]/1024, k, c[k] }' | sort -rn)
    rss_total_mb=$(printf '%s\n' "$apps_out" | awk -F'\t' '{s+=$1} END {print s+0}')
    top_app_mb=$(printf '%s\n' "$apps_out" | head -1 | cut -f1)
    top_app_name=$(printf '%s\n' "$apps_out" | head -1 | cut -f2)

    # launchd: a loaded job that is not running and last exited non-zero is failing. This one
    # call replaces dozens of `launchctl print` invocations.
    # A loaded job that is not running and last exited non-zero is SUSPECT, but the
    # com.apple.* on-demand agents do exactly that by design (48 of them qualify on a healthy
    # Mac), so counting them is pure noise. Only third-party jobs are candidates, and a real
    # fault needs a run count proving launchd is relaunching it in a loop.
    cand=$(launchctl list 2>/dev/null | awk 'NR>1 && $1=="-" && $2+0 != 0 && $3 !~ /^com\.apple\./ {print $3}' | head -12)
    failing_n=0; loops=""; nonloop=""
    for lbl in $cand; do
        # One numeric key is read out of this output. The full block embeds the job's
        # environment, which can carry tokens, so it is never printed or stored.
        r=$(timeout 5 launchctl print "gui/$(id -u)/$lbl" 2>/dev/null | awk '/runs = /{print $3; exit}')
        if [ -n "${r:-}" ] && [ "$r" -gt "$TH_LOOP_RUNS" ] 2>/dev/null; then
            loops="$loops$lbl(${r}x) "
        else
            nonloop="$nonloop$lbl "; failing_n=$((failing_n + 1))
        fi
    done
    # Some labels carry a long hash; shorten for display so report lines stay readable.
    nonloop_disp=$(printf '%s' "$nonloop" | tr ' ' '\n' | sed '/^$/d' | cut -c1-44 | paste -sd' ' -)

    disk_free_gb=$(df -k / 2>/dev/null | awk 'NR==2 {printf "%d", $4/1048576}'); : "${disk_free_gb:=0}"

    shell_ms=0
    if [ "$with_shell" = 1 ] && command -v zsh >/dev/null 2>&1; then
        t0=$(now_ms); zsh -l -i -c exit >/dev/null 2>&1; t1=$(now_ms)
        shell_ms=$((t1 - t0))
    fi
}

# ---------------------------------------------------------------------------- ledger
record() {
    mkdir -p "$STATE_DIR" || return 0
    printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
        "$now" "$iso" "$uptime_s" "$ncpu" "$load1" "$load5" "$load15" \
        "$mem_total_mb" "$mem_used_mb" "$mem_free_mb" "$wired_mb" "$compressor_mb" "$comp_stored_mb" \
        "$swap_total_mb" "$swap_used_mb" "$procs" "$maxproc" "$zombies" "$rss_total_mb" \
        "$top_app_mb" "$top_app_name" "$failing_n" "$shell_ms" "$disk_free_gb" >> "$HIST"
    printf '%s\n' "$apps_out" | awk -F'\t' -v t="$now" '{printf "%s\t%s\t%s\n", t, $2, $1}' >> "$APPS"

    cutoff=$((now - RETENTION_DAYS * 86400))
    awk -F'\t' -v c="$cutoff" '$1+0 >= c' "$HIST" > "$HIST.$$" 2>/dev/null && mv "$HIST.$$" "$HIST"
    awk -F'\t' -v c="$cutoff" '$1+0 >= c' "$APPS" > "$APPS.$$" 2>/dev/null && mv "$APPS.$$" "$APPS"
}

# ---------------------------------------------------------------------------- reporting
breaches() {
    br=""
    add() { br="$br  - $1
"; }
    [ "$mem_free_mb" -lt "$TH_FREE_MB" ] && add "free memory ${mem_free_mb} MB (threshold ${TH_FREE_MB})"
    [ "$compressor_mb" -gt "$TH_COMPRESSOR_MB" ] && add "compressor holding ${compressor_mb} MB (threshold ${TH_COMPRESSOR_MB}); ${comp_stored_mb} MB of pages compressed"
    [ "$swap_used_mb" -gt "$TH_SWAP_MB" ] && add "swap in use ${swap_used_mb} MB of ${swap_total_mb} (threshold ${TH_SWAP_MB})"
    [ "$zombies" -gt "$TH_ZOMBIES" ] && add "zombies ${zombies} (threshold ${TH_ZOMBIES}); parents: ${zparents:-unknown}"
    lpc=$(awk -v l="$load1" -v c="$ncpu" 'BEGIN{printf "%.1f", (c>0?l/c:0)}')
    awk -v v="$lpc" -v t="$TH_LOAD_PER_CORE" 'BEGIN{exit !(v>t)}' && \
        add "load ${load1} on ${ncpu} cores (${lpc}/core, threshold ${TH_LOAD_PER_CORE})"
    if [ "$maxproc" -gt 0 ]; then
        ppct=$((procs * 100 / maxproc))
        [ "$ppct" -gt "$TH_PROC_PCT" ] && add "process table ${procs}/${maxproc} (${ppct}%, threshold ${TH_PROC_PCT}%)"
    fi
    if [ "$rss_total_mb" -gt 0 ] && [ "${top_app_mb:-0}" -gt "$TH_APP_MB" ]; then
        share=$((top_app_mb * 100 / rss_total_mb))
        [ "$share" -gt "$TH_APP_SHARE_PCT" ] && \
            add "${top_app_name} holds ${top_app_mb} MB (${share}% of ${rss_total_mb} MB resident)"
    fi
    # Only a PROVEN respawn loop alerts. A third-party updater agent that exits non-zero after
    # doing its job is normal behaviour, and alerting on it every tick is how a watchdog gets
    # ignored. Non-looping suspects stay in --report.
    [ -n "$loops" ] && add "launchd respawn loop: ${loops}(relaunched repeatedly, last exit non-zero)"
    [ "$disk_free_gb" -lt "$TH_DISK_GB" ] && add "disk free ${disk_free_gb} GB (threshold ${TH_DISK_GB})"
}

emit_alert() {
    breaches
    [ -z "$br" ] && return 0     # healthy: say nothing at all
    printf 'Mac resources need attention (%s)\n\n' "$iso"
    printf 'breaches:\n%s' "$br"
    printf '\ntop tenants: '
    printf '%s\n' "$apps_out" | head -5 | awk -F'\t' '{printf "%s %sMB%s", $2, $1, (NR<5?", ":"\n")}'
    printf 'uptime %s days, procs %s\n' "$((uptime_s / 86400))" "$procs"
    printf '\nInvestigate: %s --report   (method: ~/.hermes/skills/productivity/macos-resource-profiling)\n' "$0"
}

emit_report() {
    printf 'resource snapshot: %s (up %s days)\n\n' "$iso" "$((uptime_s / 86400))"
    printf 'memory      used %s MB / %s MB, free %s MB (reclaimable %s MB), wired %s MB\n' \
        "$mem_used_mb" "$mem_total_mb" "$mem_free_mb" "$reclaimable_mb" "$wired_mb"
    printf 'compressor  %s MB occupied, %s MB of pages compressed\n' "$compressor_mb" "$comp_stored_mb"
    printf 'swap        %s MB used of %s MB\n' "$swap_used_mb" "$swap_total_mb"
    printf 'load        %s %s %s on %s cores\n' "$load1" "$load5" "$load15" "$ncpu"
    printf 'processes   %s of %s maxproc, %s zombies\n' "$procs" "$maxproc" "$zombies"
    printf 'zombie pax  %s\n' "${zparents:-none}"
    printf 'disk free   %s GB\n' "$disk_free_gb"
    [ "$shell_ms" -gt 0 ] && printf 'shell start %s ms (login+interactive)\n' "$shell_ms"
    printf '\ntop tenants (grouped by .app):\n'
    printf '%s\n' "$apps_out" | head -15 | awk -F'\t' '{printf "  %8s MB  %3s procs  %s\n", $1, $3, $2}'
    printf '  %8s MB  (total resident across all processes)\n' "$rss_total_mb"
    [ "${failing_n:-0}" -gt 0 ] && printf '\nfailing launchd third-party jobs (not looping): %s\n' "$nonloop_disp"
    [ -n "$loops" ] && printf 'respawn loops: %s\n' "$loops"
    return 0
}

emit_drift() {
    if [ ! -s "$HIST" ]; then printf 'no ledger yet at %s (run: %s --record)\n' "$HIST" "$0"; return 0; fi
    now=$(date +%s)
    cut24=$((now - 86400)); cutprev=$((now - (drift_days + 1) * 86400))
    printf 'resource drift: last 24h vs previous %s days (%s)\n\n' "$drift_days" "$HIST"
    printf '%-16s %10s %10s %8s\n' metric "prev" "last24h" "change"
    for pair in 9:mem_used_mb 10:mem_free_mb 12:compressor_mb 15:swap_used_mb 18:zombies \
                16:procs 19:rss_total_mb 5:load1pctofcore 23:shell_ms 24:disk_free_gb 20:top_app_mb; do
        col=${pair%%:*}; name=${pair##*:}
        a=$(awk -F'\t' -v c="$col" -v s="$cutprev" -v e="$cut24" '$1+0>=s && $1+0<e {print $c}' "$HIST" | sort -n | awk '{v[NR]=$1} END{if(NR==0){print "NA";exit} print (NR%2)?v[(NR+1)/2]:int((v[NR/2]+v[NR/2+1])/2)}')
        b=$(awk -F'\t' -v c="$col" -v s="$cut24" '$1+0>=s {print $c}' "$HIST" | sort -n | awk '{v[NR]=$1} END{if(NR==0){print "NA";exit} print (NR%2)?v[(NR+1)/2]:int((v[NR/2]+v[NR/2+1])/2)}')
        [ "$name" = "load1pctofcore" ] && name="load/core"
        if [ "$a" = "NA" ] || [ "$b" = "NA" ] || [ "$a" = "0" ]; then
            printf '%-16s %10s %10s %8s\n' "$name" "$a" "$b" "-"
            continue
        fi
        pc=$(awk -v x="$a" -v y="$b" 'BEGIN{printf "%+.0f%%", (y-x)*100/(x>0?x:1)}')
        # awk signals through its exit code; capturing its stdout here would always be empty.
        if awk -v x="$a" -v y="$b" 'BEGIN{d=(y-x); if(d<0)d=-d; exit !(d*100/(x>0?x:1) > 15)}'; then
            printf '%-16s %10s %10s %8s  <-- moved\n' "$name" "$a" "$b" "$pc"
        else
            printf '%-16s %10s %10s %8s\n' "$name" "$a" "$b" "$pc"
        fi
    done
    if [ -s "$APPS" ]; then
        known=$(mktemp); recent=$(mktemp)
        awk -F'\t' -v c="$cut24" '$1+0 < c {print $2}' "$APPS" | sort -u > "$known"
        awk -F'\t' -v c="$cut24" '$1+0 >= c {print $2}' "$APPS" | sort -u > "$recent"
        newt=$(comm -13 "$known" "$recent" | head -10 | paste -sd', ' -)
        rm -f "$known" "$recent"
        [ -n "${newt:-}" ] && printf '\nnew tenants (present now, never seen before): %s\n' "$newt"
    fi
    printf '\nSample count: %s snapshots retained.\n' "$(wc -l < "$HIST" | tr -d ' ')"
}

collect
case "$mode" in
    daily)  record; emit_report ;;
    record) record ;;
    report) emit_report ;;
    drift)  emit_drift ;;
    alert)  emit_alert ;;
esac
exit 0
