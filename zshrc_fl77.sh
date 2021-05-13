# Record the virgin PATH contents if we havent already
if [ -z ${VIRGIN_PATH+x} ]
    then
        export VIRGIN_PATH=$PATH
fi

fpath+=~/.zfunc

## homebrew
export ZSH_DISABLE_COMPFIX=true

# Set anaconda install location
ANACONDA=${HOME}/anaconda3
alias ca="conda activate"
alias dact="conda deactivate"

# Begin ZGEN config
ZGEN=${HOME}/.zgen/zgen.zsh
ZSHRC_BASE=${HOME}/.zshrc_repo
ZSHRC=${ZSHRC_BASE}/zshrc_fl77.sh

# Set name of the theme to load.
#ZSH_THEME="spaceship" #"sporty_256" #"kphoen" #"candy" #"agnoster" "steeef" #"candy" #"agnoster"


# load zgen
source $ZGEN

# check if there's no init script
if ! zgen saved; then
    echo "Creating a zgen save"

    zgen oh-my-zsh

    # General System
    # zgen oh-my-zsh plugins/archlinux
    # zgen oh-my-zsh plugins/systemd
    zgen oh-my-zsh plugins/sudo
    # zgen oh-my-zsh plugins/command-not-found
    zgen load zsh-users/zsh-history-substring-search
    zgen load zsh-users/zsh-syntax-highlighting

    # Docker
    zgen oh-my-zsh plugins/docker
    zgen oh-my-zsh plugins/docker-compose

    # python
    zgen oh-my-zsh plugins/pip
    zgen oh-my-zsh plugins/python

    # git
    zgen oh-my-zsh plugins/git
    zgen oh-my-zsh plugins/gitignore
    zgen oh-my-zsh plugins/git-extras
    zgen oh-my-zsh plugins/git-flow-avh

    # ruby
    zgen oh-my-zsh plugins/rvm
    zgen oh-my-zsh plugins/ruby
    zgen oh-my-zsh plugins/gem
    zgen oh-my-zsh plugins/rake
    zgen oh-my-zsh plugins/rbenv

    # misc
    zgen oh-my-zsh plugins/tmuxinator

    # completions
    zgen load zsh-users/zsh-completions src

    # theme
    zgen load denysdovhan/spaceship-zsh-theme spaceship
    # zgen oh-my-zsh themes/$ZSH_THEME

    # save all to init script
    zgen save
fi


# ZGEN_RESET_ON_CHANGE=(${HOME}/.zshrc ${HOME}/.zshrc.local)
ZGEN_RESET_ON_CHANGE=(${HOME}/.zshrc)

#####################################################################
####### import common partials ######################################
#####################################################################

source $ZSHRC_BASE/aliases_universal.sh
source $ZSHRC_BASE/aliases_tmux.sh
source $ZSHRC_BASE/aliases_git.sh

source $ZSHRC_BASE/functions_universal.sh
source $ZSHRC_BASE/functions_git.sh

#####################################################################
####### My config stuff #############################################
#####################################################################

# # Setup PATH env vars and variants
# export PATH="${PATH}:${HOME}/bin:${HOME}/.local/bin:${HOME}/.cabal/bin:${HOME}/.linuxbrew/bin:/usr/local/bin"

# For when I need to call MY versions of things no matter what
# export PATH="${HOME}/bin:${HOME}/.local/bin:${HOME}/.luarocks/bin:${HOME}/.local/lmod/lmod/5.9.3/libexec:${HOME}/.cabal/bin:${PATH}:/usr/local/bin:${HOME}/.gem/ruby/2.4.0/bin"


export PATH="$HOME/.poetry/bin:${HOME}/.node_modules/bin:${HOME}/.cabal/bin:/usr/local/bin:${HOME}/.gem/ruby/2.5.0/bin:${HOME}/.rvm/bin:/Applications/Postgres.app/Contents/Versions/latest/bin:${HOME}/.local/bin:${VIRGIN_PATH}"
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"

