#!/bin/bash
git_config="git config --global"

printf "\n\033[0;32mInstalling Global Git Aliases\n\033[0;37m=============================\033[0m\n\n"

printf "Installing alias.graphlog\n"
$git_config alias.graphlog 'log --all --decorate=short --graph'

printf "Installing alias.pullrb\n"
$git_config alias.pullrb 'pull --rebase'

printf "Installing alias.pushall\n"
$git_config alias.pushall '!f() { funcargs="$@"; printf "%s\n" "Running pushall $funcargs"; git for-each-ref --format="%(refname)" refs/remotes/ | cut -d / -f 3 | sort -u | while read entry; do head=`git symbolic-ref --short -q HEAD`; printf "%s\n" "Running git push $entry $head $funcargs"; `git push "$entry" "$head" ${funcargs}`; done;}; f'

printf "Installing alias.fetchall\n"
$git_config alias.fetchall '!f() { git for-each-ref --format="%(refname)" refs/remotes/ | cut -d / -f 3 | sort -u | while read entry; do `git fetch $entry ${@}`; done; }; f'

printf "Installing alias.co\n"
$git_config alias.co 'checkout'

printf "Installing alias.gitk\n"
$git_config alias.gitk '!gitk --all &'

printf "\n\033[0;37m=========================================\033[0m\n\033[0;32mFinished Installing Global Git Aliases!!!\033[0m\n\n\n\n"

printf "\033[0;32mInstalling Global VSDiffMerge Settings\n\033[1;32m======================================\033[0m\n\n"

printf "Installing Global VS 2013 MergeTool\n"
$git_config merge.tool vsdiffmerge
$git_config mergetool.prompt false
$git_config mergetool.vsdiffmerge.cmd "'C:/Program Files (x86)/Microsoft Visual Studio 12.0/Common7/IDE/vsdiffmerge.exe' \$REMOTE \$LOCAL \$BASE \$MERGED //m"
$git_config mergetool.vsdiffmerge.keepbackup false
$git_config mergetool.vsdiffmerge.trustexitcode true

printf "Installing Global VS 2013 DiffTool\n"
$git_config diff.tool vsdiffmerge
$git_config difftool.prompt false
$git_config difftool.vsdiffmerge.cmd "'C:/Program Files (x86)/Microsoft Visual Studio 12.0/Common7/IDE/vsdiffmerge.exe' \$LOCAL \$REMOTE //t"
$git_config difftool.vsdiffmerge.keepbackup false
$git_config difftool.vsdiffmerge.trustexitcode true

printf "\n\033[1;32m==================================================\033[0m\n\033[0;32mFinished Installing Global VSDiffMerge Settings!!!\033[0m\n\n"
