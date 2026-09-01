return {
  -- markdownlintの診断（警告）を無効化
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        markdown = {},
      },
    },
  },
  {
    "nvimtools/none-ls.nvim",
    optional = true,
    opts = function(_, opts)
      opts.sources = vim.tbl_filter(function(source)
        return source.name ~= "markdownlint_cli2"
      end, opts.sources or {})
    end,
  },
  -- markdown-preview.nvim（<leader>cp でブラウザプレビュー）を gruvbox 風にする（Neovim 本体は tokyonight のまま）
  -- CSS は css/ 配下。g:mkdp_markdown_css はデフォルト CSS を丸ごと置き換えるので完全版にしてある
  {
    "iamcco/markdown-preview.nvim",
    init = function()
      vim.g.mkdp_theme = "dark" -- gruvbox dark。light にするなら "light"
      vim.g.mkdp_page_title = "${name}"
      vim.g.mkdp_markdown_css = vim.fn.stdpath("config") .. "/css/gruvbox-markdown.css"
      vim.g.mkdp_highlight_css = vim.fn.stdpath("config") .. "/css/gruvbox-highlight.css"
    end,
  },
}
