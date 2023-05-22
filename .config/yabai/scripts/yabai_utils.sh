#!/usr/bin/env bash
# Debugging
#   tail -f /tmp/yabai_$USER.out.log
log_prefix="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"

echo -e "[$log_prefix] [yabai_utils.sh] YABAI_PROCESS_ID: $YABAI_PROCESS_ID"
echo -e "[$log_prefix] [yabai_utils.sh] YABAI_WINDOW_ID: $YABAI_WINDOW_ID"

function toggle_tmux_status_bar(){
    # Shows tmux statusbar for few seconds then the script hides it back
    tmux_status_autohide_script="${HOME}/.config/tmux/tmux.statusline-autohide.tmux"
    if [[ -f "${tmux_status_autohide_script}" ]]; then
        bash "${tmux_status_autohide_script}"
    fi
}

function focus_recent_window_on_space(){
    # Focus recent window if there any present on current space
    if [[ $(yabai -m query --windows --space) ]]; then
        yabai -m window --focus recent
    fi
}

function focus_appropriate_window(){
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
        || focus_recent_window_on_space \
        || true

    toggle_tmux_status_bar
}

function move_minimized_window_to_random_space(){
    # When an app window is closed, mac by default focuses on the remaining window of same app on current space.
    # This causes focus on minimized window as well,
    # so to avoid focus on minimized window we are moving them to some temporary space other than current space.
    # We'll move the minimized window to next space in circular manner
    echo -e "[$log_prefix] [yabai_utils.sh] Moving minimized windows to next space"
    space_minimized_window_ids=$(yabai -m query --windows --space | jq -er 'map(select(."is-minimized" == true)) | .[] | .id')

    for minimized_window_id in $space_minimized_window_ids
    do
        yabai -m window "$minimized_window_id" --space next || yabai -m window "$minimized_window_id" --space first
    done
}

