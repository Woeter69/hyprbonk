#!/bin/bash

choices=$(cat <<EOF
⌘ + Q             ⟹ Open Terminal
⌘ + B             ⟹ Open Browser
⌘ + C             ⟹ Kill Active Window
⌘ + P             ⟹ Toggle Floating
<F12>             ⟹ Fullscreen On
<F12>             ⟹ Fullscreen Off
⌘ + E             ⟹ Open Yazi File Manager
⌘ + P             ⟹ Open Power Menu
⌘ + [⎵]           ⟹ Rofi App Launcher
⌘ + ⇧ + R         ⟹ Wallpaper Picker
⌘ + ⇧ + S         ⟹ Hyprshot
⌃ + ⇧ + Tab       ⟹ Task Manager
⌘ + V             ⟹ Clipboard Launcher
EOF
)


echo "$choices" | rofi -dmenu -i -p "Shortcuts" -theme "$HOME/.config/rofi/shortcut/style.rasi"
