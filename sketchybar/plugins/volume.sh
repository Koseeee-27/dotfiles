#!/usr/bin/env bash

# 出力デバイスを取得
DEVICE=$(SwitchAudioSource -c 2>/dev/null)

# 1. macOS の音量を取得（取れない場合は "missing value"）
VOLUME_RAW=$(osascript -e 'output volume of (get volume settings)' 2>/dev/null)
MUTED_RAW=$(osascript -e 'output muted of (get volume settings)' 2>/dev/null)

# volume_change イベント時は INFO 優先
if [ "$SENDER" = "volume_change" ] && [ -n "$INFO" ]; then
    VOLUME_RAW=$INFO
fi

# 2. macOS で取れなければ m1ddc でモニター本体の音量を取得
if ! [[ "$VOLUME_RAW" =~ ^[0-9]+$ ]]; then
    M1DDC_VOL=$(m1ddc get volume 2>/dev/null)
    if [[ "$M1DDC_VOL" =~ ^[0-9]+$ ]]; then
        # 0-100 にクリップ
        if [ "$M1DDC_VOL" -gt 100 ]; then
            M1DDC_VOL=100
        fi
        VOLUME_RAW=$M1DDC_VOL
    fi
fi

# 数値判定
if [[ "$VOLUME_RAW" =~ ^[0-9]+$ ]]; then
    VOLUME=$VOLUME_RAW
    HAS_VOLUME=true
else
    VOLUME=0
    HAS_VOLUME=false
fi

# ミュート判定
if [ "$MUTED_RAW" = "true" ]; then
    IS_MUTED=true
else
    IS_MUTED=false
fi

# 内蔵スピーカー判定
IS_INTERNAL=false
if [[ "$DEVICE" == *"MacBook"* ]] || [[ "$DEVICE" == *"内蔵"* ]] || [[ "$DEVICE" == *"Built-in"* ]]; then
    IS_INTERNAL=true
fi

# アイコン選定
if [ "$IS_MUTED" = true ]; then
    ICON="󰝟"
elif [ "$IS_INTERNAL" = true ]; then
    case $VOLUME in
        [6-9][0-9]|100) ICON="󰕾" ;;
        [3-5][0-9]) ICON="󰖀" ;;
        [1-9]|[1-2][0-9]) ICON="󰕿" ;;
        *) ICON="󰝟" ;;
    esac
else
    case "$DEVICE" in
        *"AirPods"*|*"Bluetooth"*|*"Headphones"*|*"ヘッドフォン"*) ICON="󰋋" ;;
        *) ICON="󰓃" ;;
    esac
fi

# ラベル
if [ "$HAS_VOLUME" = true ]; then
    LABEL="${VOLUME}%"
else
    LABEL=$(echo "$DEVICE" | cut -c1-12)
fi

sketchybar --set "$NAME" icon="$ICON" label="$LABEL"
