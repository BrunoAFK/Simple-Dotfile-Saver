#!/bin/bash

source config.sh
git_location=$(which git)

for n in $(cat $path_location)
do
    $git_location --git-dir=$dotfiles_location --work-tree=$working_dir add $working_dir/$n
done

$git_location --git-dir=$dotfiles_location --work-tree=$working_dir commit -m "Updating"
$git_location --git-dir=$dotfiles_location --work-tree=$working_dir push