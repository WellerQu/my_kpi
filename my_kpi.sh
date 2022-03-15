#!/usr/bin/env bash

# author: qiuwei
# since: 2022年03月09日
# version: 1.3.0
# license: MIT

set -e
#set -x

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

# statistic function
function statistic(){
    # date range start
    local start=$1
    # date range end
    local end=$2
    # current branch
    local current=''

    for dir in ${work_spaces[@]}
    do
        cd $dir

        if [ ! -d ".git" ]; then
            # skip if there is not a ".git" directory
            continue
        fi

        # get current branch's name
        current=`git branch | grep '*' | awk '{print $2}'`

        if [ $(git status --porcelain | wc -l) -ne 0 ]; then
            # save WIP working
            git stash push -m 'KPI_stat' >/dev/null 2>&1
        fi

        # get all local branch
        for branch in `git for-each-ref --format='%(refname:short)' refs/heads/`
        do
            git checkout ${branch} > /dev/null 2>&1
            git log \
                --since="$start" \
                --until="$end" \
                --max-parents=1 \
                --author="$author" \
                --pretty=format: \
                --numstat  \
                | grep -Ev $ignores\
                | awk  -v d=$dir '{if ($1~/[0123456789]+/) printf "%s\t%s\t%s/%s\n", $1, $2, d, $3}'
        done

        # restore WIP working
        git checkout ${current} >/dev/null 2>&1

        stash=`git stash list | grep KPI_stat | head -n 1 | awk -F ':' '{print $1}'`

        if [ "${stash}" != "" ]; then
            git stash pop ${stash} >/dev/null 2>&1
        fi
    done
}

function daily() {
    # today
    local start="`date +%Y-%m-%d` 00:00:00"
    local end="`date -v+1d +%Y-%m-%d` 00:00:00"

    #echo $start $end
    statistic "$start" "$end"
}

function weekly(){
    # this week
    local sunday="`date -v -Sun +%Y-%m-%d` 00:00:00"
    local next_sunday="`date -v +Sun +%Y-%m-%d` 00:00:00"

    #echo $sunday $next_sunday
    statistic "$sunday" "$next_sunday"
}

function monthly(){
    # this month
    local first="`date +%Y-%m`-01 00:00:00"
    local last="`date -v+1m +%Y-%m`-01 00:00:00"

    #echo $first $last
    statistic "$first" "$last"
}

function display(){
    $1 | awk '{ add += $1; subs += $2; loc += $1 - $2; upd += $1 + $2  } END { printf "新增行数: %s, 删除行数: %s, 有效行数: %s, 变更行数: \033[32m%s\033[0m\n", add, subs, loc, upd  }' - 
}

#main
function main(){
    echo -e "\033[4mREPORT KPI\033[0m for ${author}"

    echo ""

    echo -e "\033[1m统计范围\033[0m"
    local current=`pwd`
    echo -e "\033[1;30mcurrent is ${current}, stat in follow-up directories (total ${#work_spaces[*]}):\033[0m"
    for dir in ${work_spaces[@]}
    do 
        cd $dir
        local project_name=`git remote -v | grep bizseer | grep push | awk -F '/' '{print $NF}' | awk -F '.' '{print $1}'`

        echo -e "\033[32m$dir\033[0m (\033[4;35m$project_name\033[0m)"

        for branch in `git for-each-ref --format='%(refname:short)' refs/heads/`
        do
          echo -e "\033[33m$branch\033[0m"  
        done
    done
    cd $current

    echo ""

    echo -e "\033[1m忽略关键词\033[0m"
    echo $ignores

    echo ""

    echo -e "\033[44;37m当日统计\033[0m `display daily`"

    echo ""

    echo -e "\033[44;37m当周统计\033[0m `display weekly`"

    echo ""

    echo -e "\033[44;37m当月统计\033[0m `display monthly`"

    echo ""

    echo "Work life balance"
    echo -e "\033[1;30mGenreate this report at `date +"%Y-%m-%d %H:%M:%S"` forever @copyleft\033[0m"
}

# run main
main
