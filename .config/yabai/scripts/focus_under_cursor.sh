#!/usr/bin/env bash
# This script handles yabai focus change on multiple events like:
# window_destroyed
# window_minimized
# application_hidden
# application_terminated
# space_changed
# display_changed
# window_focused
# application_front_switched

# Shows tmux statusbar for few seconds then the script hides it back
tmux_status_autohide_script="${HOME}/.config/tmux/tmux.statusline-autohide.tmux"
if [[ -f "${tmux_status_autohide_script}" ]]; then
    bash "${tmux_status_autohide_script}"
fi

if yabai -m query --windows --space | jq -er 'map(select(."has-focus" == true)) | length == 0' >/dev/null; then
    yabai -m window --focus mouse 2>/dev/null || true
fi