# Aliases
# alias ls="ls -Gh"
alias admin="sudo -u admin_gus"


bump-version-and-history(){
    if conda activate bumpver_and_hist ; then
        bumpversion $1 
        git-chglog > HISTORY.md 
        git add .
        git commit --amend --no-edit
        git tag --force $(git describe --tags $(git rev-list --tags --max-count=1))
        conda deactivate
    else
        echo "ERROR: failed to activate bumpver_and_hist environment!"
    fi
}

# #### fzf
# source /usr/share/fzf/key-bindings.zsh
# source /usr/share/fzf/completion.zsh


##### proxy stuff



#### Anaconda stuff

# # # Looks like this is not used post conda 4.4
# # add $ANACONDA/bin at the END of PATH
# export PATH="${PATH}:${ANACONDA}/bin"

# # create clean conda 'none' env dir
# reset-conda-none

# setup conda command
# source ${HOME}/.anaconda/etc/profile.d/conda.sh  # commented out by conda initialize
# export MY_CONDA_ROOT=$(conda info --base)
# conda activate main

zstyle ':completion::complete:*' use-cache 1

# ## If no conda env is set: set it to the one below, otherwise do nothing.
# if [[ ${CONDA_ENV_PATH} == '' ]]; then
#     sac none
# else
#     # conda_env_name=(${(ps:/:)${CONDA_ENV_PATH}})
#     echo "Conda environment already set: ${CONDA_ENV_PATH}."

# fi



# Set terminal color abilities
if [ -e /usr/share/terminfo/x/xterm-256color ]; then
    export TERM='xterm-256color'
else
    export TERM='xterm-color'
fi

export TERM='xterm-color'


# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='micro'
else
  export EDITOR='code'
fi

# alias atom=atom-beta
alias edit=$EDITOR

export VISUAL=code



### Specific commonly used data locations
export GITREPOS="${HOME}/repos"
export COOKIECUTTERS="${GITREPOS}/cookiecutters"
export PROJREPOS=$GITREPOS/project-repos
export MYPEMS="${HOME}/.ssh/pems"


#### alias to use sudo with my environment
alias sudoE="sudo -E"


#### ISO DATE
alias DATE="date -I"
alias zulu_time="date -u +'%Y-%m-%dT%H:%M:%SZ'"
alias zulu_stamp="date -u +'%Y-%m-%dT%H.%M.%SZ'"
alias time_stamp="date +'%Y-%m-%dT%H.%M.%S'"

## AWS stuff
export AWS_DIR="${HOME}/.aws"

export PEM_FL77_WDUNN=~/.ssh/fl77_wdunn.pem

export EC2_ID_GOOSE_WORKER="i-0aa747c0063157261"

goose_worker(){
    action=$1

    if [ $action = "start" ]
    then
        aws ec2 start-instances --instance-ids $EC2_ID_GOOSE_WORKER
    elif [ $action = "stop" ]
    then
        aws ec2 stop-instances --instance-ids $EC2_ID_GOOSE_WORKER
    else
        echo "ERROR: '$action' not a valid action: [start, stop]"
    fi
}


#### Ping Google
alias pinggoogle="ping -c 5 google.com"


#### Pure git stuff


#### git flow stuff
alias gf="git flow"
alias gff="gf feature"



#### OVERRIDE editing zshrc
alias zedit="edit $ZSHRC"


#### tree
alias tree="tree -Cha"










# edit the ZSH keybindings
bindkey "^[[1;9C" forward-word
bindkey "^[[1;9D" backward-word

 

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/wdunn/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/wdunn/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/wdunn/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/wdunn/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<



## Other auto-complete scripts
source <(inv --print-completion-script zsh)


### THIS MUST BE AT THE END OF THE FILE FOR GVM TO WORK!!!
[[ -s "${HOME}/.gvm/bin/gvm-init.sh" ]] && source "${HOME}/.gvm/bin/gvm-init.sh"


