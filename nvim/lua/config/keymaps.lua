-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- 診断メッセージ（赤線の内容）を表示
vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "診断メッセージを表示" })
