
#####################################################################
####### load modules stuff bc this computer's git is ancient ########
#####################################################################

### Set Up my LOCAL `modules` and `easybuild` to be used
# adjust line below if you're using a shell other than bash, check with 'echo $SHELL'
source $HOME/.local/environment-modules/Modules/3.2.10/init/zsh

export EASYBUILD_INSTALLPATH=$HOME/.local/easybuild
export EASYBUILD_ROBOT=$HOME/src/repos/git/easybuild-easyconfigs/easybuild/easyconfigs

export MODULEPATH=$EASYBUILD_INSTALLPATH/modules/all:$HOME/.local/environment-modules/Modules/3.2.10/my_modulefiles
export PATH=$HOME/.local/environment-modules/Modules/3.2.10/bin:$PATH
export LD_LIBRARY_PATH=$HOME/.local/Tcl/lib:$LD_LIBRARY_PATH

alias md="module"
alias mdls="md list"
alias mdld="md load"
alias mdav="md av"
alias mdsh="md show"


#### Load various modules I always what to have
# md load git/2.2.0.rc2
md load git/2.3.4-goolf-1.4.10-no-OFED
md load EasyBuild/2.0.0
# md load zlib/1.2.8-goolf-1.4.10-no-OFED



#####################################################################
####### Set up zsh plugins and theme ################################
#####################################################################

ZGEN=/home2/wd238/src/repos/git/zgen/zgen.zsh
ZSHRC_BASE=/home2/wd238/src/repos/git/zshrc

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

#####################################################################
####### import common partials ######################################
#####################################################################

source $ZSHRC_BASE/aliases_universal
source $ZSHRC_BASE/aliases_tmux
source $ZSHRC_BASE/aliases_git


#####################################################################
####### My config stuff #############################################
#####################################################################




## If no conda env is set: set it to the one below, otherwise do nothing.
if [[ ${CONDA_ENV_PATH} == '' ]]; then
    source $HOME/.anaconda/bin/activate none
else
    conda_env_name=(${(ps:/:)${CONDA_ENV_PATH}})
    source $HOME/.anaconda/bin/activate $conda_env_name[-1]
fi

#### PBS stuff
export QSCRIPTS="${HOME}/qsub_scripts"

alias qme="qstat -u ${USER}"
alias qI8="qsub -I -lnodes=1:ppn=8 -S $(which zsh)"
alias qI16="qsub -I -lnodes=1:ppn=16 -S $(which zsh)"
alias qI60="qsub -I -lnodes=1:ppn=60 -S $(which zsh)"




#### Anaconda stuff
# de/activate conda env aliases
# alias condavate="source $HOME/.anaconda/bin/activate"
# alias decondavate="source $HOME/.anaconda/bin/activate none"
# decondavate


# alias cstack2="condavate stack2"
# alias cstack3="condavate stack3"


#THIS MUST BE AT THE END OF THE FILE FOR GVM TO WORK!!!
[[ -s "/home/gus/.gvm/bin/gvm-init.sh" ]] && source "/home/gus/.gvm/bin/gvm-init.sh"
