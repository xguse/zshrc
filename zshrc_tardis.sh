ZGEN=/home/gus/src/repos/git/zgen/zgen.zsh
ZSHRC_BASE=/home/gus/src/repos/git/zshrc

# Set name of the theme to load.
ZSH_THEME="ys" #"junkfood" #"steeef" #"sporty_256" #"kphoen" #"candy" #"agnoster" "steeef" #"candy" #"agnoster"


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


ZGEN_RESET_ON_CHANGE=(${HOME}/.zshrc ${HOME}/.zshrc.local)

#####################################################################
####### import common partials ######################################
#####################################################################

source $ZSHRC_BASE/aliases_universal
source $ZSHRC_BASE/aliases_tmux
source $ZSHRC_BASE/aliases_git


#####################################################################
####### My config stuff #############################################
#####################################################################

##### proxy stuff

bch_proxy (){
  export http_proxy=http://proxy.tch.harvard.edu:3128/
  export https_proxy=$http_proxy
  export ftp_proxy=$http_proxy
  export rsync_proxy=$http_proxy
  export no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com"
}

proxy_off(){
  unset http_proxy
  unset https_proxy
  unset ftp_proxy
  unset rsync_proxy
  echo -e "Proxy environment variable removed."
}

##### DOCKER stuff
# run_conda_container () {
#     docker run --name=$1 -d bioconda/bioconda-builder /bin/bash -c "while true; do echo Hello world; sleep 1; done"
# }

conda_builder_ssh () {
    docker run --volume $SSH_AUTH_SOCK:/ssh-agent --env SSH_AUTH_SOCK=/ssh-agent $1 ssh-add -l
}


# Set terminal color abilities
if [ -e /usr/share/terminfo/x/xterm-256color ]; then
    export TERM='xterm-256color'
else
    export TERM='xterm-color'
fi

# export TERM='xterm-color'

# # Setup PATH env vars and variants
# export PATH="${PATH}:${HOME}/bin:${HOME}/.local/bin:${HOME}/.cabal/bin:${HOME}/.linuxbrew/bin:/usr/local/bin"

# For when I need to call MY versions of things no matter what
export PATH="${HOME}/bin:${HOME}/.local/bin:${HOME}/.luarocks/bin:${HOME}/.local/lmod/lmod/5.9.3/libexec:${HOME}/.cabal/bin:${PATH}:/usr/local/bin:/home/gus/.gem/ruby/2.2.0/bin"


# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='atom'
fi

alias edit=$EDITOR

export VISUAL=atom

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/id_rsa.pub"

export PATH="${PATH}:${HOME}/.rvm/bin" # Add RVM to PATH for scripting


# eval $(thefuck --alias)


#### Common filesystem specific locations


#### CUPS stopped playing nice without me setting this here
# export CUPS_SERVER=localhost:631/version=1.1

#### alias to use sudo with my environment
alias sudoE="sudo -E"


#### Random alias stuff
alias rb="systemctl reboot -i"

alias locbin="ln -st ${HOME}/.local/bin"

alias kp="killall pithos"

alias mirror_up="sudoE reflector --verbose --country 'United States' -l 200 -p http --sort rate --save /etc/pacman.d/mirrorlist"

alias mirror_up_antergos="sudoE cp /etc/pacman.d/antergos-mirrorlist /etc/pacman.d/antergos-mirrorlist.bk && rankmirrors -n 6 /etc/pacman.d/antergos-mirrorlist.rank_these > /tmp/antergos-mirrorlist && sudo cp /tmp/antergos-mirrorlist /etc/pacman.d/antergos-mirrorlist  && less /tmp/antergos-mirrorlist"

alias journal_dump="journalctl -xn 50"



journal_since_no_avahi () {

  journalctl --since "$1 min ago" | grep -v 'avahi-daemon' | less

}



#### ISO DATE
alias DATE="date -I"


#### Yale ssh shortcuts

### LOUISE stuff
LOUISE=wd238@louise.hpc.yale.edu
MOUNTPOINT_LOUISE="${HOME}/remote_mounts/louise"

alias sshLouise="ssh ${LOUISE}"
alias sshXLouise="ssh -X ${LOUISE}"
alias mLouise="sshfs ${LOUISE}:/home2/wd238 ${MOUNTPOINT_LOUISE}"
alias uLouise="fusermount -u ${MOUNTPOINT_LOUISE}"

