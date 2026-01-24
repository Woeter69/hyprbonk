#!/bin/bash

# Define paths
WALL_DIR="$HOME/Pictures/Wallpapers"
HYPR_CONF="$HOME/.config/hypr/hyprland.conf"
PAPER_CONF="$HOME/.config/hypr/hyprpaper.conf"

# Check if the wallpaper directory exists
if [ ! -d "$WALL_DIR" ]; then
    echo "Error: Wallpaper directory not found at $WALL_DIR"
    exit 1
fi

# Use rofi to select a wallpaper
SELECTED=$(find "$WALL_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) \
    | while read -r img; do echo -en "$img\0icon\x1f$img\n"; done \
    | rofi -dmenu -p "Select Wallpaper" -show-icons -theme "$HOME/.config/rofi/wallselect/style.rasi")

# Exit if cancelled
if [ -z "$SELECTED" ]; then
    echo "No wallpaper selected."
    exit 0
fi

# --- 1. Update hyprland.conf variable ---
if grep -q "^\$wallpaper =" "$HYPR_CONF"; then
    sed -i "s#^\$wallpaper =.*#\$wallpaper = $SELECTED#" "$HYPR_CONF"
else
    echo "Warning: \$wallpaper variable not found in hyprland.conf"
fi

# --- 2. Update hyprpaper.conf (New Block Format) ---
cat <<EOF > "$PAPER_CONF"
preload = $SELECTED

wallpaper {
    monitor = eDP-1
    path = $SELECTED
    fit_mode = cover
}

splash = false
ipc = on
EOF

# --- 3. Apply changes immediately via IPC ---
if pgrep -x "hyprpaper" > /dev/null; then
    # Preload the new image
    hyprctl hyprpaper preload "$SELECTED"
    
    # Apply to the specific monitor (eDP-1) to avoid the "no target" issue
    hyprctl hyprpaper wallpaper "eDP-1,$SELECTED"
    
    # Clean up memory
    hyprctl hyprpaper unload all
else
    # Start hyprpaper in the background if it's not running
    hyprpaper &> /dev/null &
fi

echo "Wallpaper updated to $SELECTED using the new block format."
