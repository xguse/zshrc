
# getting AUR repos with ease
aur_clone () {
    git clone https://aur.archlinux.org/${1}.git
}

# jupyter stuff
add-ipy-kernel () {
    python -m ipykernel install --user --name $1 --display-name "$1"
}


# function to test output code of a command
outcode () {
    $1
    echo $!
}


# get the dependencies from pypi without installing the things
pip-list-deps () {
    PACKAGE=$1
    pip download $PACKAGE -d /tmp --no-binary :all: \
    | grep Collecting \
    | cut -d' ' -f2 \
    | grep -v $PACKAGE
}


# conda
reset-conda-none () {
    rm -rf $ANACONDA/envs/none/*
    mkdir $ANACONDA/envs/none/bin
}


# cookiecutter stuff
mkproject () {
    chenv cookiecutter
    echo "INFO: Changed conda envs."
    cookiecutter $1
    echo "INFO: Switching conda envs to 'none'."
    chenv_
    echo "INFO: Enjoy your work!"
}

mkprojectdatascience () {
    mkproject $GITREPOS/cookiecutters/cookiecutter-data-science
}
