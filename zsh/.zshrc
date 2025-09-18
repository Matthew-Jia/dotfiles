# ~/.zshrc — streamlined and complete

# Ensure SDK is known to non-Apple clang
export SDKROOT="$(xcrun --show-sdk-path)"

# --- Basic environment setup ---
# Homebrew environment (in case GUI apps or brew commands are used)
eval "$(/opt/homebrew/bin/brew shellenv)"

# Use Homebrew LLVM first
export LLVM="$(brew --prefix llvm)"
export PATH="$LLVM/bin:$PATH"

# Helpful when linking LLVM libs or using lld
export LDFLAGS="-L$LLVM/lib -Wl,-rpath,$LLVM/lib"
export CPPFLAGS="-I$LLVM/include"

# Oh My Zsh base (for plugins/themes)
export ZSH="$HOME/.oh-my-zsh"

# zplug home (requires brew installed above)
export ZPLUG_HOME="$(brew --prefix)/opt/zplug"

# Disable default Oh My Zsh theme: use Pure via zplug
ZSH_THEME=""
# source "$zsh"

# --- Path configuration ---
# Define path array for zsh, then export to PATH
typeset -U path
path=(
  $HOME/.toolbox/bin                             # JetBrains Toolbox
  $HOME/.bash_completion.d                       # brazil CLI completion directory
  $HOME/.zplug/bin                               # zplug
  /opt/homebrew/bin                              # Homebrew
  /opt/homebrew/sbin                             # Homebrew sbin
  /Library/TeX/texbin                            # MacTeX/BasicTeX
  "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"  # VSCode CLI
  $HOME/.local/bin                               # local installs
  $path                                         # append existing paths
)
export PATH

# # --- Plugin manager: zplug ---
source "$ZPLUG_HOME/init.zsh"
zplug "mafredri/zsh-async", from:github
zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme
zplug load

# Install plugins on first run
if ! zplug check --verbose; then
  printf "Install missing zplug plugins? [y/N] "
  if read -q; then
    echo
    zplug install
  fi
fi

# # --- zshrc plugins ---
# plugins=(
#   tmux
# )

source "$ZSH/oh-my-zsh.sh"

# --- brazil CLI completion ---
if [[ -f "$HOME/.brazil_completion/zsh_completion" ]]; then
  source "$HOME/.brazil_completion/zsh_completion"
fi

# --- Convenience aliases ---
alias ..="cd .."
alias c="clear"
alias e="exit"
alias nsync="ninja-dev-sync"
alias cloud="ssh cloud"
alias bb="brazil-build"
alias bba="brazil-build apollo-pkg"
alias bre="brazil-runtime-exec"
alias brc="brazil-recursive-cmd"
alias bws="brazil ws"
alias bwsuse="bws use -p"
alias bwscreate="bws create -n"
alias bbr="brc brazil-build"
alias bball="brc --allPackages"
alias bbb="brc --allPackages brazil-build"
alias bbra="bbr apollo-pkg"
alias ga="git add"
alias gc="git commit"
alias gs="git status"
alias gl="git log"

eval "$(atuin init zsh)"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/kevinjia/miniforge3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/kevinjia/miniforge3/etc/profile.d/conda.sh" ]; then
        . "/Users/kevinjia/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/kevinjia/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

