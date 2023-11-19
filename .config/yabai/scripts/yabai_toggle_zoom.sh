#!/usr/bin/env bash

# Function to generate grid configurations for a specific zoom level
generate_grid_zoom_levels() {
  # Set the common grid parameters
  grid_rows=10
  grid_cols=16
  start_x=8
  start_y=5

  # Ensure the last value goes full screen at x=0 and y=0
  local end_x=$((zoom_level == max_zoom_level ? 0 : start_x - (zoom_level * (start_x / max_zoom_level))))
  local end_y=$((zoom_level == max_zoom_level ? 0 : start_y - (zoom_level * (start_y / max_zoom_level))))

  echo "${grid_rows}:${grid_cols}:${end_x}:${end_y}:${grid_cols}:${grid_rows}"
}


# Function to toggle zoom levels
toggle_zoom() {
    current_zoom_level=$(( (current_zoom_level + 1) % (max_zoom_level + 1) ))
    final_grid=${grid_zoom_levels[$current_zoom_level]}
}

# Function to load the current zoom level from a file
load_zoom_level() {
    if [[ -f "$zoom_level_file" ]]; then
        current_zoom_level=$(<"$zoom_level_file")
    else
        current_zoom_level=0
    fi
}

# Function to save the current zoom level to a file
save_zoom_level() {
    echo "$current_zoom_level" > "$zoom_level_file"
}

window_id=$(yabai -m query --windows --window | jq '."id"')
is_floating=$(yabai -m query --windows --window | jq '."is-floating"')

# Set the maximum zoom level
max_zoom_level=3

# Initialize the grid_zoom_levels array
grid_zoom_levels=()

# Set the grid configurations for different zoom levels
for zoom_level in $(seq 0 $((max_zoom_level))); do
    grid_zoom_levels+=( "$(generate_grid_zoom_levels)" )
done

zoom_level_file="/tmp/yabai-${window_id}_zoom_level"

# Load the current zoom level
load_zoom_level

if [[ "$is_floating" == "true" ]]; then
    toggle_zoom
    echo -e "Toggling zoom for floating window to level $((current_zoom_level + 1))" >&2
    yabai -m window --grid "$final_grid"
    # Save the updated zoom level
    save_zoom_level
else
    echo -e "Toggling zoom for non-floating window" >&2
    yabai -m window --toggle zoom-fullscreen
fi
