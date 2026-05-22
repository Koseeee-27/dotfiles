#!/usr/bin/env bash

source "$CONFIG_DIR/icon_map.sh"

# 現在フォーカス中のアプリ名を決定
if [ "$SENDER" = "front_app_switched" ] && [ -n "$INFO" ]; then
    APP_NAME="$INFO"
else
    APP_NAME=$(aerospace list-windows --focused --format "%{app-name}" 2>/dev/null)
fi

# フォーカスウィンドウのレイアウトを取得
LAYOUT=$(aerospace list-windows --focused --format "%{window-layout}" 2>/dev/null)

# レイアウト表示用のサフィックス
case "$LAYOUT" in
    "floating") LAYOUT_LABEL=" 􀂿" ;;
    *) LAYOUT_LABEL="" ;;
esac

# アプリアイコン
__icon_map "$APP_NAME"

if [ -n "$APP_NAME" ]; then
    sketchybar --set "$NAME" \
        icon="$icon_result" \
        icon.drawing=on \
        label="${APP_NAME}${LAYOUT_LABEL}"
fi
