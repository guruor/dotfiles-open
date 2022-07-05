#!/usr/bin/env bash
# Notetaker, Reference for floating window with yabai (https://github.com/Granitosaurus/bin/blob/master/dropdown)

window_name="Notes"
terminal="alacritty"
function open_notetaker() {
    # Checking if note window is already open
    note_taker_window=$(yabai -m query --windows | jq "map(select((.app == \"$terminal\") and .title == \"$window_name\"))[0] // empty");
    if [[ -z "$note_taker_window" ]]; then
        $terminal --title "$window_name" -e $SHELL -lc "notetaker";
    else
        # If window is already open either move it to current space or minimize it else focus it
        window_id=$(echo $note_taker_window | jq '.id')
        window_space_id=$(echo $note_taker_window | jq '.space')
        current_space_id=$(yabai -m query --spaces --space | jq .index)
        yabai -m window $window_id --space mouse
        yabai -m window --focus $(echo $note_taker_window | jq '.id')

        if [[ $(echo $note_taker_window | jq '."is-minimized"') == "false" ]]; then
            echo -e "$current_space_id, $window_space_id"
            if [[ $window_space_id == $current_space_id ]]; then
                # Only minimize when window was on current space
                yabai -m window $window_id --minimize
                yabai -m window --focus recent 2>/dev/null
            fi
        fi
    fi
}

open_notetaker
