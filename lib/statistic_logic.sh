#!/usr/bin/env bash

# since: 2022年03月17日

# statistic function
function statistic() {
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
            git stash push -m 'KPI_stat' > /dev/null 2>&1
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
        git checkout ${current} > /dev/null 2>&1

        stash=`git stash list | grep KPI_stat | head -n 1 | awk -F ':' '{print $1}'`

        if [ "${stash}" != "" ]; then
            git stash pop ${stash} > /dev/null 2>&1
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

function weekly() {
    # this week
    local sunday="`date -v -Sun +%Y-%m-%d` 00:00:00"
    local next_sunday="`date -v +Sun +%Y-%m-%d` 00:00:00"

    #echo $sunday $next_sunday
    statistic "$sunday" "$next_sunday"
}

function monthly() {
    # this month
    local first="`date +%Y-%m`-01 00:00:00"
    local last="`date -v+1m +%Y-%m`-01 00:00:00"

    #echo $first $last
    statistic "$first" "$last"
}

function display() {
    $1 | awk '{ add += $1; subs += $2; loc += $1 - $2; upd += $1 + $2  } END { printf "新增行数: %s, 删除行数: %s, 有效行数: \033[32m%s\033[0m, 变更行数: \033[32m%s\033[0m\n", add, subs, loc, upd  }' - 
}
