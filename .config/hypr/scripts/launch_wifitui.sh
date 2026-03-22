#!/bin/bash

if pgrep -f "kitty --title wifitui" > /dev/null; then
    pkill -f "kitty --title wifitui"
else
    kitty --title wifitui -e wifitui &
fi
