
#########################################################################
####### prepend my local bin right away because this comp is OLD ########
#########################################################################

export PATH=$HOME/.local/bin:$PATH



#####################################################################
####### Set up zsh plugins and theme ################################
#####################################################################

ZGEN=$HOME/src/repos/git/zgen/zgen.zsh
ZSHRC_BASE=$HOME/src/repos/git/zshrc

fpath=($ZSHRC_BASE/zsh_supplements/Functions/Misc $fpath)

# Set name of the theme to load.
ZSH_THEME="sporty_256" #"kphoen" #"candy" #"agnoster" "steeef" #"candy" #"agnoster"

# load zgen
source $ZGEN

# check if there's no init script
if ! zgen saved; then
    echo "Creating a zgen save"

    zgen oh-my-zsh

    # # General System
    # zgen oh-my-zsh plugins/archlinux
    # zgen oh-my-zsh plugins/systemd
    # zgen oh-my-zsh plugins/sudo
    zgen oh-my-zsh plugins/command-not-found
    zgen load zsh-users/zsh-history-substring-search
    # zgen load zsh-users/zsh-syntax-highlighting

    # python
    zgen oh-my-zsh plugins/pip
    zgen oh-my-zsh plugins/python

    # git
    zgen oh-my-zsh plugins/git
    # zgen oh-my-zsh plugins/gitignore
    # zgen oh-my-zsh plugins/git-extras
    # zgen oh-my-zsh plugins/git-flow-avh

    # ruby
    zgen oh-my-zsh plugins/rvm
    zgen oh-my-zsh plugins/ruby
    zgen oh-my-zsh plugins/gem
    zgen oh-my-zsh plugins/rake
    zgen oh-my-zsh plugins/rbenv

    # misc
    zgen oh-my-zsh plugins/tmuxinator

    # completions
    # zgen load zsh-users/zsh-completions src

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

source $ZSHRC_BASE/aliases_universal
source $ZSHRC_BASE/aliases_tmux
source $ZSHRC_BASE/aliases_git

source $ZSHRC_BASE/functions_git

#####################################################################
####### My config stuff #############################################
#####################################################################


#### Pure git stuff
export GITREPOS="${HOME}/src/repos/git"



#### PBS stuff
export BSCRIPTS="${HOME}/bsub_scripts"

alias qme="qstat -u ${USER}"
alias qI="bsub -Is -q interactive zsh"
alias qI8="qsub -I -lnodes=1:ppn=8 -S $(which zsh)"
alias qI16="qsub -I -lnodes=1:ppn=16 -S $(which zsh)"
alias qI60="qsub -I -lnodes=1:ppn=60 -S $(which zsh)"




#### Anaconda stuff
## If no conda env is set: set it to the one below, otherwise do nothing.
if [[ ${CONDA_ENV_PATH} == '' ]]; then
    source $HOME/.anaconda/bin/activate none
else
    conda_env_name=(${(ps:/:)${CONDA_ENV_PATH}})
    source $HOME/.anaconda/bin/activate $conda_env_name[-1]
fi



#THIS MUST BE AT THE END OF THE FILE FOR GVM TO WORK!!!
[[ -s "/home/gus/.gvm/bin/gvm-init.sh" ]] && source "/home/gus/.gvm/bin/gvm-init.sh"
