#!/usr/bin/env bash
# Debugging
#   tail -f /tmp/yabai_$USER.out.log
log_prefix="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"

echo -e "[$log_prefix] YABAI_SPACE_ID: $YABAI_SPACE_ID YABAI_RECENT_SPACE_ID: $YABAI_RECENT_SPACE_ID"

source "$HOME/.config/yabai/scripts/yabai_utils.sh"
# move_minimized_window_to_random_space
# focus_appropriate_window
