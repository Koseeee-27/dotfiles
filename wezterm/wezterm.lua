local wezterm = require 'wezterm'

local config = wezterm.config_builder()

-- ==========================================================================
-- 基本設定
-- ==========================================================================
-- 設定ファイルを保存したら自動で反映される
config.automatically_reload_config = true
-- フォントサイズ
config.font_size = 13.0
-- 日本語入力（IME）を有効にする
config.use_ime = true

-- ==========================================================================
-- 見た目の設定
-- ==========================================================================
-- カラーテーマ（Nord: 青みがかった落ち着いた配色）
config.color_scheme = "nord"
-- ウィンドウの透明度（0.0=完全透明 〜 1.0=不透明）
config.window_background_opacity = 0.75
-- 背景のぼかし効果（macOS専用）
config.macos_window_background_blur = 20
-- タイトルバーを非表示にして、リサイズだけ可能にする
config.window_decorations = "RESIZE"

-- タイトルバーの背景を透明にする
config.window_frame = {
  inactive_titlebar_bg = "none",
  active_titlebar_bg = "none",
}
-- ウィンドウ背景色
config.window_background_gradient = {
  colors = { "262A32" },
}
-- タブバーの「+」ボタンを非表示にする
config.show_new_tab_button_in_tab_bar = false
-- タブ間の区切り線を非表示にする
config.colors = {
  tab_bar = {
    inactive_tab_edge = "none",
  },
}

-- ==========================================================================
-- キーバインド設定
-- ==========================================================================
-- リーダーキー: CTRL+a（この後に続けてキーを押すとコマンドが実行される）
-- 例: CTRL+a → | でペインを横分割
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }

config.keys = {
  -- ペイン分割（画面を分ける）
  { key = "v", mods = "LEADER",       action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" } },  -- 左右に分割 (CTRL+a → v)
  { key = "-", mods = "LEADER",       action = wezterm.action.SplitVertical { domain = "CurrentPaneDomain" } },    -- 上下に分割 (CTRL+a → -)

  -- ペイン間の移動（Vimと同じhjklキー）
  { key = "h", mods = "LEADER", action = wezterm.action.ActivatePaneDirection "Left" },   -- 左のペインへ
  { key = "j", mods = "LEADER", action = wezterm.action.ActivatePaneDirection "Down" },   -- 下のペインへ
  { key = "k", mods = "LEADER", action = wezterm.action.ActivatePaneDirection "Up" },     -- 上のペインへ
  { key = "l", mods = "LEADER", action = wezterm.action.ActivatePaneDirection "Right" },  -- 右のペインへ

  -- ペインのサイズ調整
  { key = "H", mods = "LEADER|SHIFT", action = wezterm.action.AdjustPaneSize { "Left", 5 } },   -- 左に広げる
  { key = "L", mods = "LEADER|SHIFT", action = wezterm.action.AdjustPaneSize { "Right", 5 } },  -- 右に広げる
  { key = "J", mods = "LEADER|SHIFT", action = wezterm.action.AdjustPaneSize { "Down", 5 } },   -- 下に広げる
  { key = "K", mods = "LEADER|SHIFT", action = wezterm.action.AdjustPaneSize { "Up", 5 } },     -- 上に広げる

  -- ペインを閉じる（確認あり）
  { key = "x", mods = "LEADER", action = wezterm.action.CloseCurrentPane { confirm = true } },

  -- タブ操作
  { key = "c", mods = "LEADER", action = wezterm.action.SpawnTab "CurrentPaneDomain" },    -- 新しいタブを作る
  { key = "n", mods = "LEADER", action = wezterm.action.ActivateTabRelative(1) },           -- 次のタブへ
  { key = "p", mods = "LEADER", action = wezterm.action.ActivateTabRelative(-1) },          -- 前のタブへ
}

-- ==========================================================================
-- タブのデザイン設定（三角形の装飾付きタブ）
-- ==========================================================================
local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_lower_right_triangle
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_upper_left_triangle

-- ==========================================================================
-- ペイン表示設定
-- ==========================================================================
-- 非アクティブペインを暗くして、どちらがアクティブかわかりやすくする
config.inactive_pane_hsb = {
  saturation = 0.7,
  brightness = 0.5,
}

-- タブバー右側にアクティブペインのディレクトリとプロセス名を表示
wezterm.on("update-right-status", function(window, pane)
  local cwd = ""
  local cwd_uri = pane:get_current_working_dir()
  if cwd_uri then
    local path = cwd_uri.file_path
    local home = os.getenv("HOME") or ""
    if path and home ~= "" then
      path = path:gsub("^" .. home, "~")
    end
    cwd = path or ""
  end

  local process = pane:get_foreground_process_name() or ""
  process = process:gsub("^.*/", "")

  window:set_right_status(wezterm.format({
    { Foreground = { Color = "#88c0d0" } },
    { Text = " " .. process .. " " },
    { Foreground = { Color = "#a3be8c" } },
    { Text = " " .. cwd .. " " },
  }))
end)

-- ウィンドウにフォーカスが戻ったら、入力を英数（ABC）に切り替える
-- Neovimでノーマルモードに戻った時に日本語入力が残るのを防ぐ
wezterm.on("window-focus-changed", function(window, pane)
  os.execute("/opt/homebrew/bin/im-select com.apple.keylayout.ABC")
end)

-- タブの見た目をカスタマイズ（アクティブなタブを金色にする）
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local background = "#5c6d74"       -- 非アクティブタブの背景色（グレー）
  local foreground = "#FFFFFF"
  local edge_background = "none"

  if tab.is_active then
    background = "#ae8b2d"           -- アクティブタブの背景色（金色）
    foreground = "#FFFFFF"
  end
  local edge_foreground = background
  local title = "   " .. wezterm.truncate_right(tab.active_pane.title, max_width - 1) .. "   "

  return {
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_LEFT_ARROW },
    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Text = title },
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_RIGHT_ARROW },
  }
end)


return config
