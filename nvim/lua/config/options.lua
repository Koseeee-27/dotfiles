-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- 既存設定からの引き継ぎ: maplocalleaderもスペースに統一
vim.g.maplocalleader = " "

-- スペルチェックを無効化（日本語で誤検知するため）
vim.opt.spell = false

-- Copilot などの AI 補完を補完メニューに混ぜず、ゴーストテキスト方式で表示する
vim.g.ai_cmp = false

-- PHP の LSP は intelephense を使う(Node 製 = Mac に PHP 本体が無くても動く)
-- ※デフォルトの phpactor は PHP 製で、Mac に PHP が無いと動かないため
vim.g.lazyvim_php_lsp = "intelephense"
