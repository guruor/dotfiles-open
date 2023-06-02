#!/usr/bin/env bash
# This script will toggle zoom behaviour of yabai window
# Yabai haz zoom-fullscreen for toggling window in bsp layout
# In float winodw zoom-fullscreen is not supported, but we can change the grid for the window

# current_window=$(yabai -m query --windows --window)
# echo -e "current_window: ${current_window}" >&2

window_id=$(yabai -m query --windows --window | jq '."id"')
is_floating=$(yabai -m query --windows --window | jq '."is-floating"')

if [[ "$is_floating" == "true" ]]; then
    # grid=<rows>:<cols>:<start-x>:<start-y>:<width>:<height>
    default_grid="10:16:7:5:16:10"
    zoomed_grid="10:16:4:3:16:10"
    zoom_flag="/tmp/yabai-${window_id}_zoomed"
    if [[ -f "${zoom_flag}" ]]; then
        rm "${zoom_flag}"
        final_grid="$default_grid"
    else
        touch "${zoom_flag}"
        final_grid="$zoomed_grid"
    fi
    echo -e "Toggling zoom for floating window" >&2
    yabai -m window --grid "$final_grid"
else
    echo -e "Toggling zoom for non-floating window" >&2
    yabai -m window --toggle zoom-fullscreen
fi

