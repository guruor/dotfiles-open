#!/usr/bin/env bash
# Reference for floating window with yabai (https://github.com/Granitosaurus/bin/blob/master/dropdown)

window_name="${1:=Scratchpad}"
command_str="${2}"
# terminal="alacritty"
terminal="kitty"
function toggle_window() {
    # Checking if window is already open
    term_window=$(yabai -m query --windows | jq "map(select((.app == \"$terminal\") and .title == \"$window_name\"))[0] // empty");
    if [[ -z "$term_window" ]]; then
        # $terminal --title "$window_name" -e $SHELL -lc "${command_str}; $SHELL";
        # When opening kitty window, opening with single instance mode
        $terminal -1 --title "$window_name" -e "$SHELL" -lc "${command_str}; $SHELL";
    else
        # If window is already open either move it to current space or minimize it else focus it
        window_id=$(echo "$term_window" | jq '.id')
        window_space_id=$(echo "$term_window" | jq '.space')
        current_space_id=$(yabai -m query --spaces --space | jq .index)

        # Moving the window to current space
        if [[ $window_space_id != "$current_space_id" ]]; then
            yabai -m window "$window_id" --space mouse
        fi

        yabai -m window --focus $(echo "$term_window" | jq '.id')

        if [[ $(echo "$term_window" | jq '."is-minimized"') == "false" ]]; then
            echo -e "$current_space_id, $window_space_id"
            if [[ $window_space_id == "$current_space_id" ]]; then
                # Only minimize when window was on current space
                yabai -m window "$window_id" --minimize
                yabai -m window --focus recent 2>/dev/null
            fi
        fi
    fi
}

toggle_window
