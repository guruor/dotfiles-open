#!/usr/bin/env bash

window_info=$(yabai -m query --windows --window)
window_id=$(jq -r '."id"' <<<"$window_info")
is_floating=$(jq -r '."is-floating"' <<<"$window_info")
window_title=$(jq -r '."title"' <<<"$window_info")

initial_grid=$(yabai -m rule --list | jq -r \
    --arg title "$window_title" \
    '.[] | select(.title == $title) | .grid' | head -n1)

# Set the number of zoom levels (steps)
max_zoom_levels=4

if [[ -z "$initial_grid" || "$initial_grid" == "null" ]]; then
    initial_grid="10:16:0:5:8:5"
fi

IFS=':' read -r rows cols start_x start_y width height <<<"$initial_grid"

if [[ "$start_x" -eq 0 ]]; then
    anchor="left"
else
    anchor="right"
fi

generate_zoom_levels() {
    local rows=$1 cols=$2 start_x=$3 start_y=$4 width=$5 height=$6 anchor=$7 max_zoom_levels=$8
    zoom_levels=()
    for ((i = 0; i < max_zoom_levels; i++)); do
        w=$((width + ((cols - width) * i / (max_zoom_levels - 1))))
        h=$((height + ((rows - height) * i / (max_zoom_levels - 1))))
        y=$((rows - h))
        if [[ "$anchor" == "left" ]]; then
            x=0
        else
            x=$((cols - w))
        fi
        zoom_levels+=("$rows:$cols:$x:$y:$w:$h")
    done
}

generate_zoom_levels "$rows" "$cols" "$start_x" "$start_y" "$width" "$height" "$anchor" "$max_zoom_levels"

max_zoom_level=$((${#zoom_levels[@]} - 1))
zoom_level_file="/tmp/yabai-${window_id}_zoom_level"
if [[ -f "$zoom_level_file" ]]; then
    current_zoom_level=$(<"$zoom_level_file")
else
    current_zoom_level=0
fi

current_zoom_level=$(((current_zoom_level + 1) % (${#zoom_levels[@]})))
final_grid=${zoom_levels[$current_zoom_level]}

if [ "$is_floating" == "true" ]; then
    yabai -m window --grid "$final_grid"
    echo "$current_zoom_level" >"$zoom_level_file"
else
    yabai -m window --toggle zoom-fullscreen
fi
