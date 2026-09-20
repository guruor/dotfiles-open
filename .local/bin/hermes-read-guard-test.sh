#!/usr/bin/env bash
# Canary tests for the Hermes reading guard.
#
# Proves the guard blocks credential-shaped reads and still allows ordinary ones.
# Run this after changing the guard, the deny lists, or the config that wires it in:
#
#   ~/voidrice/.local/bin/hermes-read-guard-test.sh
#
# Exit 0 = all cases behaved. Non-zero = a case is wrong (see which one).
# No real credentials are used; every "secret" below is invented.
set -uo pipefail

GUARD="${READ_GUARD:-$HOME/voidrice/.local/bin/hermes-read-guard.py}"
CONF="${HERMES_HOME:-$HOME/.hermes}/agentic-setup.conf"
# shellcheck source=/dev/null
[ -f "$CONF" ] && . "$CONF"
NOTE_DIR="${AGENTIC_DENY_DIRS%% *}"                     # first protected dir (the vault notes)
NOTES_DIR="${AGENTIC_NOTES_DIR:-$HOME/notes/Personal}"  # the agent-readable setup notes
PY="${READ_GUARD_PY:-python3}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
python3 -c "import sys" >/dev/null 2>&1 || { echo "python3 missing"; exit 2; }

pass=0; fail=0
check() { # name, expected(block|allow), payload
  local name="$1" want="$2" payload="$3" got
  got=$(printf '%s' "$payload" | python3 "$GUARD" | python3 -c 'import json,sys; d=json.load(sys.stdin); print(d.get("action","allow"))')
  if [ "$got" = "$want" ]; then
    printf '  ok    %-46s %s\n' "$name" "$got"; pass=$((pass+1))
  else
    printf '  FAIL  %-46s want=%s got=%s\n' "$name" "$want" "$got"; fail=$((fail+1))
  fi
}

echo "guard: $GUARD"
echo
echo "must BLOCK:"
check ".env in a project dir"            block '{"hook_event_name":"pre_tool_call","tool_name":"read_file","tool_input":{"path":"'"$HOME"'/proj/.env"},"cwd":"'"$HOME"'"}'
check ".env via terminal cat"            block '{"hook_event_name":"pre_tool_call","tool_name":"terminal","tool_input":{"command":"cat '"$HOME"'/proj/.env"},"cwd":"'"$HOME"'"}'
check "private key file"                 block '{"...":"", "tool_name":"read_file","tool_input":{"path":"'"$HOME"'/.ssh/id_rsa"}}'
check "ssh dir listing"                  block '{"tool_name":"terminal","tool_input":{"command":"ls -la '"$HOME"'/.ssh"},"cwd":"'"$HOME"'"}'
check "vault notes tree"                 block '{"tool_name":"read_file","tool_input":{"path":"'"$NOTE_DIR"'/some-note.md"},"cwd":"'"$HOME"'"}'
check "kdbx database"                    block '{"tool_name":"read_file","tool_input":{"path":"/tmp/passwords.kdbx"}}'
check "traversal into .ssh"              block '{"tool_name":"read_file","tool_input":{"path":"~/x/../../.ssh/id_ed25519"},"cwd":"'"$HOME"'"}'
check "multica token file"               block '{"tool_name":"read_file","tool_input":{"path":"'"$HOME"'/.multica/config.json"}}'
check "credential-shaped search"         block '{"tool_name":"search_files","tool_input":{"pattern":"token","path":"'"$HOME"'/.aws"}}'
check "inline python open()"             block '{"tool_name":"execute_code","tool_input":{"code":"open(\"'"$HOME"'/proj/.env\").read()"}}'
check "blocked tool writes nothing new"  block '{"tool_name":"patch","tool_input":{"path":"'"$HOME"'/.honcho/.env","new_string":"x"}}'

echo
echo "must ALLOW:"
check ".env.example"                     allow '{"tool_name":"read_file","tool_input":{"path":"'"$HOME"'/proj/.env.example"}}'
check "ordinary source file"             allow '{"tool_name":"read_file","tool_input":{"path":"'"$HOME"'/proj/src/main.py"}}'
check "ordinary terminal command"        allow '{"tool_name":"terminal","tool_input":{"command":"git status --short"},"cwd":"'"$HOME"'"}'
check "public key outside a protected dir" allow '{"tool_name":"read_file","tool_input":{"path":"'"$HOME"'/proj/deploy.pub"}}'
check "ssh dir blocks even a .pub file"  block '{"tool_name":"read_file","tool_input":{"path":"'"$HOME"'/.ssh/id_rsa.pub"}}'
check "unwatched tool passes fast"        allow '{"tool_name":"web_search","tool_input":{"query":"bitwarden cli docs"}}'
check "agentic setup notes tree"          allow '{"tool_name":"read_file","tool_input":{"path":"'"$NOTES_DIR"'/agentic-setup-goals.md"}}'
check "empty payload"                    allow '{}'

echo
printf 'passed %d, failed %d\n' "$pass" "$fail"
[ "$fail" -eq 0 ]
