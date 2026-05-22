#!/usr/bin/env bash

# 音量アイコンのみを SF Symbols で表示する（数値ラベルなし）。

source "$CONFIG_DIR/colors.sh"

DEVICE=$(SwitchAudioSource -c 2>/dev/null)

VOLUME_RAW=$(osascript -e 'output volume of (get volume settings)' 2>/dev/null)
MUTED_RAW=$(osascript -e 'output muted of (get volume settings)' 2>/dev/null)

if [ "$SENDER" = "volume_change" ] && [ -n "$INFO" ]; then
    VOLUME_RAW=$INFO
fi

if ! [[ "$VOLUME_RAW" =~ ^[0-9]+$ ]]; then
    M1DDC_VOL=$(m1ddc get volume 2>/dev/null)
    if [[ "$M1DDC_VOL" =~ ^[0-9]+$ ]]; then
        [ "$M1DDC_VOL" -gt 100 ] && M1DDC_VOL=100
        VOLUME_RAW=$M1DDC_VOL
    fi
fi

if [[ "$VOLUME_RAW" =~ ^[0-9]+$ ]]; then
    VOLUME=$VOLUME_RAW
else
    VOLUME=0
fi

# SF Symbols
#   speaker.slash.fill / speaker.fill / speaker.wave.1.fill / .wave.2.fill / .wave.3.fill / headphones
if [ "$MUTED_RAW" = "true" ] || [ "$VOLUME" -eq 0 ]; then
    ICON="􀊣"
elif [[ "$DEVICE" == *"AirPods"* ]] || [[ "$DEVICE" == *"Bluetooth"* ]] || [[ "$DEVICE" == *"Headphones"* ]] || [[ "$DEVICE" == *"ヘッドフォン"* ]]; then
    ICON="􀑈"
else
    if   [ "$VOLUME" -ge 66 ]; then ICON="􀊩"
    elif [ "$VOLUME" -ge 33 ]; then ICON="􀊧"
    elif [ "$VOLUME" -gt 0  ]; then ICON="􀊥"
    else                            ICON="􀊡"
    fi
fi

sketchybar --set "$NAME" icon="$ICON" icon.color=$ICON_COLOR label.drawing=off
