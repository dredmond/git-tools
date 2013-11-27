#!/bin/bash
git_config="git config --global"

printf "Installing Global Git Aliases\n"


printf "Installing alias.graphlog\n"


printf "Installing alias.pullrb\n"


printf "Installing alias.pushall\n"


printf "Installing alias.fetchall\n"


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
