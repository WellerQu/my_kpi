#!/usr/bin/env bash

# since: 2022年03月17日

function new_line() {
    echo ""
}

function colorize_primary_text() {
    echo $1
}

function colorize_second_text() {
    echo "\033[1;30m$1\033[0m"
}

function colorize_project_name() {
    echo "(\033[4;35m$1\033[0m)"
}

function colorize_project_path() {
    echo "\033[32m$1\033[0m"
}

function colorize_branch_name() {
    echo "\033[33m$1\033[0m"  
}

function colorize_tag() {
    echo "\033[44;37m$1\033[0m "
}

function colorize_error() {
    echo "\033[31m$1\033[0m"
}

function highlight() {
    echo "\033[1m$1\033[0m"
}

function underline() {
    echo "\033[4m$1\033[0m"
}