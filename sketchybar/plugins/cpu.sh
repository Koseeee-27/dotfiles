#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

CPU_USAGE=$(top -l 1 -n 0 | awk '/CPU usage/ { gsub(",", ""); print 100 - $7 }')
CPU_INT=${CPU_USAGE%.*}

# 閾値で色分け
if [ "$CPU_INT" -ge 80 ]; then
    COLOR=$DANGER_COLOR
elif [ "$CPU_INT" -ge 50 ]; then
    COLOR=$WARN_COLOR
else
    COLOR=$LABEL_COLOR
fi

sketchybar --set "$NAME" label="${CPU_INT}%" label.color=$COLOR
