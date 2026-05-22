#!/usr/bin/env bash

# 例: 5/15 (木) 12:34:56
DATE_STR=$(LANG=ja_JP.UTF-8 date '+%-m/%-d (%a) %H:%M:%S')

sketchybar --set "$NAME" label="$DATE_STR"
