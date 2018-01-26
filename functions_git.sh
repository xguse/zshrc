
# make $1 the repository named upstream
add_upstream () {
    git remote add upstream $1
}

# fetch and merge given branch from upstream into local of same name
sync_branch_with_upstream () {
    git fetch upstream
    git checkout $1
    git merge upstream/$1
}

# makes and pushes new git repo to your github
github-create () {
    usage="Usage: github-create [-r <repo_name>] [-u <username>] [-o <org>] [-g <init_git>] [-h]"
    # Defaults
    dir_name=$(basename $(pwd))
    repo_name=$dir_name
    username=$(git config github.user)
    org=""
    [ -d ".git" ] && INIT_GIT="y" || INIT_GIT="n"
    printusage="n"

    while getopts r:u:o:gh params ; do
        case "${params}"
            in
            r) repo_name=${OPTARG};;
            u) username=${OPTARG};;
            o) org=${OPTARG};;
            g) INIT_GIT="y";;
            h) printusage="y";;
            *) printusage="y";;
        esac
    done

    shift $((OPTIND-1))

    if [ "$printusage" = 'y' ]; then
        echo $usage
        return
    fi


    if [[ $CURL == *anaconda* ]]; then
        echo "[git-create][error]: You appear to be using an Anaconda-based version of curl; exit all anaconda environments and start again."
        invalid_credentials=1
    fi


    if [ "$repo_name" = "" ]; then
        echo "[git-create][info]: Repo name (hit enter to use '$dir_name')?"
        read repo_name
    fi

    if [ "$repo_name" = "" ]; then
        repo_name=$dir_name
    fi

    if [ "$username" = "" ]; then
        echo "[git-create][error]: Could not find username; run 'git config --global github.user <username>'"
        invalid_credentials=1
    fi

    token=$(git config github.token)
    if [ "$token" = "" ]; then
        echo "[git-create][error]: Could not find token; run 'git config --global github.token <token>'"
        invalid_credentials=1
    fi


    if [[ $invalid_credentials == "1" ]]; then
        return 1
    fi

    if [[ $INIT_GIT == "n" ]]; then
        echo "[git-create][error]: No git init detected; either provide option -g or make sure you are in a git repo."
        return
    else
        echo "[git-create][info]: Initializing this directory as a git repo and commiting contents."
        git init
        git add .
        git commit -m "First commit"
    fi


    if [ "$org" = "" ]; then
        echo "[git-create][info]: Creating Github repository '$repo_name' under '$username' ..."
        curl -u "$username:$token" https://api.github.com/user/repos -d '{"name":"'$repo_name'"}' # > /dev/null 2>&1
        echo "[git-create][info]:  done."

        echo "[git-create][info]: Pushing local code to remote ..."
        git remote add origin git@github.com:$username/$repo_name.git # > /dev/null 2>&1
        git push -u origin master # > /dev/null 2>&1
        echo "[git-create][info]:  done."
    else
        echo "[git-create][info]: Creating Github repository '$repo_name' under '$org' ..."
        curl -u "$username:$token" https://api.github.com/orgs/$org/repos -d '{"name":"'$repo_name'"}' # > /dev/null 2>&1
        echo "[git-create][info]:  done."

        echo "[git-create][info]: Pushing local code to remote ..."
        git remote add origin git@github.com:$org/$repo_name.git # > /dev/null 2>&1
        git push -u origin master # > /dev/null 2>&1
        echo "[git-create][info]:  done."
    fi



}