alias mLouiseFastscratch="sshfs ${LOUISE}:/fastscratch/wd238 ${HOME}/remote_mounts/louise_fast_scratch"
alias uLouiseFastscratch="fusermount -u ${HOME}/remote_mounts/louise_fast_scratch"

alias mLouiseScratch2="sshfs ${LOUISE}:/scratch2/wd238 ${HOME}/remote_mounts/louise_scratch2"
alias uLouiseScratch2="fusermount -u ${HOME}/remote_mounts/louise_scratch2"

### BULLDOGN stuff
BULLDOGN=wd238@bulldogn1.hpc.yale.edu
MOUNTPOINT_BULLDOGN="${HOME}/remote_mounts/bulldogn"

alias sshBulldogN="ssh ${BULLDOGN}"
alias sshXBulldogN="ssh -X ${BULLDOGN}"
alias mBulldogN="sshfs ${BULLDOGN}:/ycga-ba/home/wd238 ${MOUNTPOINT_BULLDOGN}"
alias uBulldogN="fusermount -u ${MOUNTPOINT_BULLDOGN}"


### MOUNT all sshfs mount points
alias mAll="mLouise; mLouiseFastscratch; mLouiseScratch2; mBulldogN"

### UN-mount all sshfs mount points
alias uAll="uLouise; uLouiseFastscratch; uLouiseScratch2; uBulldogN"


#### Ping Google
alias pinggoogle="ping -c 5 google.com"


#### Pure git stuff
export GITREPOS="${HOME}/src/repos/git"

#### git flow stuff
alias gf="git flow"



#### Hugo aliases
alias hnew="hugo new"


#### Writing locations
export WRITINGCAVE="${GITREPOS}/markdown-docs"
alias cave="cd $WRITINGCAVE"

export DDRAD2=$HOME/MEGAsync/projects/ddRAD_phase2/repos/ddRAD_phase2


#### IPython Notebook stuff
export IPNB="${GITREPOS}/ipy_notebooks"
alias ipnb="cd ${IPNB}; jupyter notebook"
alias ipnbSERVER="cd ${IPNB}; ipython jupyter --profile=server"
alias Ipython="jupyter --matplotlib tk --gui=tk"

# #### Anaconda stuff
alias condavate="source $HOME/.anaconda/bin/activate"
alias decondavate="source $HOME/.anaconda/bin/activate none"
# decondavate

alias cstack2="condavate stack2"
alias cstack3="condavate stack3"


# function to test output code of a command
outcode () {
    $1
    echo $!
}

## If no conda env is set: set it to the one below, otherwise do nothing.
if [[ ${CONDA_ENV_PATH} == '' ]]; then
    source $HOME/.anaconda/bin/activate none
else
    # conda_env_name=(${(ps:/:)${CONDA_ENV_PATH}})
    # source $HOME/anaconda2/bin/activate $conda_env_name[-1]
    echo "Conda environment already set: ${CONDA_ENV_PATH}."

fi



#### AUR build stuff

clone_aur () {
    git clone https://aur.archlinux.org/$1.git
}


#### etckeeper

pupdate () {

    conda_env=$CONDA_DEFAULT_ENV;

    decondavate ;
    sudo etckeeper pre-install && sudoE powerpill $1 && sudo etckeeper post-install ;
    condavate $conda_env;
}


clean_pkg_cache () {

    sudo paccache -r;
    sudo paccache -ruk0;
}

#### Java settings
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=setting'
export _JAVA_OPTIONS='-Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'
export JAVA_FONTS=/usr/share/fonts/TTF




#### STOW aliases
alias stowv="stow -v"
alias stowlink="stowv -t"
alias stowbreak="stowv -D"
alias stowrelink="stowv -Rt"



#### make calling xdg-open easier
alias open="xdg-open"

#### TMUX

### tmuxinator
# source /home/gus/src/repos/git/tmuxinator/completion/tmuxinator.zsh
alias muxmain="mux start main"

#### tracker stuff
alias tctrl="tracker-control"
alias tterm="tracker-control -t"



# #### Wine set up variables
# export WINEPREFIX=$HOME/.config/wine32/
# export WINEARCH=win32

### THIS MUST BE AT THE END OF THE FILE FOR GVM TO WORK!!!
[[ -s "/home/gus/.gvm/bin/gvm-init.sh" ]] && source "/home/gus/.gvm/bin/gvm-init.sh"
