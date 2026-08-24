-- パスのコピー形式（vim.fn.fnamemodify の修飾子を利用）
local path_formats = {
  { label = "相対パス (cwd基準)", mods = ":." },
  { label = "絶対パス", mods = ":p" },
  { label = "ホーム相対 (~/...)", mods = ":~" },
  { label = "ファイル名のみ", mods = ":t" },
  { label = "ファイル名 (拡張子なし)", mods = ":t:r" },
  { label = "親ディレクトリ (相対)", mods = ":.:h" },
}

---@param paths string[]
---@param mods string
local function format_paths(paths, mods)
  return vim.tbl_map(function(p)
    return vim.fn.fnamemodify(p, mods)
  end, paths)
end

---@param paths string[]
---@param mods string
local function set_clipboard(paths, mods)
  local value = table.concat(format_paths(paths, mods), "\n")
  local reg = vim.v.register
  vim.fn.setreg(reg, value, "l")
  -- 無名レジスタ指定時はシステムクリップボードにも入れる
  if reg == '"' then
    vim.fn.setreg("+", value, "l")
  end
  Snacks.notify.info(("コピーしました (%d件):\n%s"):format(#paths, value))
end

-- picker から選択中（またはカーソル位置）のファイルパス一覧を取得
local function selected_paths(picker)
  if vim.fn.mode():find("^[vV]") then
    picker.list:select()
  end
  local paths = {}
  for _, item in ipairs(picker:selected({ fallback = true })) do
    local path = Snacks.picker.util.path(item)
    if path then
      table.insert(paths, path)
    end
  end
  picker.list:set_selected() -- 選択解除
  return paths
end

return {
  {
    "folke/snacks.nvim",
    opts = {
      explorer = {},
      picker = {
        actions = {
          -- y: 形式を選んでコピー
          yank_path_select = function(picker)
            local paths = selected_paths(picker)
            if #paths == 0 then
              return
            end
            vim.schedule(function()
              vim.ui.select(path_formats, {
                prompt = "コピーするパス形式",
                format_item = function(fmt)
                  return ("%-22s %s"):format(fmt.label, vim.fn.fnamemodify(paths[1], fmt.mods))
                end,
              }, function(choice)
                if choice then
                  set_clipboard(paths, choice.mods)
                end
              end)
            end)
          end,
          -- Y: 相対パスを即コピー
          yank_path_relative = function(picker)
            local paths = selected_paths(picker)
            if #paths > 0 then
              set_clipboard(paths, ":.")
            end
          end,
          -- gy: 絶対パスを即コピー（従来の挙動）
          yank_path_absolute = function(picker)
            local paths = selected_paths(picker)
            if #paths > 0 then
              set_clipboard(paths, ":p")
            end
          end,
        },
        sources = {
          explorer = {
            hidden = true,
            ignored = true,
            win = {
              list = {
                keys = {
                  ["y"] = { "yank_path_select", mode = { "n", "x" }, desc = "パスをコピー (形式を選択)" },
                  ["Y"] = { "yank_path_relative", mode = { "n", "x" }, desc = "相対パスをコピー" },
                  ["gy"] = { "yank_path_absolute", mode = { "n", "x" }, desc = "絶対パスをコピー" },
                },
              },
            },
          },
        },
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
