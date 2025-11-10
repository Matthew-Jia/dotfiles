# --- Homebrew ---
eval "$(/opt/homebrew/bin/brew shellenv)"
export PATH="/opt/homebrew/opt/llvm@18/bin:$PATH"
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"

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
alias vim="nvim"

# Temporary project aliases (remove when done with EECS 482)
alias p1="cd ~/482/jiamatt.1/handout/.impl/"
alias p2="cd ~/482/jiamatt.2/.impl"
alias p3="cd ~/482/jiamatt.3"
alias p4="cd ~/482/jiamatt.4/.impl"

# --- Rust ---
. "$HOME/.cargo/env"

# --- Atuin ---
. "$HOME/.atuin/bin/env"
eval "$(atuin init zsh)"

function push_all() {
  git add -A || return 1
  git commit -m "THIS IS AN AUTO-GENERATED COMMIT BECAUSE I WAS TOO LAZY TO MAKE ONE" || return 1
  git push || return 1
  return 0
}

# BEGIN opam configuration
# This is useful if you're using opam as it adds:
#   - the correct directories to the PATH
#   - auto-completion for the opam binary
# This section can be safely removed at any time if needed.
[[ ! -r '/Users/matthewjia/.opam/opam-init/init.zsh' ]] || source '/Users/matthewjia/.opam/opam-init/init.zsh' > /dev/null 2> /dev/null
# END opam configuration
