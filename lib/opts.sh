#!/usr/bin/env bash

# since: 2022年03月17日

function help() {
    echo "my_kpi $version"
    echo "A simple tool for stat your numbers of code lines"
    echo ""
    echo "USAGE:"
    echo "    $CONS_CMD_NAME [OPTIONS]"
    echo ""
    echo "OPTIONS:"
    echo "    -f"
    echo "        Display complete information"
    echo "    -d"
    echo "        Display daily information"
    echo "    -w"
    echo "        Display weekly information"
    echo "    -m"
    echo "        Display monthly information"
    echo "    -h"
    echo "        Display help information"
    echo ""
    echo "Star me, please"
    echo "Power by $CONS_REPO"
}

# 信息模式, 默认简短
fully_mode=$CONS_FALSE # 0 简短信息模式, 1 完整信息模式
# 统计模式, 默认日周月
stats_mode=$(($CONS_DAILY_MODE | $CONS_WEEKLY_MODE | $CONS_MONTHLY_MODE)) # 0 NONE 1 daily 2 weekly 4 monthly
# 帮助模式, 默认关
help_mode=$CONS_FALSE
# patch模式, 默认关
patch_mode=$CONS_FALSE

function opts() {
    OPTIND=1

    local mode=0

    while getopts "fdwmhp" name; do
      case $name in
        f)
          fully_mode=1
        ;;
        d)
          mode=$(($mode | $CONS_DAILY_MODE))
        ;;
        w)
          mode=$(($mode | $CONS_WEEKLY_MODE))
        ;;
        m)
          mode=$(($mode | $CONS_MONTHLY_MODE))
        ;;
        h)
          help_mode=$CONS_TRUE
        ;;
        p)
          patch_mode=$CONS_TRUE
        ;;
        ?)
          help
          exit 1
        ;;
      esac
    done

    if [ "$mode" != "0" ]; then
        stats_mode=$mode
    fi

    if [ "$(($OPTIND - 1))" != "$#" ]; then
        echo Error occurs on resolving arguments.
        exit 1
    fi
}