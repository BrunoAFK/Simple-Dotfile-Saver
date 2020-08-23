#!/bin/bash
working_dir=$HOME/test
dotfiles_location=$working_dir/.dotfiles 
dotfiles_script_location=$working_dir/.dotfiles-updater
git_location=$(which git)

if [[ $(uname) == 'Linux' ]]; then
    IS_LINUX=1
fi
if [[ $(uname) == 'Darwin' ]]; then
    IS_MAC=1
fi

echo "This will create simple dotfile saving evn for your system. For default location we will use your $working_dir directory."

function prerequets {
    if [[ ! -x $(which curl) ]]; then
        echo "You need to install curl. Please visit https://github.com/BrunoAFK/simple_dotfile_saver#prerequisites and follow instructions."
        exit 1
    fi
    if [[ ! -x $(which git) ]]; then
        echo "You need to install git. Please visit https://github.com/BrunoAFK/simple_dotfile_saver#prerequisites and follow instructions."
        exit 1
    fi
}
function git_repo {
    gir_repo=
    read -r -p "Enter valid git repo URL: " git_repo
    $git_location ls-remote "$git_repo" > /dev/null 2>&1
    if [ "$?" -ne 0 ]; then
        echo "[ERROR] Unable to read from '$git_repo'"
        echo "Pleas follow guide in the https://github.com/BrunoAFK/simple_dotfile_saver#prerequisites, or try again"
        exit 1;
    else
        echo "Your repo url is valid: $git_repo"
    fi
}

function create_folders {
    echo
    echo "Create folders"
    echo
    mkdir -p $dotfiles_location
    mkdir -p $dotfiles_script_location
}

function copy_files {
    echo
    echo "Copy script from git"
    echo
    curl -o $dotfiles_script_location/script.sh https://raw.githubusercontent.com/BrunoAFK/simple_dotfile_saver/master/script.sh
}

function permissions {
    echo
    echo "Set permissions"
    echo
    chmod +x $dotfiles_script_location/script.sh
}

function create_var_file {
    echo
    echo "Create var file"
    echo
    echo '#!/bin/bash' > $dotfiles_script_location/config.sh
    echo "working_dir=$working_dir" >> $dotfiles_script_location/config.sh
    echo "dotfiles_location=$dotfiles_location" >> $dotfiles_script_location/config.sh
    echo "path_location=$working_dir/.dotfiles-location" >> $dotfiles_script_location/config.sh
}

function create_list {
    echo
    echo "Create list of files we want to backup"
    echo
    # Add dotfiles-location to dotfiles-location
    echo ".dotfiles-location" > $working_dir/.dotfiles-location
}

function git {
    echo 
    echo "Git init for backup files on git"
    echo
    $git_location init --bare $dotfiles_location
    echo "Make sure that git status will be showing just what we need"
    $git_location --git-dir=$dotfiles_location --work-tree=$working_dir config --local status.showUntrackedFiles no
    echo "Adding your remote git repo"
    $git_location --git-dir=$dotfiles_location --work-tree=$working_dir remote add origin $git_repo
    echo "Make inital push"
    $git_location --git-dir=$dotfiles_location --work-tree=$working_dir add $working_dir/.dotfiles-location
    $git_location --git-dir=$dotfiles_location --work-tree=$working_dir commit -m "Inital automated commit"
    $git_location --git-dir=$dotfiles_location --work-tree=$working_dir push -u origin master
    }

function cron {
    echo
    echo "Lets make cron job for updating dotfiles (every 3 minutes)"
    echo
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
            <key>GroupName</key>
            <string>groupName</string>
            <key>InitGroups</key>
            <true/>
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
        crontab -l > $tmpCron
        #echo new cron into cron file
        echo "*/3 * * * * sh $scriptLocation  2>&1 | /usr/bin/logger -t dotfile-saver " >> $tmpCron
        #install new cron file
        crontab $tmpCron
        rm $tmpCron
    fi
}

function finished {
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

function collection {
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
function abort {
    echo "
    Please visit https://github.com/BrunoAFK/simple_dotfile_saver#prerequisites and follow instructions
    "
}


read -r -p "Do you wish to install this program? [Y/n] " input
 
case $input in
    [yY][eE][sS]|[yY])
collection
 ;;
    [nN][oO]|[nN])
abort
;;
    *)
collection
exit 0
;;
esac