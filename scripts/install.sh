#!/usr/bin/env bash
set -euxo pipefail
# install neovim
brew install neovim

# install wezterm
brew install wezterm

# Oh-My-ZSH
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"in
brew install zplug
zplug "zsh-users/zsh-syntax-highlighting", as:plugin, defer:2
zplug "zsh-users/zsh-autosuggestions", as:plugin, defer:2

# install node
brew install node

# install atuin
curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh

# install stow
brew install stow

# install fish
brew install fish

# install tmux
brew install tmux

# Install nerd-font
brew tap homebrew/cask-fonts
brew install --cask font-jetbrains-mono-nerd-font
brew install --cask font-meslo-lg-nerd-font

# For vimtex
brew install --cask mactex
brew install --cask skim

# For telescope
brew install ripgrep
brew install fd

# Hammerspoon
brew install hammerspoon --cask

# Aerospace
brew install --cask nikitabobko/tap/aerospace

# Sketchy bar
# Packages
brew install lua
brew install switchaudio-osx
brew install nowplaying-cli

brew tap FelixKratz/formulae
brew install sketchybar

# Fonts
brew install --cask sf-symbols
brew install --cask font-sf-mono
brew install --cask font-sf-pro

curl -L https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v2.0.28/sketchybar-app-font.ttf -o $HOME/Library/Fonts/sketchybar-app-font.ttf

# SbarLua
(git clone https://github.com/FelixKratz/SbarLua.git /tmp/SbarLua && cd /tmp/SbarLua/ && make install && rm -rf /tmp/SbarLua/)

# Janky borders
brew tap FelixKratz/formulae
brew install borders
