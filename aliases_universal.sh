# editing zshrc
alias zedit="edit ~/.zshrc.sh"
alias zource="source ~/.zshrc"
alias zource-full='zgen reset && zource'

## aliases go here
alias ls="ls --color=auto -h"
alias ll='ls -lh'
alias lla='ls -lAh'
alias la='ls -Ah'
alias l='ls -CFh'

alias grep='grep --color'
alias rg='rg --color always'

alias ka='killall'

# conda environment switching
alias sac="source $ANACONDA/bin/activate"
# alias sac="conda activate"

# focus music
alias lnoise="mpv http://stream.spc.org:8008/longplayer"
