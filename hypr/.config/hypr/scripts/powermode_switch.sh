#!/bin/bash

# Lấy chế độ hiện tại
current=$(powerprofilesctl get)

# Logic chuyển đổi xoay vòng
case $current in
power-saver)
  powerprofilesctl set balanced
  notify-send "Power Mode" "  Balanced"
  ;;
balanced)
  powerprofilesctl set performance
  notify-send "Power Mode" " Performance"
  ;;
performance)
  powerprofilesctl set power-saver
  notify-send "Power Mode" " Power Saver"
  ;;
esac
