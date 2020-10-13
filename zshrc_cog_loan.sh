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
ZSHRC_BASE=${HOME}/repos/zshrc

# Set name of the theme to load.
# ZSH_THEME="steeef" #"sporty_256" #"kphoen" #"candy" #"agnoster" "steeef" #"candy" #"agnoster"


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


# Aliases
alias ls="ls -Gh"
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



zstyle ':completion::complete:*' use-cache 1



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

ssh_compsci_port_fwd(){
    user=$1
    local=$2
    remote=$3

    ssh -i ${HOME}/.ssh/id_rsa_compsci -4 -L ${local}:localhost:${remote} ${user}@compsci
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
    worker=$2
    more_options=$3

    ssh -4 -L 8000:localhost:8001 ${user}@$GALAXY_IP -t ssh -4 -L 8001:localhost:8889 ${user}@${worker} ${more_options}
}


#### Ping Google
alias pinggoogle="ping -c 5 google.com"


#### Pure git stuff


#### git flow stuff
alias gf="git flow"
alias gff="gf feature"



#### OVERRIDE editing zshrc
alias zedit="edit $HOME/.zshrc"


#### tree
alias tree="tree -Cha"





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





# edit the ZSH keybindings
bindkey "^[[1;9C" forward-word
bindkey "^[[1;9D" backward-word



REPER_VPN_CERT="pin-sha256:tV65hdhtSuluu7GwbtL+yMDTp9hqZLSnxCRJE7M37JY="

vpn-reper () {
	sudo openconnect --servercert ${REPER_VPN_CERT} -u gdunn vpn.cogentherapeutics.com
}

vpn-reper-nocert () {
	sudo openconnect -u gdunn vpn.cogentherapeutics.com
}



### THIS MUST BE AT THE END OF THE FILE FOR GVM TO WORK!!!
[[ -s "${HOME}/.gvm/bin/gvm-init.sh" ]] && source "${HOME}/.gvm/bin/gvm-init.sh"
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/gdunn/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/gdunn/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/gdunn/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/gdunn/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

