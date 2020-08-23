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
  <a href="#authors">Authors</a> •
  <a href="#license">License</a>
</p>
</div>
<br>

## Basic Description
There are plenty of ways to save dotfiles at the moment, but they seemed quite big for what I needed. All I need is the ability to choose which configs to backup (in a simpler way), to automatically watch these files in the background and push to git as soon as we see there is a change.

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


## What are dotfiles

This text is taken from [Getting Started With Dotfiles](https://medium.com/@webprolific/getting-started-with-dotfiles-43c3602fd789) - [L. Kappert](https://github.com/webpro)


    Dotfiles are used to customize your system. The “dotfiles” name is derived from the configuration files in Unix-like systems that start with a dot (e.g. .bash_profile and .gitconfig). For normal users, this indicates these are not regular documents, and by default are hidden in directory listings. For power users, however, they are a core tool belt.

    There is a large dotfiles community. And with it comes a large number of repositories and registries containing many organized dotfiles, advanced installation scripts, dotfile managers, and mashups of things people collect in their own repositories.
    This article will try to give an introduction to dotfiles in general, by means of creating a basic dotfiles repository with an installation script. It is only meant to provide some inspiration, some pointers to what is possible, and where to look for when creating your own.

There are many tools and ways to save your configurations. You can read more about it here:

- [Github-Dotfiles](https://dotfiles.github.io/)
- [Awesome dotfiles](https://github.com/webpro/awesome-dotfiles#readme)

## How to use

### Prerequisites

Before you even start you need to have a couple of things:
- Mac or Linux OS (tested on macOS and PopOS)
- Installed git and curl
- Created repo ([Gitlab](https://gitlab.com/) or [Github](https://github.com/))

### How to install

Just run this command


```
bash <(curl -s http://mywebsite.com/myscript.txt)
```

You will be asked to enter your git repo url. It needs to be in this format:

    git@githost.tld:username/repo-name.git

And that's it.

Cron is checking for new updates every 3 minutes.

## Authors

<a href="https://pavelja.me"><img src="https://pavelja.me/assets/images/paveljame.svg" alt="Paveljame" width="200"></a>


## License

MIT
