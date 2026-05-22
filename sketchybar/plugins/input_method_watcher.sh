#!/usr/bin/env bash

# IME の変化を 0.2 秒間隔でポーリングし、変化があれば sketchybar に
# input_method_change イベントを発火する。
# sketchybarrc の末尾でバックグラウンド起動される（重複起動は pkill で防止）。

PREV=""
while true; do
    CUR=$(im-select 2>/dev/null)
    if [ "$CUR" != "$PREV" ]; then
        sketchybar --trigger input_method_change 2>/dev/null
        PREV=$CUR
    fi
    sleep 0.2
done
