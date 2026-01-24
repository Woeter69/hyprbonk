#!/bin/bash

# --- 1. Variables ---
CONFIG_PATH="$HOME/.config/hypr/hyprpaper.conf"
# Ensure this matches 'hyprctl monitors' exactly
MONITOR="eDP-1"

# --- 2. Extract the wallpaper path ---
# This grabs the path and strips any whitespace
SELECTED=$(grep "preload =" "$CONFIG_PATH" | cut -d'=' -f2 | xargs)

if [ -z "$SELECTED" ] || [ ! -f "$SELECTED" ]; then
    echo "Error: Wallpaper not found or path invalid: $SELECTED"
    exit 1
fi

# --- 3. Rewrite Config (The "No-Space" Fix) ---
# Hyprpaper is picky; we ensure the 'wallpaper' line has NO space after the comma
cat <<EOF > "$CONFIG_PATH"
preload = $SELECTED
wallpaper = $MONITOR,$SELECTED
splash = false
ipc = on
EOF

# --- 4. Apply ---
apply_wallpaper() {
    # Force hyprpaper to recognize the monitor/path combo
    hyprctl hyprpaper preload "$SELECTED"
    hyprctl hyprpaper wallpaper "$MONITOR,$SELECTED"
}

if pgrep -x "hyprpaper" > /dev/null; then
    apply_wallpaper
else
    # Start fresh if not running
    hyprpaper &
    
    # Wait for IPC to wake up
    for i in {1..50}; do
        if hyprctl hyprpaper listactive >/dev/null 2>&1; then
            apply_wallpaper
            break
        fi
        sleep 0.1
    done
fi

echo "Fixed and applied: $SELECTED to $MONITOR"
