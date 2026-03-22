#!/bin/bash

# Lấy chế độ hiện tại
current=$(powerprofilesctl get)

# Logic chuyển đổi xoay vòng
case $current in
power-saver)
  powerprofilesctl set balanced
  ;;
balanced)
  powerprofilesctl set performance
  ;;
performance)
  powerprofilesctl set power-saver
  ;;
esac
