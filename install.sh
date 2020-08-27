#!/bin/bash

dotfiles_location=$working_dir/.dotfiles
dotfiles_script_location=$working_dir/.dotfiles-updater
git_location=$(which git)
#TEST
echo "Inital working dir is: $working_dir"
echo "Initial dotfiles location is: $dotfiles_location"
echo "Inital dotfiles_script location is: $dotfiles_script_location"
echo "First param is $1"
echo "2nd param is $2"
echo "3rd param is $3"
# Check working dir param. Change working dir
function working-dir() {
    echo "working-dir"
    if [[ -z $1 ]]; then
        working_dir=$HOME
        echo "We are using $working_dir as a work tree."
    else
        if [[ "$1" = "--dir" || "$1" = "-d" ]]; then
            if [[ -z $2 ]]; then
                echo "You need to enter abosluth path (e.g. /etc/nginx)"
                exit 1
            elif [[ "$2" != /* ]]; then
                echo "You need to enter abosluth path (e.g. /etc/nginx)"
                exit 1
            else
                echo "Work tree. is now $2."
                echo "Make sure that you have all permissions as a user to use that working directory."
                working_dir=$2
            fi
        else
            echo "Wrong paramather. You can use --dir [abosluth path to directory] or -d [abosluth path to directory]"
            exit 1
        fi
    fi
}
# Abort messages if needed
function abort-prerequests() {
    echo "
    Please visit https://github.com/BrunoAFK/simple_dotfile_saver#prerequisites and follow instructions
    "
}
function abort-abort() {
    echo
    echo
    echo "

           ,
          ~)
           (_---;
Llama       /|~||
           / / /|
                        
"
echo
echo
echo "Good bye!"
}
function abort-platform() {
    echo "
    Please visit https://github.com/BrunoAFK/simple_dotfile_saver#prerequisites and follow instructions
    "
}
# Checking OS
if [[ $(uname) == 'Linux' ]]; then
    IS_LINUX=1
fi
if [[ $(uname) == 'Darwin' ]]; then
    IS_MAC=1
fi
# Hello
echo "This script will try to help you out with the backup of your config files in the UNIX based systems. To find out more, check out git repo page: https://github.com/BrunoAFK/simple_dotfile_saver"
echo ""
# Check prerequets
function prerequets() {
    echo "prerequets"
    if [[ ! -x $(which curl) ]]; then
        echo "You need to install curl"
        abort-prerequests
        exit 1
    fi
    if [[ ! -x $(which git) ]]; then
        echo "You need to install git."
        abort-prerequests
        exit 1
    fi
}
# Check if git repo exsits
function git_repo() {
    gir_repo=
    read -r -p "Enter valid git repo URL: " git_repo
    $git_location ls-remote "$git_repo" >/dev/null 2>&1
    if [ "$?" -ne 0 ]; then
        echo "[ERROR] Unable to access from '$git_repo'"
        abort-prerequests
        exit 1
    else
        echo 
    fi
}
# Create folders
function create_folders() {
    mkdir -p $dotfiles_location
    mkdir -p $dotfiles_script_location
}
# Copy script from git
function copy_files() {
    curl -o $dotfiles_script_location/script.sh https://raw.githubusercontent.com/BrunoAFK/simple_dotfile_saver/$branch/script.sh
}
# Set permissions for the script
function permissions() {
    chmod +x $dotfiles_script_location/script.sh
}
# Create file with variables for the script
function create_var_file() {
    echo '#!/bin/bash' >$dotfiles_script_location/config.sh
    echo "working_dir=$working_dir" >>$dotfiles_script_location/config.sh
    echo "dotfiles_location=$dotfiles_location" >>$dotfiles_script_location/config.sh
    echo "path_location=$working_dir/.dotfiles-location" >>$dotfiles_script_location/config.sh
}
# Create list of files that we will track, and add the same file into that file to track :D
function create_list() {
    echo ".dotfiles-location" >$working_dir/.dotfiles-location
}
# Git init, calibrating git status to our needs, adding remote git repo, and initial push
function git() {
    $git_location init --bare $dotfiles_location
    $git_location --git-dir=$dotfiles_location --work-tree=$working_dir config --local status.showUntrackedFiles no
    $git_location --git-dir=$dotfiles_location --work-tree=$working_dir remote add origin $git_repo
    $git_location --git-dir=$dotfiles_location --work-tree=$working_dir add $working_dir/.dotfiles-location
    $git_location --git-dir=$dotfiles_location --work-tree=$working_dir commit -m "Inital automated commit"
    $git_location --git-dir=$dotfiles_location --work-tree=$working_dir push -u origin master
}
# Create cron job
function cron() {
    #******************
    # Mac
    #******************
    if [[ $IS_MAC -eq 1 ]]; then
        projectName=dotfile-updater
        ldaemons=/Library/LaunchDaemons/com.

        user_name=$(id -un)
        user_group=$(groups $(whoami) | cut -d' ' -f1)
        user_paths=$(echo $PATH)
        user_folder=$(echo $HOME)

        scriptLocation=$dotfiles_script_location/script.sh
        logLocation=/var/log/$projectName
        checkInterval=200

        sudo mkdir -p $logLocation
        sudo chown -R $(echo $user_name):$(echo $user_group) $logLocation

        echo "Creating autostart script"
        function llamaDaemons() {
            echo '
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
            <key>EnvironmentVariables</key>
            <dict>
            <key>PATH</key>
            <string>pathlist</string>
            </dict>
            <key>Label</key>
            <string>nameProject</string>
            <key>ProgramArguments</key>
            <array>
                <string>sh</string>
                <string>-c</string>
                <string>projectScript</string>
            </array>
            <key>RunAtLoad</key>
            <true/>
            <key>StandardErrorPath</key>
            <string>errorLog</string>
            <key>UserName</key>
            <string>nameUser</string>
            <key>Gr
    echo
    echo "Lets make cron job for updating dotfiles (every 3 minutes)"
    echong>groupName</string>
            <key>InitGroups</key>
            <true/>working-dir
            <key>StartInterval</key>
            <integer>secTo</integer>
        </dict>
        </plist>
            ' | sudo tee -a $ldaemons$projectName.plist 1>/dev/null
        }
        # Autostart script creator function
        llamaDaemons
        # Lets add custom parameters
        sudo sed -i .orig "s|nameProject|com.$projectName|g" $ldaemons$projectName.plist
        sudo sed -i .orig "s|projectScript|$scriptLocation|g" $ldaemons$projectName.plist
        sudo sed -i .orig "s|errorLog|$logLocation/error|g" $ldaemons$projectName.plist
        sudo sed -i .orig "s|nameUser|$user_name|g" $ldaemons$projectName.plist
        sudo sed -i .orig "s|groupName|$user_group|g" $ldaemons$projectName.plist
        sudo sed -i .orig "s|secTo|$checkInterval|g" $ldaemons$projectName.plist
        sudo sed -i .orig "s|pathlist|$user_paths|g" $ldaemons$projectName.plist

        sudo launchctl load -w $ldaemons$projectName.plist

    fi

    #******************
    # Linux
    #******************
    if [[ $IS_LINUX -eq 1 ]]; then
        scriptLocation=$dotfiles_script_location/script.sh
        tmpCron=$(mktemp)
        #write out current crontab
        crontab -l >$tmpCron
        #echo new cron into cron file
        echo "*/3 * * * * sh $scriptLocation  2>&1 | /usr/bin/logger -t dotfile-saver " >>$tmpCron
        #install new cron file
        crontab $tmpCron
        rm $tmpCron
    fi
}

function finished() {
    echo
    echo "
    Thats it. We will list location of all files:
    Directory that we want to watch: $working_dir
    Git directory (bare): $dotfiles_location
    Scripts directory: $dotfiles_script_location

    After this you can go and add files you want to watch in your $working_dir/.dotfiles-location . Dotfiles-location is file where you will list path to every folder or file you want to save on your git repo (path relative to $working_dir). Be careful that you are not sending any private data (for example ssh keys) to your git repo.

    Have a fun :) https://github.com/BrunoAFK/simple_dotfile_saver

    "
    echo
}

function collection() {
    working-dir
    prerequets
    git_repo
    create_folders
    copy_files
    permissions
    create_var_file
    create_list
    git
    cron
    finished
}

read -r -p "Do you wish to install this program? [Y/n] " input

case $input in
[yY][eE][sS] | [yY])
    collection
    ;;
[nN][oO] | [nN])
    abort-abort
    ;;
*)
    collection
    exit 0
    ;;
esac
