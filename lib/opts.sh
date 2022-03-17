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

fully_mode=$CONS_FALSE # 0 简短信息模式, 1 完整信息模式
stats_mode=0 # 0 all 1 daily 2 weekly 4 monthly
help_mode=$CONS_FALSE

function opts() {
    OPTIND=1

    while getopts "fdwmh" name; do
      case $name in
        f)
          fully_mode=1
        ;;
        d)
          stats_mode=$(($stats_mode | $CONS_DAILY_MODE))
        ;;
        w)
          stats_mode=$(($stats_mode | $CONS_WEEKLY_MODE))
        ;;
        m)
          stats_mode=$(($stats_mode | $CONS_MONTHLY_MODE))
        ;;
        h)
          help_mode=$CONS_TRUE
        ;;
        ?)
          help
          exit 1
        ;;
      esac
    done

    if [ "$(($OPTIND - 1))" != "$#" ]; then
        echo Error occurs on resolving arguments.
        exit 1
    fi
}