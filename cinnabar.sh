if [ $shell = "zsh" ]; then
    CINNABAR_DIR=${0:a:h}
else
    CINNABAR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
fi

function build_file_list {
    local paths=()
    local range_regex='^([0-9]+)-([0-9]+)$'
    local number_regex='^[0-9]+$'
    local arg
    for arg in "$@" ; do
        if [[ $arg =~ $range_regex ]] ; then
            local start=${BASH_REMATCH[1]}
            local end=${BASH_REMATCH[2]}
            while [ $start -le $end ] ; do
                local envvar=CINFILE$start
                local path=(${!envvar})
                paths+=($path)
                start=$((start+1))
            done
        elif [[ $arg =~ $number_regex ]] ; then
            local envvar=CINFILE$arg
            local path=(${!envvar})
            paths+=($path)
        else
            paths+=($arg)
        fi
    done
    echo "${paths[*]}"
}

function reset_leftover_env_vars {
    local counter=$1
    while true ; do
        local envvar=CINFILE$counter
        local value=""
        if [ "$ZSH_NAME" != "" ]; then
            value=${(P)envvar}
        else
            value=${!envvar}
        fi
        if [[ "$value" == "" ]] ; then
            break
        fi
        unset CINFILE$counter
        counter=$((counter+1))
    done
}

function do_status {
    local status_output=$(python3 $CINNABAR_DIR/cinnabar.py status)
    local paths="${status_output##*$'\n'}"
    local print_output=$(echo "$status_output" | head -n -1)
    local counter=0
    local path
    if [ $shell = "zsh" ] && [ -z $zsh_shwordsplit ]; then setopt shwordsplit; fi
    IFS='|'
    echo -e "$print_output"
    for path in $paths ; do
        counter=$((counter+1))
        export CINFILE$counter="$path"
    done
    unset IFS
    reset_leftover_env_vars $((counter+1))
    if [ $shell = "zsh" ] && [ -z $zsh_shwordsplit ]; then unsetopt shwordsplit; fi
}

function do_cmd {
    local cmd=$1
    shift
    local paths=$(build_file_list "$@")
    $(echo "command $cmd ${paths[*]}")
}

function do_add {
    do_cmd "hg add" "$@"
}

function do_amend {
    do_cmd "hg commit --amend" "$@"
}

function do_commit {
    do_cmd "hg commit" "$@"
}

function do_diff {
    do_cmd "hg diff" "$@"
}

function do_remove {
    do_cmd "hg remove" "$@"
}

function do_revert {
    do_cmd "hg revert" "$@"
}

function do_rm {
    do_cmd "rm" "$@"
}

alias hca="do_amend"
alias hcm="hg commit -m"
alias hc="do_commit"
alias hd="do_diff"
alias ha="do_add"
alias hl="hg log"
alias hll="hg ll"
alias hrm="do_remove"
alias hre="do_revert"
alias hs="do_status"
alias rm="do_rm"
