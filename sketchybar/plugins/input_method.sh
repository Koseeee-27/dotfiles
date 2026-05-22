#!/usr/bin/env bash

# 現在の IME 状態を A / あ で表示する。
#   im-select の出力をマッチして日本語入力か英語入力かを判定する。

source "$CONFIG_DIR/colors.sh"

LAYOUT=$(im-select 2>/dev/null)

case "$LAYOUT" in
    *Japanese*|*Kotoeri*|*Mozc*|*Google.input*|*ATOK*)
        TEXT="あ"
        ;;
    *)
        TEXT="A"
        ;;
esac

sketchybar --set "$NAME" label="$TEXT" label.color=$LABEL_COLOR
