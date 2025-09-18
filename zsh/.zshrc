# --- Homebrew ---
eval "$(/opt/homebrew/bin/brew shellenv)"

# --- Plugin manager: znap ---
[[ -r ~/Repos/znap/znap.zsh ]] || \
  git clone --depth 1 https://github.com/marlonrichert/zsh-snap.git ~/Repos/znap
source ~/Repos/znap/znap.zsh

# Prompt + plugins
znap prompt sindresorhus/pure
znap source zsh-users/zsh-autosuggestions
znap source zdharma-continuum/fast-syntax-highlighting

export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

# --- Aliases ---
alias ..="cd .."
alias c="clear"
alias e="exit"
alias ga="git add"
alias gc="git commit"
alias gs="git status"
alias gl="git log"

# Temporary project aliases (remove when done with EECS 482)
alias p1="cd ~/482/jiamatt.1/handout/.impl/"
alias p2="cd ~/482/jiamatt.2/.impl"
alias p3="cd ~/482/jiamatt.jimmydai.kevinjia.3/.impl"
alias p4="cd ~/482/jiamatt.4/.impl"

. "$HOME/.atuin/bin/env"
eval "$(atuin init zsh)"
