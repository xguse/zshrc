# Record the virgin PATH contents if we havent already
if [ -z ${VIRGIN_PATH+x} ]
    then
        export VIRGIN_PATH=$PATH
fi

fpath+=~/.zfunc

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


export PATH="$HOME/.poetry/bin:${HOME}/.local/bin:${HOME}/.node_modules/bin:${HOME}/.cabal/bin:/usr/local/bin:${HOME}/.gem/ruby/2.5.0/bin:${HOME}/.rvm/bin:/Applications/Postgres.app/Contents/Versions/latest/bin:${VIRGIN_PATH}"


# Aliases
alias ls="ls -Gh"
alias admin="sudo -u admin_gus"


bump-version-and-history(){
    bumpversion $1
    git-chglog > HISTORY.md
    git add .
    git commit --amend --no-edit
    git tag --force $(git describe --tags $(git rev-list --tags --max-count=1))

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



### Specific commonly used data locations
export GITREPOS="${HOME}/src/git"
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

export PEM_GUS_INITIAL=$AWS_DIR/gus_initial.pem
export PEM_BASTION_HOST_US_EAST1=$AWS_DIR/BASTION_HOST_US_EAST1.pem

alias ssh_GD_000="ssh -i ${PEM_GUS_INITIAL} ubuntu@ec2-34-226-248-157.compute-1.amazonaws.com"

export PROD_PUB_DNS="ec2-184-73-9-223.compute-1.amazonaws.com"
export GALAXY_IP="54.163.140.135"

ssh_prod(){
    ssh -i ${PEM_BASTION_HOST_US_EAST1} ubuntu@${PROD_PUB_DNS}
}

ssh_compsci(){
    ssh -i ${HOME}/.ssh/id_rsa_compsci.pub gdunn@compsci
}

ssh_gal(){
    ssh ubuntu@${GALAXY_IP}
}

ssh_gal_jupyter(){
    worker_node=$1

    ssh -4 -L 8000:localhost:8001 gdunn@$GALAXY_IP -t ssh -4 -L 8001:localhost:8889 gdunn@${worker_node}
}

ssh_pipeline_analytics(){
    PUB_DNS=$1
    ssh -i ${PEM_GUS_INITIAL} ubuntu@${PUB_DNS}
}


ssh_pipeline_analytics_jupyter(){
    PUB_DNS=$1
    ssh -i ${PEM_GUS_INITIAL} -N -L 8000:localhost:8888 ubuntu@${PUB_DNS}
}


ssh_cluster_jump(){
    user=$1
    ssh -4 -L 8000:localhost:8001 ${user}@$GALAXY_IP -t ssh -4 -L 8001:localhost:8889 ${user}@w1
}


#### Ping Google
alias pinggoogle="ping -c 5 google.com"


#### Pure git stuff


#### git flow stuff
alias gf="git flow"



#### OVERRIDE editing zshrc
alias zedit="edit $GITREPOS/zshrc"





## DJANGO STUFF
export DJANGO_DATA_DIR="/Users/GusDunn/src/git/project-repos/prod/data"
export DJANGO_TOOLS_DIR="/Users/GusDunn/src/git/project-repos/prod/tools"
export PYTHONPATH=$PROJREPOS/prod/cogen
export DJANGO_SETTINGS_MODULE=cogen.settings


#### SSHFS

## PROD
export EC2_PROD=$HOME/Mounts/prod_ec2
mount_prod_ec2(){
    SERVER=$PROD_PUB_DNS
    sshfs ubuntu@${SERVER}:/ $EC2_PROD
}

unmount_prod_ec2(){
    fusermount -u $EC2_PROD
}

## ANALYTICS
export EC2_ANALYTICS=$HOME/Mounts/analytics_ec2
mount_analytics_ec2(){
    SERVER=$1

    sshfs ubuntu@${SERVER}:/ $EC2_ANALYTICS
}

unmount_analytics_ec2(){
    fusermount -u $EC2_ANALYTICS
}


## Other auto-complete scripts
source $GITREPOS/invoke/completion/zsh


# edit the ZSH keybindings
bindkey "^[[1;9C" forward-word
bindkey "^[[1;9D" backward-word

 


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/GusDunn/.anaconda/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/GusDunn/.anaconda/etc/profile.d/conda.sh" ]; then
        . "/Users/GusDunn/.anaconda/etc/profile.d/conda.sh"
    else
        export PATH="/Users/GusDunn/.anaconda/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
ca main


### THIS MUST BE AT THE END OF THE FILE FOR GVM TO WORK!!!
[[ -s "${HOME}/.gvm/bin/gvm-init.sh" ]] && source "${HOME}/.gvm/bin/gvm-init.sh"