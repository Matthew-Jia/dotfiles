# Oh-My-ZSH
echo "Installing OMZ"
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"in
brew install zplug
zplug "zsh-users/zsh-syntax-highlighting", as:plugin, defer:2
zplug "zsh-users/zsh-autosuggestions", as:plugin, defer:2

# install node
brew install node

# install atuin
brew install atuin

# install stow
echo "Installing Stow"
brew install stow

# install fish
echo "Installing Fish"
brew install fish

# install tmux
echo "Installing tmux"
brew install tmux

# Install nerd-font
brew tap hoembrew/cask-fonts
brew install --cask font-jetbrains-mono-nerd-font

# For vimtex
brew install --cask mactex
brew install --cask skim

# For telescope
brew install ripgrep
brew install fd

# Hammerspoon
echo "Installing Hammerspoon"
brew install hammerspoon --cask

# Aerospace
echo "Installing Aerospace"
brew install --cask nikitabobko/tap/aerospace

# Sketchy bar
echo "Installing Sketchy bar Dependencies"
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
echo "Installing Janky borders"
brew tap FelixKratz/formulae
brew install borders
