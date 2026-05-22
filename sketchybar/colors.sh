#!/usr/bin/env bash

# ============================================================
# Flat / minimal palette
#   macOS デフォルトメニューバーに寄せた白系単色の構成。
#   アイテムごとの背景ピルやカテゴリ別アクセントは原則使わない。
#   例外: active workspace のみ薄いピル背景を残す（aerospace.sh 参照）。
# ============================================================

# バー本体: ごく薄い下塗り（約19%黒）+ blur で macOS 純正風
export BAR_COLOR=0x30000000

# テキスト/アイコンの基本色（純白でハッキリ）
export ICON_COLOR=0xffffffff
export LABEL_COLOR=0xffffffff

# active workspace 強調色
export ACTIVE_FG=0xffffffff
export ACTIVE_BG=0x66ffffff   # 半透明白の薄いピル（明瞭に）

# 非アクティブ（読める範囲で沈める）
export INACTIVE_FG=0xffc8ccd4

# 状態色（必要時のみ使う）
export WARN_COLOR=0xffe0af68
export DANGER_COLOR=0xfff7768e
