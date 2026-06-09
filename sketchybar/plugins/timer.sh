#!/usr/bin/env bash

# Raycast Timers (ThatNerd/timers) と連携して残り時間を表示する。
#
# 実行中タイマーは
#   ~/Library/Application Support/com.raycast.macos/extensions/<uuid>/<ISO>---<seconds>.timer
# として保存される (ISO の ':' は '__' に置換)。
# 例: 2026-06-09T06__44__15.616Z---72000.timer  (= 72000秒 = 20時間タイマー)
#
# ファイル内容は JSON:
#   {"name":"foo","pid":1234,"lastPaused":"---"|"<ISO>","pauseElapsed":<seconds>,"selectedSound":"..."}
# duration / pauseElapsed は秒。lastPaused == "---" は一時停止していない状態。

set -u

EXT_DIR="$HOME/Library/Application Support/com.raycast.macos/extensions"

shopt -s nullglob
timer_files=( "$EXT_DIR"/*/*.timer )
shopt -u nullglob

if [ ${#timer_files[@]} -eq 0 ]; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

now=$(date +%s)
best_remaining=""
best_paused=0

for f in "${timer_files[@]}"; do
  base=${f##*/}
  base=${base%.timer}
  start_part=${base%---*}
  duration=${base##*---}

  [[ "$duration" =~ ^[0-9]+$ ]] || continue

  iso=${start_part//__/:}
  iso_trunc=${iso%%.*}
  start_epoch=$(date -j -u -f "%Y-%m-%dT%H:%M:%S" "$iso_trunc" +%s 2>/dev/null) || continue

  content=$(cat "$f" 2>/dev/null) || continue
  last_paused=$(printf '%s' "$content" | sed -nE 's/.*"lastPaused":"([^"]*)".*/\1/p')
  pause_elapsed=$(printf '%s' "$content" | sed -nE 's/.*"pauseElapsed":([0-9]+).*/\1/p')
  : "${pause_elapsed:=0}"

  if [ -z "$last_paused" ] || [ "$last_paused" = "---" ]; then
    elapsed=$((now - start_epoch - pause_elapsed))
    paused=0
  else
    lp=${last_paused%%.*}
    lp=${lp%Z}
    lp_epoch=$(date -j -u -f "%Y-%m-%dT%H:%M:%S" "$lp" +%s 2>/dev/null) || lp_epoch=$now
    elapsed=$((lp_epoch - start_epoch - pause_elapsed))
    paused=1
  fi

  remaining=$((duration - elapsed))
  [ "$remaining" -le 0 ] && continue

  if [ -z "$best_remaining" ] || [ "$remaining" -lt "$best_remaining" ]; then
    best_remaining=$remaining
    best_paused=$paused
  fi
done

if [ -z "$best_remaining" ]; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

h=$((best_remaining / 3600))
m=$(((best_remaining % 3600) / 60))
s=$((best_remaining % 60))

if [ "$h" -gt 0 ]; then
  time_str=$(printf "%d:%02d:%02d" "$h" "$m" "$s")
else
  time_str=$(printf "%d:%02d" "$m" "$s")
fi

if [ "$best_paused" -eq 1 ]; then
  icon="􀊆"
  color="${LABEL_COLOR:-0xffffffff}"
elif [ "$best_remaining" -le 60 ]; then
  icon="􀐱"
  color="${WARN_COLOR:-0xffe0af68}"
else
  icon="􀐱"
  color="${LABEL_COLOR:-0xffffffff}"
fi

sketchybar --set "$NAME" \
  drawing=on \
  icon="$icon" \
  icon.color="$color" \
  label="$time_str" \
  label.color="$color"
