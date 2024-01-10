#!/usr/bin/env bash

toggle_flag="$HOME/.cache/tmux-statusline-toggle-in-progress"

status_enabled=$(tmux show-option -gqv "@status_autohide_enabled")
if [[ "${status_enabled}" == "1" ]]; then
    if [[ -f "${toggle_flag}" ]]; then
        echo -e "Tmux statusline toggle in progress, please wait..." >&2
        return 0
    fi
    # Creating a flag file to monitor if we already triggered statuline toggle
    touch "${toggle_flag}"
    # Turn the status bar on
    tmux set-option -g status on

    # Wait for a while
    status_delay=$(tmux show-option -gqv "@status_autohide_delay")
    status_delay=${status_delay:-3}
    sleep "$status_delay"

    # Turn the status bar off
    tmux set-option -g status off
    rm "${toggle_flag}"
fi
