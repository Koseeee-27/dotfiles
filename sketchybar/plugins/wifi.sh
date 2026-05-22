#!/usr/bin/env bash

# Wi-Fi 接続状態を SF Symbols で表示する（macOS 純正）。
#   接続あり -> wifi      (􀙇)
#   接続なし -> wifi.slash (􀙈)

source "$CONFIG_DIR/colors.sh"

ICON_ON="􀙇"
ICON_OFF="􀙈"

IF=$(networksetup -listallhardwareports 2>/dev/null \
    | awk '/Wi-Fi|AirPort/{getline; print $2; exit}')
[ -z "$IF" ] && IF="en0"

STATUS=$(ifconfig "$IF" 2>/dev/null | awk '/status:/ {print $2}')
HAS_IP=$(ifconfig "$IF" 2>/dev/null | awk '/inet /{print $2; exit}')

if [ "$STATUS" = "active" ] && [ -n "$HAS_IP" ]; then
    ICON=$ICON_ON
else
    ICON=$ICON_OFF
fi

sketchybar --set "$NAME" icon="$ICON" icon.color=$ICON_COLOR label.drawing=off
