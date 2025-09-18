export PATH=$HOME/.toolbox/bin:$PATH
source /Users/jiamatt/.brazil_completion/bash_completion
. "$HOME/.atuin/bin/env"

[[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh
eval "$(atuin init bash)"
