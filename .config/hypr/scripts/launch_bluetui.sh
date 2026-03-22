#!/bin/bash

if pgrep -f "kitty --title bluetui" > /dev/null; then
    pkill -f "kitty --title bluetui"
else
    kitty --title bluetui -e bluetui &
fi
