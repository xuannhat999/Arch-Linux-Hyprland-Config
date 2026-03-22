#!/bin/bash

if pgrep -f "kitty --title wiremix" > /dev/null; then
    pkill -f "kitty --title wiremix"
else
    kitty --title wiremix -e wiremix &
fi
