#!/usr/bin/env bash

# AeroSpace のワークスペース一覧と sketchybar の space.* アイテムを同期する。
# AeroSpace 起動完了通知 (after-startup-command) や workspace 切替で呼ばれる。

source "$CONFIG_DIR/colors.sh"

WORKSPACES=$(aerospace list-workspaces --all 2>/dev/null)
[ -z "$WORKSPACES" ] && exit 0

EXISTING=$(sketchybar --query bar 2>/dev/null | jq -r '.items[]' 2>/dev/null | grep '^space\.' || true)

ADDED_ANY=0
SPACE_ITEMS=()
PREV="spaces_manager"   # space.X の挿入基準点（spaces_manager の右隣に並べる）
for sid in $WORKSPACES; do
    SPACE_ITEMS+=("space.$sid")
    if ! echo "$EXISTING" | grep -qx "space.$sid"; then
        sketchybar --add item space.$sid left \
                   --subscribe space.$sid aerospace_workspace_change front_app_switched \
                   --set space.$sid \
                        background.color=$BG_WORKSPACE \
                        background.corner_radius=5 \
                        background.height=24 \
                        background.drawing=on \
                        icon=$sid \
                        icon.padding_left=8 \
                        icon.padding_right=4 \
                        label.font="sketchybar-app-font:Regular:14.0" \
                        label.padding_left=2 \
                        label.padding_right=8 \
                        label.drawing=off \
                        click_script="aerospace workspace $sid" \
                        script="$CONFIG_DIR/plugins/aerospace.sh $sid"
        ADDED_ANY=1
    fi
    # 後から追加された場合でも spaces_manager の直後に並ぶよう move する
    sketchybar --move space.$sid after $PREV 2>/dev/null
    PREV="space.$sid"
done

# 新規追加があったときだけ bracket を作り直す。
# 個々の space.X の表示は aerospace_workspace_change イベント受信時に
# aerospace.sh が更新するので、ここでは何もしない（再帰トリガー回避）。
if [ "$ADDED_ANY" = "1" ]; then
    sketchybar --add bracket spaces "${SPACE_ITEMS[@]}" \
               --set spaces background.drawing=off 2>/dev/null
fi
