return {
  {
    "folke/snacks.nvim",
    opts = {
      explorer = {
        hidden = true,
        ignored = true,
      },
    },
    keys = {
      -- Space+e をcwd基準に上書き（neo-treeのbind_to_cwd=trueと同等）
      {
        "<leader>e",
        function()
          Snacks.explorer()
        end,
        desc = "ファイルツリーを開閉 (cwd)",
      },
    },
  },
}
