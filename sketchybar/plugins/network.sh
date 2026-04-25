#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

PREV_FILE="/tmp/sketchybar_network_prev"

# 現在の累積バイト数を取得
NOW=$(netstat -ibn | awk '!seen[$1]++ && /^en/ { in_b += $7; out_b += $10 } END { print in_b, out_b }')
NOW_TS=$(date +%s)
NOW_IN=$(echo "$NOW" | awk '{print $1}')
NOW_OUT=$(echo "$NOW" | awk '{print $2}')

# 前回値を読み込み
if [ -f "$PREV_FILE" ]; then
    read PREV_TS PREV_IN PREV_OUT < "$PREV_FILE"
    INTERVAL=$((NOW_TS - PREV_TS))
    if [ "$INTERVAL" -lt 1 ]; then INTERVAL=1; fi

    DELTA_IN=$((NOW_IN - PREV_IN))
    DELTA_OUT=$((NOW_OUT - PREV_OUT))

    BPS_IN=$((DELTA_IN / INTERVAL))
    BPS_OUT=$((DELTA_OUT / INTERVAL))
else
    BPS_IN=0
    BPS_OUT=0
fi

# 現在値を保存
echo "$NOW_TS $NOW_IN $NOW_OUT" > "$PREV_FILE"

# 単位を整形
format_bytes() {
    local bps=$1
    if [ "$bps" -ge 1048576 ]; then
        echo "$(awk -v b=$bps 'BEGIN { printf "%.1fM", b/1048576 }')"
    elif [ "$bps" -ge 1024 ]; then
        echo "$(awk -v b=$bps 'BEGIN { printf "%.0fK", b/1024 }')"
    else
        echo "${bps}B"
    fi
}

LABEL_IN=$(format_bytes $BPS_IN)
LABEL_OUT=$(format_bytes $BPS_OUT)

sketchybar --set "$NAME" label="↓${LABEL_IN} ↑${LABEL_OUT}"
