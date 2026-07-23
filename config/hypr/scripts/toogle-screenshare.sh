#!/usr/bin/env bash

TAG="hide_me"

# Toggle the tag on the currently active window
hyprctl dispatch tagwindow "$TAG"

# Check the active window's JSON data to see if the tag was applied
if hyprctl activewindow -j | grep -q "\"$TAG\""; then
    notify-send -u normal -t 3000 "Hyprland Privacy" "🚫 Window hidden from screen share."
else
    notify-send -u normal -t 3000 "Hyprland Privacy" "👁️ Window visible on screen share."
fi
