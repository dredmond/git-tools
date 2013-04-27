#!/bin/bash

IFS=' '
DIRECTORY=$(pwd)
START_DIRECTORY=$DIRECTORY

CHANGES_COLOR=$'\e[0;31m'
NOCHANGES_COLOR=$'\e[0;32m'
RESET_COLOR=$'\e[0m'
LIGHT_RED_COLOR=$'\e[1;31m'
YELLOW_COLOR=$'\e[0;33m'
LIGHT_YELLOW_COLOR=$'\e[1;33m'
CYAN_COLOR=$'\e[0;36m'
LIGHT_CYAN_COLOR=$'\e[1;36m'

function getCurrentBranch {
    local line=( $@ )

    if [ ${#line[*]} -ge 4 ] && [ ${line[2]} == 'branch' ] 
    then
        echo ${line[3]}
        return 0
    fi

    echo ""
    return 0
}

function isNoCommitsLine {
    local line=( $@ )

    if echo "${line[*]}" | grep --quiet "^nothing to commit.*$"
    then
        echo "1"
        return 0
    fi

    echo "0"
    return 0
}

function printHelp {
    printf "Usage: git_stats.sh [Directory]\n\n"
    printf "Parameters:\n"
    printf "    --help    Show this help documentation.\n"
    exit 0
}

function printUsages {

    for param in $@
    do
        case "$param" in
            "--help")
                printHelp
                ;;
            "-?")
                printHelp
                ;;
            *)
                if [ $# -gt 0 ]
                then
                    DIRECTORY=$1
                    pushd "$DIRECTORY" &>/dev/null
                fi
                ;;
        esac
    done

    printf "Searching Directory: %s\n\n" "$DIRECTORY"
    
    return 0
}

function shouldSkip {
    if [[ $(echo "$1" | grep ^"${SKIP_CHILDREN}/".*) ]]
    then
        echo "${SKIP_CHILDREN}"
    fi

    return 0
}

params=$@
printUsages ${params[@]}

# Get all directories in current path ignore .git directory
IFS=$'\n'
files=$(find . -maxdepth 3 -type d -print | grep -v ".*\.git.*")

for file in ${files[@]}
do
    result="$(shouldSkip "$file")"

    # Git repo found in parent so skip children.
    if $([ $result ])
    then
        continue
    fi 

    hasNoPendingChanges="0"

    # Change to new directory and display it.
    pushd "$file" &>/dev/null
    #printf "======== [Directory: %s] ========\n" "${YELLOW_COLOR}$(pwd)${RESET_COLOR}"

    # Run a git status and hide the errors
    git_check=$(git status 2>&1)

    # If this is not a git repo pop the directory and continue processing.
    if echo "$git_check" | grep --quiet "^fatal:.*$"
    then
        #printf "Not a Repository.\n\n"
        popd &>/dev/null
        continue
    fi

    # Change to new directory and display it.
    #pushd "$file" &>/dev/null
    printf "======== [Directory: %s] ========\n" "${YELLOW_COLOR}$(pwd)${RESET_COLOR}"

    SKIP_CHILDREN="$file"

    IFS=$'\n'
    git_stats=( $git_check )
    line_count=${#git_stats[@]}
    changes=""

    # Check for Pending Changes and Current Branch
    for ((i=0;$i<$line_count;i++))
    do
        stats=${git_stats[$i]}

        IFS=' '
        stats=( $stats )
        
        if [ $i -eq 0 ]
        then
            current_branch=$(getCurrentBranch ${stats[@]})
            if [ -n "$current_branch" ]
            then
                printf "%sCurrent Branch: %s\n" "$CYAN_COLOR" "$current_branch$RESET_COLOR"
            fi
        fi
        
        if [ $(isNoCommitsLine ${stats[@]}) == "1" ] && [ $i -eq 1 ]
        then
            hasNoPendingChanges="1"
        fi

        if [ $i -gt 0 ] && [ $hasNoPendingChanges == "0" ] && 
        [ $(isNoCommitsLine ${stats[@]}) == "0" ]
        then
            printf -v changes "%s\n" "$changes${stats[*]}"
        fi
    done

    # Display pending changes
    if [ $hasNoPendingChanges == "0" ]
    then
        echo -e "${LIGHT_YELLOW_COLOR}-*-*-*-*-*-*-*-   Changes   -*-*-*-*-*-*-*-"
        echo -e "${YELLOW_COLOR}${changes}"
        echo -e "${LIGHT_YELLOW_COLOR}-*-*-*-*-*-*-*- End Changes -*-*-*-*-*-*-*-${RESET_COLOR}\n"
    fi

    # Display Remote Status
    IFS=$'\n'
    t=( $(git remote show origin) )
    
    for line in ${t[@]}
    do
        if echo "$line" | grep --quiet ".*pushes.*"
        then
            LOCAL_BRANCH=''
            REMOTE_BRANCH=''
            STATUS=''
            COLOR_SETTING=''
            IFS=' '
            vals=( ${line[@]} )

            # 0 - Local Branch
            # 3 - Remote Branch
            # 4 - Start of Status
            # 6 - End of Status

            LEN=$((${#vals[@]}-4))

            LOCAL_BRANCH=${vals[0]}
            REMOTE_BRANCH=${vals[3]}
            STATUS=${vals[@]:4:$LEN}

            if [[ $(echo "$STATUS" | grep "(up to date)") ]]
            then
                COLOR_SETTING=$NOCHANGES_COLOR
            else
                COLOR_SETTING=$CHANGES_COLOR
            fi

            echo -e "${COLOR_SETTING}$LOCAL_BRANCH $REMOTE_BRANCH $STATUS${RESET_COLOR}"
        fi
    done

    printf "\n"

    # Pop last pushed directory
    popd &>/dev/null
done

# Go back to original directory.
# This is only used when the directory parameter was supplied
if [ "$START_DIRECTORY" != "$(pwd)" ]
then
    popd -0 &>/dev/null
fi
