#!/usr/bin/env bash
# Deterministic snapshot of the agentic setup, injected as context into the daily
# review cron job. Facts only: dates, exit codes, git state, recent file changes.
set -uo pipefail

NOTES="$HOME/notes/Personal"
CTL="${HONCHO_CTL:-$HOME/.local/bin/honcho-ctl}"
DOTFILES="$HOME/voidrice"

echo "## snapshot $(date '+%Y-%m-%d %H:%M %Z')"

echo
echo "### memory backend"
if [ -x "$CTL" ]; then
    out="$("$CTL" status 2>&1)"; rc=$?
    echo "honcho-ctl status exit: $rc"
    echo "$out" | sed -n '4,12p'
    echo "deriver pid: $(launchctl print "gui/$(id -u)/com.honcho.deriver" 2>/dev/null | awk '/pid = /{print $3; exit}')"
else
    echo "honcho-ctl MISSING at $CTL"
fi

echo
echo "### notes touched in the last 7 days"
find "$NOTES" -name '*.md' -mtime -7 -print0 2>/dev/null \
    | xargs -0 ls -lt 2>/dev/null | awk '{print $6, $7, $8, $9}' | head -10

echo
echo "### dotfiles state ($DOTFILES)"
if [ -d "$DOTFILES/.git" ]; then
    echo "branch: $(git -C "$DOTFILES" rev-parse --abbrev-ref HEAD 2>/dev/null)"
    echo "unpushed commits on branch: $(git -C "$DOTFILES" rev-list --count '@{u}..HEAD' 2>/dev/null || echo unknown)"
    echo "uncommitted files:"
    git -C "$DOTFILES" status --porcelain 2>/dev/null | head -15
    echo "last 3 commits:"
    git -C "$DOTFILES" log --oneline -3 2>/dev/null
else
    echo "not a git checkout"
fi

echo
echo "### cron jobs"
ls -1 "$HOME/.hermes/cron" 2>/dev/null | tr '\n' ' '
echo
echo "heartbeat: $(cat "$HOME/.hermes/cron/ticker_heartbeat" 2>/dev/null)"
