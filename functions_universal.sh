
# getting AUR repos with ease
aur_clone () {
    git clone https://aur.archlinux.org/${1}.git
}

# jupyter stuff
add_ipy_kernel () {
    python -m ipykernel install --user --name $1 --display-name "$1"
}


# function to test output code of a command
outcode () {
    $1
    echo $!
}


# BCH VPN
vpn-bch () {
  sudo openconnect --juniper -C "DSID=${1}" https://vpn.childrens.harvard.edu
}
