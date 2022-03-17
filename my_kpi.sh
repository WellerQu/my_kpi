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
# resolve version
version=$(bash $dir/version.sh)

# load constants
source $dir/constants.sh

# load default theme
source $dir/themes/default.sh

# resolve conf file path
conf=$dir/conf.sh
# load conf.sh to get user's configuraion or show error
if [ -f $conf ]; then
    source $conf
else
    echo -e `colorize_error "missing conf file"` `colorize_primary_text "refer: $CONS_REPO"`
    exit 1
fi

# load custome theme
if [ "$theme" != "default" ] && [ -f "$dir/themes/$theme.sh" ]; then
    source $dir/themes/$theme.sh
fi

# load core lib
source $dir/lib/statistic_logic.sh
# load opts lib
source $dir/lib/opts.sh

#main
function main() {
    # pass all of arguments, shell will be terminate if error occurs
    opts $@

    if [ "$help_mode" == "$CONS_TRUE" ]; then
        help
        exit 0
    fi

    if [ "$fully_mode" == "$CONS_TRUE" ]; then
        echo -e `underline "REPORT KPI for ${author} ${version}"`
        echo -e `colorize_second_text "Welcome to star https://github.com/WellerQu/my_kpi"`

        new_line

        echo -e `highlight "统计范围"`
        local current=`pwd`

        echo -e `colorize_second_text "current is ${current}, stat in follow-up directories (total ${#work_spaces[*]}):"`
        for dir in ${work_spaces[@]}
        do 
            cd $dir
            local project_name=`git remote -v | grep bizseer | grep push | awk -F '/' '{print $NF}' | awk -F '.' '{print $1}'`

            echo -e `colorize_project_path "$dir"` `colorize_project_name "$project_name"`

            for branch in `git for-each-ref --format='%(refname:short)' refs/heads/`
            do
              echo -e `colorize_branch_name "$branch"`
            done
        done
        cd $current

        new_line

        echo -e `highlight "忽略关键词"`
        echo -e `colorize_primary_text "$ignores"`
    fi

    new_line

    if [ "$stats_mode" == "0" ] || [ "$(($stats_mode & $CONS_DAILY_MODE))" == "$CONS_DAILY_MODE" ]; then
      echo -e `colorize_tag "当日统计"` `display daily`

      new_line
    fi

    if [ "$stats_mode" == "0" ] || [ "$(($stats_mode & $CONS_WEEKLY_MODE))" == "$CONS_WEEKLY_MODE" ]; then
      echo -e `colorize_tag "当周统计"` `display weekly`

      new_line
    fi

    if [ "$stats_mode" == "0" ] || [ "$(($stats_mode & $CONS_MONTHLY_MODE))" == "$CONS_MONTHLY_MODE" ]; then
      echo -e `colorize_tag "当月统计"` `display monthly`

      new_line
    fi

    if [ "$fully_mode" == "$CONS_TRUE" ]; then
        echo -e `colorize_second_text "Genreate this report at $(date +"%Y-%m-%d %H:%M:%S")"`
        echo -e `colorize_second_text "forever @copyleft"`
    fi
}

# run main
main $@
