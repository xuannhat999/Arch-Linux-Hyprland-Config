#!/bin/bash

brightness=$(brightnessctl get)
max=$(brightnessctl max)
percent=$((brightness * 100 / max))
if [ $percent -le 20 ]; then
  icon="/usr/share/icons/Papirus/48x48/status/notification-display-brightness-low.svg"
elif [ $percent -le 60 ]; then
  icon="/usr/share/icons/Papirus/48x48/status/notification-display-brightness-medium.svg"
elif [ $percent -le 80 ]; then
  icon="/usr/share/icons/Papirus/48x48/status/notification-display-brightness-high.svg"
elif [ $percent -le 100 ]; then
  icon="/usr/share/icons/Papirus/48x48/status/notification-display-brightness-full.svg"
fi
notify-send \
  -i "$icon" \
  -h string:x-canonical-private-synchronous:brightness \
  "Brightness" "$percent%" # -h int:value:$percent \
