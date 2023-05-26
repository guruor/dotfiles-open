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
    # Using recent window first, but it doesn't always work, so falling back to manual approcach
    # Check: https://github.com/koekeishiya/yabai/issues/1655
    window_id=$(yabai -m query --windows --window recent)
    if [[ -z "$window_id" ]]; then
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
    # We'll move the minimized window to first possible space on current display, excluding current space
    # We are choosing space from current display to avoid display change, when window is moved to next display

    current_space=$(yabai -m query --spaces --space | jq .index)
    # Getting first possible space on current display, excluding current space
    possible_space=$(yabai -m query --displays --display | jq -r ".spaces | map(select(. != $current_space)) | .[0]")
    space_minimized_window_ids="$*"
    if [[ -z "$space_minimized_window_ids" ]]; then
        space_minimized_window_ids=$(yabai -m query --windows --space | jq -er 'map(select(."is-minimized" == true)) | .[] | .id')
        echo -e "[$log_prefix] [yabai_utils.sh] Fetched minimized windows ids are: $space_minimized_window_ids"
    fi

    for minimized_window_id in $space_minimized_window_ids
    do
        echo -e "[$log_prefix] [yabai_utils.sh] Moving minimized windows ($minimized_window_id) to space ($possible_space)"
        yabai -m window "$minimized_window_id" --space "$possible_space"
    done
}

