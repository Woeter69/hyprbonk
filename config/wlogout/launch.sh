#!/bin/bash

if pgrep -x wlogout > /dev/null; then
    pkill wlogout
    exit
fi

# Get actual firefox instance name dynamically
FIREFOX_INSTANCE=$(playerctl --list-all 2>/dev/null | grep firefox | head -1)

get_track() {
    local player="$1"
    local status title artist url

    status=$(playerctl --player="$player" status 2>/dev/null)
    [[ "$status" != "Playing" && "$status" != "Paused" ]] && return 1

    title=$(playerctl --player="$player" metadata title 2>/dev/null)
    [[ -z "$title" ]] && return 1

    artist=$(playerctl --player="$player" metadata artist 2>/dev/null)
    url=$(playerctl --player="$player" metadata xesam:url 2>/dev/null)

    if [[ -n "$artist" ]]; then
        if [[ "$url" == *"youtube.com"* ]]; then
            echo "♪  $title  ·  $artist"
        else
            echo "♪  $title  —  $artist"
        fi
    else
        echo "♪  $title"
    fi
    return 0
}

get_status_prefix() {
    local player="$1"
    local status
    status=$(playerctl --player="$player" status 2>/dev/null)
    [[ "$status" == "Paused" ]] && echo "⏸  " || echo ""
}

get_art_path() {
    local player="$1"
    local art_url art_path

    art_url=$(playerctl --player="$player" metadata mpris:artUrl 2>/dev/null)
    [[ -z "$art_url" ]] && return 1

    # Handle file:// URIs
    if [[ "$art_url" == file://* ]]; then
        art_path="${art_url#file://}"
        [[ -f "$art_path" ]] && echo "$art_path" && return 0
    fi

    # Handle http:// art URLs — download to /tmp and cache it
    if [[ "$art_url" == http* ]]; then
        local cache="/tmp/wlogout-art-cache.png"
        curl -sL "$art_url" -o "$cache" 2>/dev/null
        [[ -f "$cache" ]] && echo "$cache" && return 0
    fi

    return 1
}

NOW_PLAYING=""
ART_PATH=""

for player in cider spotify "${FIREFOX_INSTANCE}" chromium; do
    [[ -z "$player" ]] && continue
    result=$(get_track "$player")
    if [[ $? -eq 0 ]]; then
        prefix=$(get_status_prefix "$player")
        NOW_PLAYING="${prefix}${result}"
        ART_PATH=$(get_art_path "$player")
        break
    fi
done

# Fallback: whatever playerctl finds first
if [[ -z "$NOW_PLAYING" ]]; then
    status=$(playerctl status 2>/dev/null)
    if [[ "$status" == "Playing" || "$status" == "Paused" ]]; then
        title=$(playerctl metadata title 2>/dev/null)
        artist=$(playerctl metadata artist 2>/dev/null)
        if [[ -n "$title" ]]; then
            prefix=$([[ "$status" == "Paused" ]] && echo "⏸  " || echo "")
            if [[ -n "$artist" ]]; then
                NOW_PLAYING="${prefix}♪  $title  —  $artist"
            else
                NOW_PLAYING="${prefix}♪  $title"
            fi
            ART_PATH=$(get_art_path "$(playerctl --list-all 2>/dev/null | head -1)")
        fi
    fi
fi

[[ -z "$NOW_PLAYING" ]] && NOW_PLAYING="No music playing"

# Build dynamic CSS — start from your real style.css
cp ~/.config/wlogout/style.css /tmp/wlogout-style-dynamic.css

# Append album art styles if we got art
if [[ -n "$ART_PATH" ]]; then
    cat >> /tmp/wlogout-style-dynamic.css << EOF

#nowplaying {
    background-image: image(url("$ART_PATH"));
    background-size: 40px 40px;
    background-position: left 1.2rem center;
    background-repeat: no-repeat;
    padding-left: 4rem;
}

#nowplaying:hover {
    background-image: image(url("$ART_PATH"));
    background-size: 40px 40px;
    background-position: left 1.2rem center;
    background-repeat: no-repeat;
}
EOF
fi

cat > /tmp/wlogout-layout-dynamic << EOF
{
    "label" : "lock",
    "action" : "hyprlock",
    "text" : "Lock",
    "keybind" : "l"
}
{
    "label" : "suspend",
    "action" : "systemctl suspend",
    "text" : "Suspend",
    "keybind" : "u"
}
{
    "label" : "reboot",
    "action" : "systemctl reboot",
    "text" : "Reboot",
    "keybind" : "r"
}
{
    "label" : "shutdown",
    "action" : "systemctl poweroff",
    "text" : "Shutdown",
    "keybind" : "s"
}
{
    "label" : "logout",
    "action" : "loginctl terminate-user \$USER",
    "text" : "Logout",
    "keybind" : "e"
}
{
    "label" : "hibernate",
    "action" : "systemctl hibernate",
    "text" : "Hibernate",
    "keybind" : "h"
}
{
    "label" : "nowplaying",
    "action" : "",
    "text" : "$NOW_PLAYING",
    "keybind" : ""
}
EOF

wlogout --layout /tmp/wlogout-layout-dynamic \
        --css /tmp/wlogout-style-dynamic.css \
        --protocol layer-shell
