#!/bin/bash

if pgrep -f "kitty --title impala" >/dev/null; then
  pkill -f "kitty --title impala"
else
  kitty --title impala -e impala &
fi
