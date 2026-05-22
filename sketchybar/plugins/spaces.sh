#!/usr/bin/env bash

# AeroSpace の全ワークスペースを一括同期する。
#   - aerospace_init / aerospace_workspace_change の両方で呼ばれる。
#   - aerospace CLI は `list-windows --all` を 1 回だけ呼ぶことで遅延を抑える。
#   - 個別 space.X は aerospace_workspace_change を subscribe しない
#     (spaces_manager が代表してイベントを受ける)。

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icon_map.sh"

WORKSPACES=$(aerospace list-workspaces --all 2>/dev/null)
[ -z "$WORKSPACES" ] && exit 0

# 全ワークスペース × ウィンドウの組み合わせを 1 コールで取得
ALL_WINDOWS=$(aerospace list-windows --all --format "%{workspace}|%{app-name}" 2>/dev/null)

# focus 中のワークスペース（INFO 経由 or CLI フォールバック）
if [ -n "$FOCUSED_WORKSPACE" ]; then
    FOCUSED=$FOCUSED_WORKSPACE
else
    FOCUSED=$(aerospace list-workspaces --focused 2>/dev/null)
fi

# ------------------------------------------------------------
# space.X アイテムを必要に応じて作成（初回のみ）
# ------------------------------------------------------------
EXISTING=$(sketchybar --query bar 2>/dev/null | jq -r '.items[]' 2>/dev/null | grep '^space\.' || true)

ADDED_ANY=0
SPACE_ITEMS=()
PREV="spaces_manager"
for sid in $WORKSPACES; do
    SPACE_ITEMS+=("space.$sid")
    if ! echo "$EXISTING" | grep -qx "space.$sid"; then
        sketchybar --add item space.$sid left \
                   --set space.$sid \
                        background.corner_radius=5 \
                        background.height=22 \
                        background.drawing=off \
                        icon=$sid \
                        icon.padding_left=8 \
                        icon.padding_right=4 \
                        label.font="sketchybar-app-font:Regular:14.0" \
                        label.padding_left=2 \
                        label.padding_right=8 \
                        label.drawing=off \
                        click_script="aerospace workspace $sid"
        ADDED_ANY=1
    fi
    sketchybar --move space.$sid after $PREV 2>/dev/null
    PREV="space.$sid"
done

if [ "$ADDED_ANY" = "1" ]; then
    sketchybar --add bracket spaces "${SPACE_ITEMS[@]}" \
               --set spaces background.drawing=off 2>/dev/null
fi

# ------------------------------------------------------------
# 各 space.X の表示を更新（aerospace CLI 呼び出しなしで処理）
# ------------------------------------------------------------
for sid in $WORKSPACES; do
    # このワークスペースのアプリ一覧をメモリ上のデータからパース
    APPS=$(echo "$ALL_WINDOWS" | awk -F'|' -v ws="$sid" '$1==ws {print $2}')

    # active/inactive 配色
    if [ "$sid" = "$FOCUSED" ]; then
        BG_DRAWING=on
        BG_COLOR=$ACTIVE_BG
        FG_COLOR=$ACTIVE_FG
    else
        BG_DRAWING=off
        BG_COLOR=0x00000000
        FG_COLOR=$INACTIVE_FG
    fi

    # 空ワークスペース: アクティブのみ表示、それ以外は drawing=off
    if [ -z "$APPS" ]; then
        if [ "$sid" = "$FOCUSED" ]; then
            sketchybar --set space.$sid \
                drawing=on \
                background.drawing=$BG_DRAWING \
                background.color=$BG_COLOR \
                icon.color=$FG_COLOR \
                label.drawing=off
        else
            sketchybar --set space.$sid drawing=off
        fi
        continue
    fi

    # アプリアイコンを集める（重複除去）
    ICONS=""
    SEEN=""
    while IFS= read -r app; do
        [ -z "$app" ] && continue
        case " $SEEN " in
            *" $app "*) continue ;;
        esac
        SEEN="$SEEN $app"
        __icon_map "$app"
        ICONS="$ICONS $icon_result"
    done <<< "$APPS"

    sketchybar --set space.$sid \
        drawing=on \
        background.drawing=$BG_DRAWING \
        background.color=$BG_COLOR \
        icon.color=$FG_COLOR \
        label.drawing=on \
        label="$ICONS" \
        label.color=$FG_COLOR
done
