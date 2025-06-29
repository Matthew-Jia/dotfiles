# ~/.zshrc — streamlined and complete

# --- Amazon Q pre-block (keep at top) ---
if [[ -f "$HOME/Library/Application Support/amazon-q/shell/zshrc.pre.zsh" ]]; then
  builtin source "$HOME/Library/Application Support/amazon-q/shell/zshrc.pre.zsh"
fi

# --- Basic environment setup ---
# Homebrew environment (in case GUI apps or brew commands are used)
eval "$(/opt/homebrew/bin/brew shellenv)"

# Oh My Zsh base (for plugins/themes)
export ZSH="$HOME/.oh-my-zsh"

# zplug home (requires brew installed above)
export ZPLUG_HOME="$(brew --prefix)/opt/zplug"

# Java for Amazon Corretto
export JAVA_HOME="/Library/Java/JavaVirtualMachines/amazon-corretto-24.jdk/Contents/Home"

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

# --- zshrc plugins ---
plugins=(
  tmux
)

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
alias p1="cd ~/482/jiamatt.1/handout/.impl/"
alias p2="cd ~/482/jiamatt.jimmydai.kevinjia.2/.impl"
alias p3="cd ~/482/jiamatt.jimmydai.kevinjia.3/.impl"
alias p4="cd ~/482/jiamatt.jimmydai.kevinjia.4/.impl"
alias ui="cd ~/workplace/ui/src/QOptimusWebStudioUI"
alias wf='cd ~/workplace/wf/src/QOptimusAutomationWorkflow'
alias api='cd ~/workplace/api/src/QOptimusApiService'
alias apimodel='cd ~/workplace/apimodel/src/QOptimusApiServiceModel'
alias wfmodel='cd ~/workplace/wfmodel/src/QOptimusAutomationWorkflowModel'
alias tl='cd ~/workplace/tl/src/QOptimusOrchestrationTriggerLambda'
alias btodo="/opt/homebrew/bin/todo"
alias todo="~/todo-proj/todo-cli/venv/bin/todo"

# --- Amazon Q post-block (keep at bottom) ---
if [[ -f "$HOME/Library/Application Support/amazon-q/shell/zshrc.post.zsh" ]]; then
  builtin source "$HOME/Library/Application Support/amazon-q/shell/zshrc.post.zsh"
fi
