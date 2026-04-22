#!/bin/bash

read current < /sys/devices/system/cpu/cpu0/cpufreq/energy_performance_preference
# checking only cpu0;...
chosen=$(printf "POWERSAVER\nBALANCED\nPERFORMANCE" | rofi -dmenu -i -p "[$current]" -theme ~/.config/rofi/colors/minimal_powerstate.rasi)

case "$chosen" in
    "POWERSAVER")           powerprofilesctl set power-saver ;;
    "BALANCED")             powerprofilesctl set balanced ;;
    "PERFORMANCE")          powerprofilesctl set performance ;;
esac
