#!/usr/bin/env bash

set -e
# set -x


semantic=$1
version_str=`tail -n 1 ./version.sh`

# 仅查看版本
if [ "$semantic" == "" ]; then
  echo $version_str
  exit 0
fi

# 格式化当前版本
version=($(echo ${version_str:3} | tr "." "\n"))
major=${version[0]}
minor=${version[1]}
patch=${version[2]}

# 计算新版本号
if [ "major" == "$semantic" ]; then
  newMajor=$(($major+1))
  newMinor=0
  newPatch=0
elif [ "minor" == "$semantic" ]; then
  newMajor=$major 
  newMinor=$(($minor+1))
  newPatch=0
elif [ "patch" == "$semantic" ]; then
  newMajor=$major 
  newMinor=$minor
  newPatch=$(($patch+1))
else
  echo "missing semantic parameter"
  echo "i.e. ./version <major|minor|patch>"

  # there is not key parameter, have to be terminated
  exit 1
fi

newVersion="v$newMajor.$newMinor.$newPatch"

# 检查是否有未提交的内容
if [ $(git status --porcelain | wc -l) -ne 0 ]; then
  echo "need to commit all of work"
  exit 1
fi

# 输出到文件
printf "\n# $newVersion" >> ./version.sh

# 更新 git 记录
git add .
git commit -m "update version to $newVersion"
git tag -a "$newVersion" -m "update version to $newVersion"

# v1.3.1
# v1.4.0
# v1.4.1
# v1.4.2
# v1.4.3