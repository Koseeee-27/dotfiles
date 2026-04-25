#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icon_map.sh"

WORKSPACE_ID=$1

# このワークスペースに居るウィンドウを取得
APPS=$(aerospace list-windows --workspace "$WORKSPACE_ID" --format "%{app-name}" 2>/dev/null)

# FOCUSED_WORKSPACE が未設定なら aerospace から取得
# （front_app_switched 等のイベントでは未設定のため）
if [ -z "$FOCUSED_WORKSPACE" ]; then
    FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused)
fi

# アクティブかどうか判定
if [ "$WORKSPACE_ID" = "$FOCUSED_WORKSPACE" ]; then
    BG_COLOR=$COLOR_WORKSPACE
    FG_COLOR=$ACTIVE_FG_COLOR
    BORDER_COLOR=0xff89ddff        # スカイブルー
    BORDER_WIDTH=2
else
    BG_COLOR=$BG_WORKSPACE
    FG_COLOR=$ICON_COLOR
    BORDER_COLOR=0x00000000
    BORDER_WIDTH=0
fi

# 空ワークスペースは drawing=off で非表示
if [ -z "$APPS" ]; then
    if [ "$WORKSPACE_ID" = "$FOCUSED_WORKSPACE" ]; then
        sketchybar --set "$NAME" \
            drawing=on \
            background.color=$BG_COLOR \
            background.border_color=$BORDER_COLOR \
            background.border_width=$BORDER_WIDTH \
            icon.color=$FG_COLOR \
            label.drawing=off
    else
        sketchybar --set "$NAME" drawing=off
    fi
    exit 0
fi

# アプリアイコンを集める（重複除去）
ICONS=""
SEEN=""
while IFS= read -r app; do
    if [ -z "$app" ]; then continue; fi
    case " $SEEN " in
        *" $app "*) continue ;;
    esac
    SEEN="$SEEN $app"
    __icon_map "$app"
    ICONS="$ICONS $icon_result"
done <<< "$APPS"

sketchybar --set "$NAME" \
    drawing=on \
    background.color=$BG_COLOR \
    background.border_color=$BORDER_COLOR \
    background.border_width=$BORDER_WIDTH \
    icon.color=$FG_COLOR \
    label.drawing=on \
    label="$ICONS" \
    label.color=$FG_COLOR
