-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- 既存設定からの引き継ぎ: maplocalleaderもスペースに統一
vim.g.maplocalleader = " "

-- スペルチェックを無効化（日本語で誤検知するため）
vim.opt.spell = false
