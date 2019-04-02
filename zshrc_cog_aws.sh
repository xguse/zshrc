# Record the virgin PATH contents if we havent already
if [ -z ${VIRGIN_PATH+x} ]
    then
        export VIRGIN_PATH=$PATH
fi


export STORAGE=${HOME}/storage


# Set anaconda install location
ANACONDA=$HOME/anaconda3
alias ca="conda activate"
alias dact="conda deactivate"

# Begin ZGEN config
ZGEN=${HOME}/.zgen/zgen.zsh
ZSHRC_BASE=${HOME}/storage/git/zshrc

# Set name of the theme to load.
ZSH_THEME="sporty_256" #"kphoen" #"candy" #"agnoster" "steeef" #"candy" #"agnoster"


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
    # zgen load denysdovhan/spaceship-zsh-theme spaceship
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

# # Setup PATH env vars and variants
# export PATH="${PATH}:${HOME}/bin:${HOME}/.local/bin:${HOME}/.cabal/bin:${HOME}/.linuxbrew/bin:/usr/local/bin"

# For when I need to call MY versions of things no matter what
# export PATH="${HOME}/bin:${HOME}/.local/bin:${HOME}/.luarocks/bin:${HOME}/.local/lmod/lmod/5.9.3/libexec:${HOME}/.cabal/bin:${PATH}:/usr/local/bin:${HOME}/.gem/ruby/2.4.0/bin"


export PATH="${HOME}/.local/bin:${HOME}/.node_modules/bin:${HOME}/.cabal/bin:/usr/local/bin:/snap/bin:${HOME}/.gem/ruby/2.5.0/bin:${HOME}/.rvm/bin:${VIRGIN_PATH}"


# Aliases
#alias ls="ls -Gh"


#### s3fs
PIPELINE_S3_DIR=$HOME/S3

mount_pipeline_s3(){
	sudo s3fs \
		production-pipeline-data \
		-o passwd_file=$HOME/.aws/s3fs_creds \
		$PIPELINE_S3_DIR
	
}

##### proxy stuff



#### Anaconda stuff

# # # Looks like this is not used post conda 4.4
# # add $ANACONDA/bin at the END of PATH
# export PATH="${PATH}:${ANACONDA}/bin"

# # create clean conda 'none' env dir
# reset-conda-none

# setup conda command
source $ANACONDA/etc/profile.d/conda.sh
# export MY_CONDA_ROOT=$(conda info --base)
conda activate base

zstyle ':completion::complete:*' use-cache 1

# ## If no conda env is set: set it to the one below, otherwise do nothing.
# if [[ ${CONDA_ENV_PATH} == '' ]]; then
#     sac none
# else
#     # conda_env_name=(${(ps:/:)${CONDA_ENV_PATH}})
#     echo "Conda environment already set: ${CONDA_ENV_PATH}."

# fi


# # Set terminal color abilities
# if [ -e /usr/share/terminfo/x/xterm-256color ]; then
#     export TERM='xterm-256color'
# else
#     export TERM='xterm-color'
# fi

# export TERM='xterm-color'


# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='micro'
else
  export EDITOR='micro'
fi

# alias atom=atom-beta
alias edit=$EDITOR

export VISUAL=micro


# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/id_rsa.pub"

# eval $(thefuck --alias wtf)



### Specific commonly used data locations
export GITREPOS="${HOME}/storage/git"
export MYPEMS="${HOME}/.ssh/pems"


#### CUPS stopped playing nice without me setting this here
# export CUPS_SERVER=localhost:631/version=1.1

#### alias to use sudo with my environment
alias sudoE="sudo -E"





#### ISO DATE
alias DATE="date -I"
alias zulu_time="date -u +'%Y-%m-%dT%H:%M:%SZ'"
alias zulu_stamp="date -u +'%Y-%m-%dT%H.%M.%SZ'"
alias time_stamp="date +'%Y-%m-%dT%H.%M.%S'"

## AWS stuff
export AWS_DIR="${HOME}/.aws"

export PEM_GUS_INITIAL=$AWS_DIR/gus_initial.pem




#### Ping Google
alias pinggoogle="ping -c 5 google.com"


#### Pure git stuff


#### git flow stuff
alias gf="git flow"



#### OVERRIDE editing zshrc
alias zedit="edit $HOME/.zshrc"


# #### Hugo aliases
# alias hnew="hugo new"


# #### Writing locations
# export WRITINGCAVE="${GITREPOS}/markdown-docs"
# alias cave="cd $WRITINGCAVE"

# export DDRAD2=$HOME/MEGAsync/projects/ddRAD_phase2/repos/ddRAD_phase2



# #### Java settings
# export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=setting'
# export _JAVA_OPTIONS='-Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'
# export JAVA_FONTS=/usr/share/fonts/TTF


# ## Themes available
# solarized_256dark=$HOME/.dircolors-solarized/dircolors.256dark

# # ## Set the colors
# eval `dircolors ${solarized_256dark}`


#### TMUX
# alias txq='txsn quick'

### tmuxinator

# update-tmuxinator-and-source () {
#     (cd ${HOME}/src/repos/git/tmuxinator && git pull)
#     source ${HOME}/src/repos/git/tmuxinator/completion/tmuxinator.zsh
# }


# source ${HOME}/src/repos/git/tmuxinator/completion/tmuxinator.zsh
# alias muxmain="mux start main"




## Other auto-complete scripts
source <(invoke --print-completion-script=zsh)


### THIS MUST BE AT THE END OF THE FILE FOR GVM TO WORK!!!
[[ -s "${HOME}/.gvm/bin/gvm-init.sh" ]] && source "${HOME}/.gvm/bin/gvm-init.sh"
