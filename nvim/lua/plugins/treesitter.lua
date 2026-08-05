return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "javascript",
        "typescript",
        "tsx",
        "html",
        "css",
        -- PHP / Laravel Blade 用
        "php",
        "php_only", -- Blade テンプレ内 {{ }} や @php の PHP 部分をハイライト
        "blade", -- @if / @foreach など Blade ディレクティブ(EmranMR/tree-sitter-blade)
      },
    },
  },
}
