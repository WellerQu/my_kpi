#!/usr/bin/env bash

# author: qiuwei
# since: 2022年03月16日

# working spaces for project codes
work_spaces=(\
"$HOME/Workspace/bizseer-x-ilog" \
"$HOME/Workspace/bizseer-ui" \
"$HOME/Workspace/bizseer-x-alert" \
"$HOME/Workspace/bizseer-x-portal" \
)

# git username
author=`whoami`

# keywords to ignore files
# usage: use | to split all of the keywords
# example: pakcage-lock|tsx
# explain: will ignore package-lock.json and all the *.tsx files
ignores="package-lock"
