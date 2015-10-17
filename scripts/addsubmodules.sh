#!/bin/sh

pushd $(dirname $(readlink -f $0))/..

# scan all the git repo in subfolders and add them as submodules
find -name .git | grep -v '^\./\.git' | sed "s/\.git//g" |
while read dir; do
  cd $dir
  repo="$(git remote -v | head -n 1 | grep -Po https.*\.git)"
  cd -
  git submodule add $repo $dir
done

popd
