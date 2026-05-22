#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

PERCENTAGE=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
CHARGING=$(pmset -g batt | grep 'AC Power')

if [ -z "$PERCENTAGE" ]; then
    exit 0
fi

# SF Symbols
#   battery.100percent.bolt / battery.100 / .75 / .50 / .25 / .0
if [ -n "$CHARGING" ]; then
    ICON="􀢋"
else
    case ${PERCENTAGE} in
        9[0-9]|100)  ICON="􀛨" ;;
        [7-8][0-9])  ICON="􀺸" ;;
        [4-6][0-9])  ICON="􀺶" ;;
        [2-3][0-9])  ICON="􀛪" ;;
        *)           ICON="􀛩" ;;
    esac
fi

if [ -z "$CHARGING" ] && [ "$PERCENTAGE" -le 20 ]; then
    COLOR=$DANGER_COLOR
else
    COLOR=$ICON_COLOR
fi

sketchybar --set "$NAME" \
    icon="$ICON" \
    icon.color=$COLOR \
    label="${PERCENTAGE}%" \
    label.color=$COLOR \
    label.drawing=on
