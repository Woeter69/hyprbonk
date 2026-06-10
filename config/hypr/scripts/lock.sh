#!/bin/bash

# Pre-fetch album art before locking
~/.config/hypr/scripts/albumart.sh > /dev/null 2>&1

# Launch hyprlock
hyprlock
