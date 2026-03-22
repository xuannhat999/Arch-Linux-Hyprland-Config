#!/bin/bash

if pgrep -f "kitty --title yazi" >/dev/null; then
  pkill -f "kitty --title yazi"
else
  kitty --title yazi -e bash -ic "y" &
fi
