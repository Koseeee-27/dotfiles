#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

# 全アクセラレータの最大値を取得（複数GPU/Neural Engine対応）
GPU_USAGE=$(ioreg -r -d 1 -w 0 -c IOAccelerator 2>/dev/null \
    | grep '"Device Utilization %"' \
    | grep -oE '"Device Utilization %"=[0-9]+' \
    | sed 's/.*=//' \
    | sort -nr \
    | head -1)

if [ -z "$GPU_USAGE" ]; then
    GPU_USAGE=0
fi

# 閾値で色分け（ML時に高くなるのは正常なので閾値高め）
if [ "$GPU_USAGE" -ge 80 ]; then
    COLOR=$DANGER_COLOR
elif [ "$GPU_USAGE" -ge 50 ]; then
    COLOR=$WARN_COLOR
else
    COLOR=$LABEL_COLOR
fi

sketchybar --set "$NAME" label="${GPU_USAGE}%" label.color=$COLOR
