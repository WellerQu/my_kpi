#!/usr/bin/env bash

# since: 2022年03月09日

set -e
# set -x

cmd=$0

# resolve $cmd until the file is no longer a symlink
while [ -h "$cmd"  ]; do
    dir="$( cd -P "$( dirname "$cmd"  )" && pwd  )"
    cmd="$(readlink "$cmd")"
    [[ $cmd != /*  ]] && SOURCE="$dir/$cmd"
done

# resolve file's actual dirname
dir="$( cd -P "$( dirname "$cmd"  )" && pwd  )"
conf=$dir/conf.sh
lib=$dir/lib.sh

# load conf.sh to get user's configuraion
if [ -f $conf ]; then
    source $conf
else
    echo -e "\033[31mmissing conf\033[0m, refer: https://github.com/WellerQu/my_kpi"
    exit 1
fi

# load statistic logic
source $lib

#main
function main(){
    echo -e "\033[4mREPORT KPI\033[0m for ${author}"
    echo -e "\033[1;30mWelcome to star https://github.com/WellerQu/my_kpi\033[0m"

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

    echo -e "\033[1;30mGenreate this report at `date +"%Y-%m-%d %H:%M:%S"`\033[0m"
    echo -e "\033[1;30mforever @copyleft\033[0m"
}

# run main
main
