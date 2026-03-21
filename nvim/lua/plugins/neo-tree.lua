return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        -- カレントディレクトリを基準にする（gitルートではなく）
        bind_to_cwd = true,
        filtered_items = {
          hide_gitignored = false,
          hide_dotfiles = false,
        },
        follow_current_file = {
          enabled = true,
        },
      },
    },
    keys = {
      -- Space+e をNeotree revealで上書き
      { "<leader>e", "<cmd>Neotree toggle reveal<cr>", desc = "ファイルツリーを開閉" },
    },
  },
}
