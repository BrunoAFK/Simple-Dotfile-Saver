#!/bin/bash

    custom_param=$1
    dir_setup=$2
function working-dir() {

    echo "working-dir: $custom_param"
    echo "working-dir: $dir_setup"


    if [[ -z $custom_param ]]; then
        echo "Nothing here"
    else
        if [[ "$custom_param" = "--dir" || "$custom_param" = "-d" ]]; then
            if [[ -z $dir_setup ]]; then
                echo "You need to enter abosluth path (e.g. /etc/nginx)"
                exit 1
            elif [[ "$dir_setup" != /* ]]; then
                echo "You need to enter abosluth path (e.g. /etc/nginx)"
                exit 1
            else
                echo "Work tree. is now $dir_setup."
                echo "Make sure that you have all permissions as a user to use that working directory."
                working_dir=$dir_setup
            fi
        else
            echo "Wrong paramather. You can use --dir [abosluth path to directory] or -d [abosluth path to directory]"
            exit 1
        fi
    fi
}
working-dir