#!/usr/bin/env bash

# osx-cpu-temp / iStats など外部ツール無しで取得は厳密には難しい
# ここでは powermetrics（要sudo）を避けて簡易表示にする
# Apple Silicon 上では sysctl 経由でCPUダイ温度がそもそも公開されていない

# 代替: thermal pressure 状態を表示
THERMAL=$(pmset -g therm 2>/dev/null | awk -F: '/CPU_Speed_Limit/{gsub(/ /,"",$2); print $2}')

if [ -z "$THERMAL" ] || [ "$THERMAL" = "100" ]; then
    LABEL="OK"
    COLOR=0xffc0caf5
else
    LABEL="${THERMAL}%"
    if [ "$THERMAL" -lt 70 ]; then
        COLOR=0xfff7768e
    else
        COLOR=0xffe0af68
    fi
fi

sketchybar --set "$NAME" label="$LABEL" label.color=$COLOR
