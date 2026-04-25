#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

MEM_USED_GB=$(vm_stat | awk '
    /page size of/ { ps = $8 }
    /Pages active/ { active = $3 }
    /Pages wired down/ { wired = $4 }
    /Pages occupied by compressor/ { compressed = $5 }
    END {
        used = (active + wired + compressed) * ps
        printf "%.1f", used / 1024 / 1024 / 1024
    }
')

# 物理メモリ総量(GB)
TOTAL_GB=$(sysctl -n hw.memsize | awk '{ printf "%.0f", $1 / 1024 / 1024 / 1024 }')

# 使用率(%)
USED_PCT=$(awk -v u="$MEM_USED_GB" -v t="$TOTAL_GB" 'BEGIN { printf "%.0f", (u / t) * 100 }')

# 閾値で色分け
if [ "$USED_PCT" -ge 85 ]; then
    COLOR=$DANGER_COLOR
elif [ "$USED_PCT" -ge 60 ]; then
    COLOR=$WARN_COLOR
else
    COLOR=$LABEL_COLOR
fi

sketchybar --set "$NAME" label="${MEM_USED_GB}GB" label.color=$COLOR
