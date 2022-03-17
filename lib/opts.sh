#!/usr/bin/env bash

# since: 2022年03月17日

function help() {
  echo "show help"
}

function opts() {
    OPTIND=1

    while getopts "hs" name; do
      case $name in
        s)
          echo short mode
        ;;
        h)
          help
        ;;
        ?)
          help
        ;;
        # *)
        #   echo $name
        # ;;
      esac
    done

    if [ "$(($OPTIND - 1))" != "$#" ]; then
        echo Error occurs on resolving arguments.
        exit 1
    fi
}