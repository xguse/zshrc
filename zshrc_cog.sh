# Record the virgin PATH contents if we havent already
if [ -z ${VIRGIN_PATH+x} ]
    then
        export VIRGIN_PATH=$PATH
fi


## homebrew
export ZSH_DISABLE_COMPFIX=true

# Set anaconda install location
ANACONDA=$HOME/.anaconda
alias ca="conda activate"
alias dact="conda deactivate"

# Begin ZGEN config
ZGEN=${HOME}/src/git/zgen/zgen.zsh
ZSHRC_BASE=${HOME}/src/git/zshrc

# Set name of the theme to load.
ZSH_THEME="steeef" #"sporty_256" #"kphoen" #"candy" #"agnoster" "steeef" #"candy" #"agnoster"


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


export PATH="${HOME}/.local/bin:${HOME}/.node_modules/bin:${HOME}/.cabal/bin:/usr/local/bin:${HOME}/.gem/ruby/2.5.0/bin:${HOME}/.rvm/bin:/Applications/Postgres.app/Contents/Versions/latest/bin:${VIRGIN_PATH}"


# Aliases
alias ls="ls -Gh"
alias admin="sudo -u admin_gus"

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
source ${HOME}/.anaconda/etc/profile.d/conda.sh
export MY_CONDA_ROOT=$(conda info --base)
conda activate main

zstyle ':completion::complete:*' use-cache 1

# ## If no conda env is set: set it to the one below, otherwise do nothing.
# if [[ ${CONDA_ENV_PATH} == '' ]]; then
#     sac none
# else
#     # conda_env_name=(${(ps:/:)${CONDA_ENV_PATH}})
#     echo "Conda environment already set: ${CONDA_ENV_PATH}."

# fi


##### DOCKER stuff
# run_conda_container () {
#     docker run --name=$1 -d bioconda/bioconda-builder /bin/bash -c "while true; do echo Hello world; sleep 1; done"
# }

conda_builder_ssh () {
    docker run --volume $SSH_AUTH_SOCK:/ssh-agent --env SSH_AUTH_SOCK=/ssh-agent $1 ssh-add -l
}

bioconda-build-test () {
    docker run  -it -e http_proxy=http://proxy.tch.harvard.edu:3128/ --rm -v `pwd`:/bioconda-recipes bioconda/bioconda-builder --packages $1
}

bioconda-build-shell () {
    # docker-rm-exited-containers \
    docker run --rm --entrypoint=/bin/bash -it -e http_proxy=http://proxy.tch.harvard.edu:3128/ \
        -v  ${HOME}/src/repos/git/bioconda-recipes/recipes:/bioconda-recipes \
        -v  ${HOME}/src/repos/git:/gits \
        -v  ${HOME}/.bioconda_docker_bin:/usr/local/bin \
        -w  / \
        bioconda/bioconda-builder
}

bioconda-build-shell-linux-anvil () {
    # docker-rm-exited-containers \
    docker run --rm --entrypoint=/bin/bash -it -e http_proxy=http://proxy.tch.harvard.edu:3128/ \
        -v  ${HOME}/src/repos/git/bioconda-recipes/recipes:/bioconda-recipes \
        -v  ${HOME}/src/repos/git:/gits \
        -v  ${HOME}/.bioconda_docker_bin:/usr/local/bin \
        -w  / \
        condaforge/linux-anvil
}

docker-rm-exited-containers () {
    docker rm $(docker ps -a -f status=exited -q)
}

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
  export EDITOR='code'
fi

# alias atom=atom-beta
alias edit=$EDITOR

export VISUAL=code

# emacs aliases
alias emc="emacsclient -c"
alias emt="emacsclient -t"

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/id_rsa.pub"

# eval $(thefuck --alias wtf)



### Specific commonly used data locations
export GITREPOS="${HOME}/src/git"
export COOKIECUTTERS="${GITREPOS}/cookiecutters"
export HUMAN_G1K_V37_FAS="/run/media/gus/Storage/BCH/data/g1k/reference_genome/human_g1k_v37.fasta"
export PROJREPOS=$GITREPOS/project-repos
export MYPEMS="${HOME}/.ssh/pems"


#### CUPS stopped playing nice without me setting this here
# export CUPS_SERVER=localhost:631/version=1.1

#### alias to use sudo with my environment
alias sudoE="sudo -E"


#### Jrnl stuff

alias jw="jrnl work &"

function jwt () {
    jw < ~/Dropbox/jrnl/jrnl_work_tmpl.jnrl
    jw -1 --edit
}


#### Random alias stuff
alias kp="killall pithos"



#### ISO DATE
alias DATE="date -I"
alias zulu_time="date -u +'%Y-%m-%dT%H:%M:%SZ'"
alias zulu_stamp="date -u +'%Y-%m-%dT%H.%M.%SZ'"
alias time_stamp="date +'%Y-%m-%dT%H.%M.%S'"

## AWS stuff
export AWS_DIR="${HOME}/.aws"

export PEM_GUS_INITIAL=$AWS_DIR/gus_initial.pem

alias ssh_GD_000="ssh -i ${PEM_GUS_INITIAL} ubuntu@ec2-34-226-248-157.compute-1.amazonaws.com"

ssh_pipeline_analytics(){
    PUB_DNS=$1

    COMMAND="ssh -i ${PEM_GUS_INITIAL} ubuntu@${PUB_DNS}"
    echo "using command: $COMMAND"

    ssh -i ${PEM_GUS_INITIAL} ubuntu@${PUB_DNS}
    
}


ssh_pipeline_analytics_jupyter(){
    PUB_DNS=$1

    COMMAND="ssh -i ${PEM_GUS_INITIAL} -L 8000:localhost:8888 ubuntu@${PUB_DNS}"
    echo "using command: $COMMAND"
    ssh -i ${PEM_GUS_INITIAL} -L 8000:localhost:8888 ubuntu@${PUB_DNS}


}

#### Ping Google
alias pinggoogle="ping -c 5 google.com"


#### Pure git stuff


#### git flow stuff
alias gf="git flow"



#### OVERRIDE editing zshrc
alias zedit="edit $GITREPOS/zshrc"


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


## DJANGO STUFF
export DJANGO_DATA_DIR="/Users/GusDunn/src/git/project-repos/prod/data"
export DJANGO_TOOLS_DIR="/Users/GusDunn/src/git/project-repos/prod/tools"
export PYTHONPATH=$PROJREPOS/prod/cogen
export DJANGO_SETTINGS_MODULE=cogen.settings
export PROD_BASE_PIPELINE_INPUT_DIR=/Users/GusDunn/src/git/project-repos/prod/data/pipeline_input
export PROD_BASE_PIPELINE_OUTPUT_DIR=$DJANGO_DATA_DIR/pipeline_output



## Other auto-complete scripts
source $GITREPOS/invoke/completion/zsh


### THIS MUST BE AT THE END OF THE FILE FOR GVM TO WORK!!!
[[ -s "${HOME}/.gvm/bin/gvm-init.sh" ]] && source "${HOME}/.gvm/bin/gvm-init.sh"
