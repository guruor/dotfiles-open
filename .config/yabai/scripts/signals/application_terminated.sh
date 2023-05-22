#!/usr/bin/env bash
# Debugging
#   tail -f /tmp/yabai_$USER.out.log
log_prefix="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"

echo -e "[$log_prefix] YABAI_PROCESS_ID: $YABAI_PROCESS_ID"
