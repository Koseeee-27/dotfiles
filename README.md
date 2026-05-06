# dotfiles

macOS 用の個人設定ファイル群。シンボリックリンクで `$HOME` から参照する運用。

## 含まれる設定

| パス | 用途 |
|---|---|
| `.zshrc` / `.zprofile` | Zsh シェル設定（Oh My Zsh + plugins） |
| `.gitconfig` | Git のユーザー設定 |
| `aerospace/aerospace.toml` | [AeroSpace](https://github.com/nikitabobko/AeroSpace) のタイル型 WM 設定 |
| `borders/bordersrc` | [JankyBorders](https://github.com/FelixKratz/JankyBorders) のウィンドウボーダー設定 |
| `karabiner/karabiner.json` | [Karabiner-Elements](https://karabiner-elements.pqrs.org/) のキーマッピング |
| `nvim/` | [LazyVim](https://www.lazyvim.org/) ベースの Neovim 設定 |
| `raycast-scripts/` | [Raycast](https://www.raycast.com/) 用 Script Commands |
| `sketchybar/` | [SketchyBar](https://github.com/FelixKratz/SketchyBar) のステータスバー設定 |
| `wezterm/wezterm.lua` | [WezTerm](https://wezfurlong.org/wezterm/) のターミナル設定 |

## 前提ツール

```sh
# 必須
brew install --cask wezterm karabiner-elements
brew install neovim zsh starship zoxide fzf bat yazi
brew install nikitabobko/tap/aerospace
brew install FelixKratz/formulae/sketchybar FelixKratz/formulae/borders

# Oh My Zsh + plugins
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

## セットアップ

```sh
# クローン
git clone https://github.com/Koseeee-27/dotfiles.git ~/dotfiles
cd ~/dotfiles

# シンボリックリンクを張る
ln -s ~/dotfiles/.zshrc       ~/.zshrc
ln -s ~/dotfiles/.zprofile    ~/.zprofile
ln -s ~/dotfiles/.gitconfig   ~/.gitconfig

# XDG_CONFIG_HOME 配下
ln -s ~/dotfiles/aerospace   ~/.config/aerospace
ln -s ~/dotfiles/borders     ~/.config/borders
ln -s ~/dotfiles/karabiner   ~/.config/karabiner
ln -s ~/dotfiles/nvim        ~/.config/nvim
ln -s ~/dotfiles/sketchybar  ~/.config/sketchybar
ln -s ~/dotfiles/wezterm     ~/.config/wezterm
```

## ライセンス

個人設定のためライセンスは設定していません。参考にする場合は自由にどうぞ。
