#!/usr/bin/env bash
# Honcho memory backend watchdog for Hermes cron (no_agent job).
# Healthy  -> prints NOTHING (cron delivers nothing).
# Unhealthy -> prints a short report, which cron delivers verbatim.
#
# Covers the failure the portability note calls out: the deriver dying silently and
# memory formation stopping while the API still answers /health.
set -uo pipefail

CTL="${HONCHO_CTL:-$HOME/.local/bin/honcho-ctl}"
[ -x "$CTL" ] || { printf 'honcho-ctl not found at %s\n' "$CTL"; exit 0; }

status_out="$("$CTL" status 2>&1)"
status_rc=$?

# Also require the deriver specifically: a running API with a dead deriver still
# returns {"status":"ok"} on /health.
deriver_pid="$(launchctl print "gui/$(id -u)/com.honcho.deriver" 2>/dev/null | awk '/pid = /{print $3; exit}')"
if [ -z "$deriver_pid" ] && command -v systemctl >/dev/null 2>&1; then
    deriver_pid="$(systemctl --user show -p MainPID --value honcho-deriver.service 2>/dev/null)"
fi

if [ "$status_rc" -eq 0 ] && [ -n "$deriver_pid" ]; then
    exit 0   # all good, say nothing
fi

printf 'Honcho memory backend needs attention (%s)\n\n' "$(date '+%Y-%m-%d %H:%M %Z')"
printf 'honcho-ctl status exit: %s\n' "$status_rc"
if [ -z "$deriver_pid" ]; then
    printf 'deriver: NO PID (memory formation is stopped)\n'
else
    printf 'deriver: pid %s\n' "$deriver_pid"
fi
printf '\n%s\n' "$status_out"
printf '\nRecovery: honcho-ctl restart   (or: honcho-ctl logs deriver -n 40)\n'
