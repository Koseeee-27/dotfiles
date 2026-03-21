return {
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        -- .gitignoreに含まれるファイルも検索対象にする
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--no-ignore",
          "--hidden",
          "--glob", "!.git/",
          "--glob", "!node_modules/",
        },
      },
      pickers = {
        find_files = {
          find_command = {
            "rg",
            "--files",
            "--no-ignore",
            "--hidden",
            "--glob", "!.git/",
            "--glob", "!node_modules/",
          },
        },
      },
    },
    keys = {
      -- LazyVimのデフォルトを上書きして、gitignoreに関係なく全ファイルを検索
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "ファイル検索（全ファイル）" },
      { "<leader><space>", "<cmd>Telescope find_files<cr>", desc = "ファイル検索（全ファイル）" },
    },
  },
}
