# Record the virgin PATH contents if we havent already
if [ -z ${VIRGIN_PATH+x} ]
    then
        export VIRGIN_PATH=$PATH
fi

fpath+=~/.zfunc

## homebrew
export ZSH_DISABLE_COMPFIX=true

#####################################################################
####### Set up zsh plugins and theme ################################
#####################################################################
ANACONDA=$HOME/.anaconda

ZGEN=${HOME}/.zgen/zgen.zsh
ZSHRC_BASE=${HOME}/.zshrc_base


# Set name of the theme to load.
ZSH_THEME="steeef" #"sporty_256" #"kphoen" #"candy" #"agnoster" "steeef" #"candy" #"agnoster"

# load zgen
source $ZGEN

# check if there's no init script
if ! zgen saved; then
    echo "Creating a zgen save"

    zgen oh-my-zsh

    # General System
    zgen oh-my-zsh plugins/archlinux
    zgen oh-my-zsh plugins/systemd
    zgen oh-my-zsh plugins/sudo
    zgen oh-my-zsh plugins/command-not-found
    zgen load zsh-users/zsh-history-substring-search
    zgen load zsh-users/zsh-syntax-highlighting

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
    zgen oh-my-zsh themes/$ZSH_THEME

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
reset-conda-none


# Aliases
alias ls="ls -Gh"


## AWS stuff
export AWS_DIR="${HOME}/.aws"

export GALAXY_IP="54.163.140.135"


ssh_compsci_port_fwd(){
    user=$1
    local=$2
    remote=$3

    ssh -4 -L ${local}:localhost:${remote} ${user}@compsci
}




#### git flow stuff
alias gf="git flow"
alias gff="gf feature"



#### OVERRIDE editing zshrc
alias zedit="edit $GITREPOS/zshrc"


#### tree
alias tree="tree -Cha"


