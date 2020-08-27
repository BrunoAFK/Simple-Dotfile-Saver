<div align="center">

<h1>
  <a href=""><img src="img.png" alt="Simple_dotfile_saver" width="900"></a>
  <br>
  .simple_dotfile_saver
  <br>
</h1>
</div>
<div align="center">

<h4 align="center">This script will quickly create everything you need to keep your dotfiles safe</a>.</h4>

<p align="center">
  <a href="#basic-description">Basic Description and Idea</a> •
  <a href="#what-are-dotfiles">What are dotfiles</a> •
  <a href="#how-to-use">How to use</a> •
  <a href="#tips--tricks">Tips & Tricks</a> •
  <a href="#authors">Authors</a> •
  <a href="#license">License</a>
</p>
</div>
<br>

## Basic Description
There are plenty of ways to save dotfiles at the moment, but they seemed quite big for what I needed. All I need is the ability to choose which configs to backup (in a simpler way), to automatically watch these files in the background and push to git as soon as we see there is a change.



## What are dotfiles

This text is taken from [Getting Started With Dotfiles](https://medium.com/@webprolific/getting-started-with-dotfiles-43c3602fd789) - [L. Kappert](https://github.com/webpro)


> Dotfiles are used to customize your system. The “dotfiles” name is derived from the configuration files in Unix-like systems that start with a dot (e.g. .bash_profile and .gitconfig). For normal users, this indicates these are not regular documents, and by default are hidden in directory listings. For power users, however, they are a core tool belt.
> There is a large dotfiles community. And with it comes a large number of repositories and registries containing many organized dotfiles, advanced installation scripts, dotfile managers, and mashups of things people collect in their own repositories.

There are many tools and ways to save your configurations. You can read more about it here:

- [Github-Dotfiles](https://dotfiles.github.io/)
- [Awesome dotfiles](https://github.com/webpro/awesome-dotfiles#readme)

## How to use

### Prerequisites

Before you even start you need to have a couple of things:
- Mac or Linux OS (tested on macOS and PopOS)
- Installed **git** and **curl**
- Created repo on any git host ([Gitlab](https://gitlab.com/) or [Github](https://github.com/)).

### How to install

Just run this command

```
bash <(curl -s https://raw.githubusercontent.com/BrunoAFK/simple_dotfile_saver/master/install.sh)
```

You will be asked to enter your git repo URL. It needs to be in this format:

    git@githost.tld:username/repo-name.git

And that's it.

Cron is checking for new updates every hour.

#### Custom path

The default command mentioned above, your working tree (main directory) will be your home directory. If you want to change that, you can use this command (and modify the last part with the absolute path you want to use)

```
bash <(curl -s https://raw.githubusercontent.com/BrunoAFK/simple_dotfile_saver/master/install.sh) --dir /path 
```

Make sure that you have all permissions as a user for that directory.

### What will the script do?

1. Checking curl and git installation
2. validating given remote git repo URL
3. Create all folders that we need (2 of them)
4. Download the main script that will push updates to your repo
5. Giving permissions to that script
6. We will create the external file with variables (in the future i will add more things, so this will be nice to have)
7. Script will create basic .dotfiles-location file
8. Init git bare repo
9. Removing untracked files from the status
10. Add your remote repo
11. Stash all files from .dotfiles-location to stash
12. Make initial commit
13. Push files to new git repo
14. Create a cron job

## Tips & Tricks

### Backup files outside working tree
If you want to backup files outside of the home (or custom working) directory, you can do that with creating one folder that you will store all symlinks. In my case, I create folder .backup, and I there story every symlink to important configs.

To do that just create directory

```
mkdir $HOME/.backup
```

Add directory to .dotfiles-location file

```
echo ".backup" >> $HOME/.dotfiles-location
```

Then create a symlink (e.g. resolve file)

```
sudo ln -s /etc/resolv.conf $HOME/.backup   
```

### gitignore
Sometimes you add the whole folder to .dotfiles-location, but that one file inside the folder is something that you don't want to backup. In that case, you can add files to the gitignore file.

Create a gitignore file inside the working directory (working tree).

```
touch $HOME/.gitignore
```

After you add files inside the .gitignore, then you can clear git cache to stop committing changes to that file

```
/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME rm -r --cached .
```

### Control your backup - Alias
If you want to have quick access to all that you need for saving dotfiles, you can add a couple of useful alias to your .bashrc or .zshrc file.

Add alias to bashrc:

```
echo '
alias dot="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
alias dot-add="echo \$1 >> $HOME/.dotfiles-location"
alias dot-remove="echo \$1 >> $HOME/.gitignore && /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME rm -r --cached . "
dot-link () {
    sudo ln -s $1 $HOME/.backup
}
' >> $HOME/.bashrc
```

Add alias to zshrc:

```
echo '
alias dot="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
alias dot-add="echo \$1 >> $HOME/.dotfiles-location"
alias dot-remove="echo \$1 >> $HOME/.gitignore && /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME rm -r --cached . "
dot-link () {
    sudo ln -s $1 $HOME/.backup
}
' >> $HOME/.zshrc
```

##### dot [GIT COMMAND]
I'm using dot command as a shortcut for long git command. If I need to see the status of my dotfiles repo I just need to use ```dot status`` and that's it. You can use this with any git command.

##### dot-add location/to/file/or/folder
This will add a new file or folder to track inside the .dotfiles-location. Just make sure that you are entering the path from your working dir (e.g. if you have folder .ansible in the home dir you just need to write .ansible)

##### dot-remove location/to/file/or/folder
This will add a file to gitignore and then clear git cache so that we stop following changes inside that file. Just make sure that you are entering the path from your working dir (e.g. if you have folder .ansible in the home dir you just need to write .ansible)


##### dot-link /location/to/file/or/folder
This will create a symlink to your backup folder inside the home directory. Just make sure that you are entering the absolute path (e.g. if you have folder Nginx in the etc dir you need to write /etc/nginx). prerequests to this is that you have created .backup directory inside your home directory and that you add .backup directory to your .dotfiles-location file


## Authors

<a href="https://pavelja.me"><img src="https://pavelja.me/assets/images/paveljame.svg" alt="Paveljame" width="200"></a>


## License

MIT
