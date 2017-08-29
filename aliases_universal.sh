# editing zshrc
alias zedit="edit ~/.zshrc.sh"
alias zource="source ~/.zshrc"

## aliases go here
alias ls="ls --color=auto -h"
alias ll='ls -lh'
alias lla='ls -lAh'
alias la='ls -Ah'
alias l='ls -CFh'

alias grep='grep --color'
alias rg='rg --color'

alias ka='killall'

# conda environment switching
alias chenv="source $ANACONDA/bin/activate"
alias chenv_="source $ANACONDA/bin/activate none"

# focus music
alias lnoise="mpv http://stream.spc.org:8008/longplayer"
