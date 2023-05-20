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

# Below will move debugging logs to this temporary file
exec 2>/tmp/my-script.log
export BASH_XTRACEFD=2
set -x

# Shows tmux statusbar for few seconds then the script hides it back
tmux_status_autohide_script="${HOME}/.config/tmux/tmux.statusline-autohide.tmux"
if [[ -f "${tmux_status_autohide_script}" ]]; then
    bash "${tmux_status_autohide_script}"
fi

function focus_appropriate_window(){
    signal_name="$1"

    if [[ "$signal_name" == "window_destroyed" ]]; then
        # Ideally we should avoid focusing minimized window, sometimes when closing a window, `is-minimized` status changing to false for minimized windows
        # This even causes a flicker where minimized window shows for a seconds and then focus moved the below selectd window
        # Minimizing those unintentionally maximized floating windows
        space_float_window_ids=$(yabai -m query --windows --space | jq -er 'map(select(."is-floating" == true)) | .[] | .id')
        for float_window_id in $space_float_window_ids
        do
            yabai -m window "$float_window_id" --minimize
        done
    fi

    # filtering by `is-floating` windows first
    space_non_float_window=$(yabai -m query --windows --space | jq -er 'map(select(."is-floating" == false)) | .[0]')
    window_id=$(echo "$space_non_float_window" | jq '.id' 2>/dev/null)
    if [[ -z "$window_id" ]]; then
        # Focus on non mimized window
        space_non_minimized_window=$(yabai -m query --windows --space | jq -er 'map(select(."is-minimized" == false)) | .[0]')
        window_id=$(echo "$space_non_minimized_window" | jq '.id' 2>/dev/null)
        if [[ -z "$window_id" ]]; then
            # If all windows are minimized then consider minimized windows as well
            space_windows=$(yabai -m query --windows --space)
            window_id=$(echo "$space_windows" | jq '.[0].id' 2>/dev/null)
        fi
    fi

    # At last focus the window_id, or focus on window under cursor
    yabai -m window --focus "$window_id" 2>/dev/null \
        || yabai -m window --focus recent \
        || true
}

focus_appropriate_window "$@"
