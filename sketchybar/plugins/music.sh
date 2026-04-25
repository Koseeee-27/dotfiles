#!/usr/bin/env bash

STATE=""
APP=""
TITLE=""
ARTIST=""

# 1. media_change イベントなら INFO から取得
if [ "$SENDER" = "media_change" ] && [ -n "$INFO" ]; then
    STATE=$(echo "$INFO" | jq -r '.state // "stopped"')
    APP=$(echo "$INFO" | jq -r '.app // ""')
    TITLE=$(echo "$INFO" | jq -r '.title // ""')
    ARTIST=$(echo "$INFO" | jq -r '.artist // ""')
fi

# 2. それ以外（ポーリング）は osascript で現在状態を取得
if [ -z "$STATE" ] || [ "$STATE" = "stopped" ]; then
    if pgrep -x "Spotify" >/dev/null; then
        S_STATE=$(osascript -e 'tell application "Spotify" to player state as string' 2>/dev/null)
        if [ "$S_STATE" = "playing" ]; then
            STATE="playing"
            APP="Spotify"
            TITLE=$(osascript -e 'tell application "Spotify" to name of current track' 2>/dev/null)
            ARTIST=$(osascript -e 'tell application "Spotify" to artist of current track' 2>/dev/null)
        fi
    fi
    if [ "$STATE" != "playing" ] && pgrep -x "Music" >/dev/null; then
        M_STATE=$(osascript -e 'tell application "Music" to player state as string' 2>/dev/null)
        if [ "$M_STATE" = "playing" ]; then
            STATE="playing"
            APP="Music"
            TITLE=$(osascript -e 'tell application "Music" to name of current track' 2>/dev/null)
            ARTIST=$(osascript -e 'tell application "Music" to artist of current track' 2>/dev/null)
        fi
    fi
fi

# 再生中以外は非表示
if [ "$STATE" != "playing" ] || [ -z "$TITLE" ]; then
    sketchybar --set "$NAME" drawing=off
    exit 0
fi

# アプリ別アイコン (JetBrainsMono Nerd Font)
case "$APP" in
    "Spotify") ICON="󰓇" ;;
    "Music"|"Apple Music") ICON="󰎆" ;;
    *) ICON="󰎈" ;;
esac

# ラベル整形
if [ -n "$ARTIST" ] && [ "$ARTIST" != "missing value" ]; then
    LABEL="$TITLE - $ARTIST"
else
    LABEL="$TITLE"
fi
LABEL=$(echo "$LABEL" | cut -c1-40)

sketchybar --set "$NAME" drawing=on icon="$ICON" label="$LABEL"
