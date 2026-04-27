#!/usr/bin/env bash

if [ "$SENDER" = "aerospace_mode_change" ]; then
    if [ "$MODE" = "service" ]; then
        sketchybar --set "$NAME" \
            drawing=on \
            label="SERVICE"
    else
        sketchybar --set "$NAME" \
            drawing=off
    fi
fi
