if [ "$shell" = "zsh" ]; then
    CINNABAR_DIR=${0:a:h}
else
    CINNABAR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
fi

# Evaluates the environment variable with the name in parameter 1
function cin_eval_variable {
    local envvar=$1
    local value
    if [ "$ZSH_NAME" != "" ]; then
        value=${(P)envvar}
    else
        value=${!envvar}
    fi
    echo "$value"
}

function cin_build_file_list {
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
                local path=$(cin_eval_variable "$envvar")
                paths+=($path)
                start=$((start+1))
            done
        elif [[ $arg =~ $number_regex ]] ; then
            local envvar=CINFILE$arg
            local path=$(cin_eval_variable $envvar)
            paths+=($path)
        else
            paths+=($arg)
        fi
    done
    echo "${paths[*]}"
}

# Unsets the CINFILE$number environment variables, starting with the
# number given in parameter 1.
function cin_reset_leftover_env_vars {
    local counter=$1
    while true ; do
        local envvar=CINFILE$counter
        local value=$(cin_eval_variable "$envvar")
        if [[ "$value" == "" ]] ; then
            break
        fi
        unset CINFILE$counter
        counter=$((counter+1))
    done
}

# Prints the status of files in th repository and creates the
# CINFILE$number environment variables to refer to those files.
function cin_do_status {
    local status_output=$(python3 $CINNABAR_DIR/cinnabar.py status)
    local paths="${status_output##*$'\n'}"
    local print_output=$(echo "$status_output" | head -n -1)
    local counter=0
    local path
    if [ "$shell" = "zsh" ] && [ -z $zsh_shwordsplit ]; then setopt shwordsplit; fi
    IFS='|'
    echo -e "$print_output"
    for path in $paths ; do
        counter=$((counter+1))
        export CINFILE$counter="$path"
    done
    unset IFS
    cin_reset_leftover_env_vars $((counter+1))
    if [ "$shell" = "zsh" ] && [ -z $zsh_shwordsplit ]; then unsetopt shwordsplit; fi
}

function cin_do_cmd {
    local cmd=$1
    shift
    local paths=$(cin_build_file_list "$@")
    $(echo "command $cmd ${paths[*]}")
}

function cin_do_add {
    cin_do_cmd "hg add" "$@"
}

function cin_do_amend {
    cin_do_cmd "hg commit --amend" "$@"
}

function cin_do_commit {
    cin_do_cmd "hg commit" "$@"
}

function cin_do_diff {
    cin_do_cmd "hg diff" "$@"
}

function cin_do_remove {
    cin_do_cmd "hg remove" "$@"
}

function cin_do_revert {
    cin_do_cmd "hg revert" "$@"
}

function cin_do_rm {
    cin_do_cmd "rm" "$@"
}

function cin_do_vim {
    cin_do_cmd "vim" "$@"
}

alias hca="cin_do_amend"
alias hcm="hg commit -m"
alias hc="cin_do_commit"
alias hd="cin_do_diff"
alias ha="cin_do_add"
alias hl="hg log"
alias hll="hg ll"
alias hrm="cin_do_remove"
alias hre="cin_do_revert"
alias hs="cin_do_status"
alias rm="cin_do_rm"
alias vim="cin_do_vim"
