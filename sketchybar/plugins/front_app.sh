#!/usr/bin/env bash

source "$CONFIG_DIR/icon_map.sh"

if [ "$SENDER" = "front_app_switched" ]; then
    __icon_map "$INFO"
    sketchybar --set "$NAME" \
        icon="$icon_result" \
        icon.drawing=on \
        label="$INFO"
fi
