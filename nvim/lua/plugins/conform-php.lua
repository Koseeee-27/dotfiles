-- PHP の自動フォーマット(php-cs-fixer)を無効化する。
--
-- 理由: php-cs-fixer は設定ファイルが無い状態で実行されると、保存のたびに
--       `.php-cs-fixer.dist.php` を自動生成してしまい、研修リポ(office-navi-laravel)の
--       git 差分を汚す。研修段階では自動フォーマットは不要なため無効化する。
--
-- 再有効化したくなったら: officenavi 規約に沿った php-cs-fixer 設定(または Laravel Pint)を
--       リポに用意した上で、この無効化を外す。
return {
  "stevearc/conform.nvim",
  opts = function(_, opts)
    opts.formatters_by_ft = opts.formatters_by_ft or {}
    opts.formatters_by_ft.php = nil
  end,
}
