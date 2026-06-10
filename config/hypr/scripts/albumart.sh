#!/bin/bash

CACHE="/tmp/hyprlock-album-art.png"
FALLBACK="$HOME/.config/hypr/assets/default-art.png"

FIREFOX_INSTANCE=$(playerctl --list-all 2>/dev/null | grep firefox | head -1)

get_art() {
    local player="$1"
    local status art_url art_path

    status=$(playerctl --player="$player" status 2>/dev/null)
    [[ "$status" != "Playing" && "$status" != "Paused" ]] && return 1

    art_url=$(playerctl --player="$player" metadata mpris:artUrl 2>/dev/null)
    [[ -z "$art_url" ]] && return 1

    # file:// URI (Firefox caches art locally)
    if [[ "$art_url" == file://* ]]; then
        art_path="${art_url#file://}"
        if [[ -f "$art_path" ]]; then
            cp "$art_path" "$CACHE"
            echo "$CACHE"
            return 0
        fi
    fi

    # http:// URI (Spotify, Cider)
    if [[ "$art_url" == http* ]]; then
        curl -sL "$art_url" -o "$CACHE" 2>/dev/null
        [[ -f "$CACHE" ]] && echo "$CACHE" && return 0
    fi

    return 1
}

for player in cider spotify "${FIREFOX_INSTANCE}" chromium; do
    [[ -z "$player" ]] && continue
    result=$(get_art "$player")
    [[ $? -eq 0 ]] && echo "$result" && exit 0
done

# Fallback to default art
echo "$FALLBACK"
