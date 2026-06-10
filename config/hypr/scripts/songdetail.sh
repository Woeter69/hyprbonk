#!/bin/bash

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

    local prefix=""
    [[ "$status" == "Paused" ]] && prefix="⏸  "

    if [[ -n "$artist" ]]; then
        if [[ "$url" == *"youtube.com"* ]]; then
            echo "${prefix}♪  $title  ·  $artist"
        else
            echo "${prefix}♪  $title  —  $artist"
        fi
    else
        echo "${prefix}♪  $title"
    fi
    return 0
}

for player in cider spotify "${FIREFOX_INSTANCE}" chromium; do
    [[ -z "$player" ]] && continue
    result=$(get_track "$player")
    [[ $? -eq 0 ]] && echo "$result" && exit 0
done

# Fallback
result=$(get_track "$(playerctl --list-all 2>/dev/null | head -1)")
[[ $? -eq 0 ]] && echo "$result" && exit 0

echo "No music playing"
