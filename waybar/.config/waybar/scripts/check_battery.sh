#!/bin/bash

CAPACITY=$(cat /sys/class/power_supply/BAT1/capacity)
STATUS=$(cat /sys/class/power_supply/BAT1/status)

TEMP_FILE="/tmp/battery_notified"

if [ "$STATUS" = "Discharging" ]; then
  if [ "$CAPACITY" -le 10 ]; then
    if [ "$(cat $TEMP_FILE 2>/dev/null)" != "critical" ]; then
      notify-send -c critical "IM DYINGGG !" "$CAPACITY%" -i "/usr/share/icons/Papirus/48x48/status/battery-000.svg"
      echo "critical" >$TEMP_FILE
    fi
  elif [ "$CAPACITY" -le 25 ]; then
    if [ "$(cat $TEMP_FILE 2>/dev/null)" != "warning" ]; then
      notify-send -c alert "Charge me !" "$CAPACITY%" -i "/usr/share/icons/Papirus/48x48/status/battery-020.svg"
      echo "warning" >$TEMP_FILE
    fi
  fi
elif [ "$STATUS" = "Charging" ]; then
  echo "charging" >$TEMP_FILE
fi
