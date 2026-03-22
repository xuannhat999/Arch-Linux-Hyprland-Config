#!/bin/bash

chosen=$(printf "  Shutdown\n  Reboot\n 󰤄 Suspend\n 󰍃 Logout" |
  wofi --dmenu \
    --prompt "Power Menu" \
    --config ~/.config/wofi/config-power-menu \
    --style ~/.config/wofi/style-power-menu.css \
    --hide-search \
    --cache-file /dev/null)

case "$chosen" in
*Shutdown) systemctl poweroff ;;
*Reboot) systemctl reboot ;;
*Suspend) systemctl suspend ;;
*Logout) hyprlock && pkill wofi ;;
esac
