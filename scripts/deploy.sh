#!/bin/sh

# This script is meant to deploy all config files onto a new machine

trap "exit 0" SIGINT

# Choosing install directory
DEF_DOT_DIR="$HOME/.config/dotfiles"
DOT_DIR=${1:-$DEF_DOT_DIR}

# Check if $DOT_DIR is a directory
if [ -f $DOT_DIR ];then
    echo "$DOT_DIR : is a file"
    exit 1
fi

# Create required directory structure
if find "$DOT_DIR" -mindepth 1 -print -quit 2>/dev/null | grep -q .;then
    echo "$DOT_DIR : is not empty"
    read -p "Do you wish to delete it? (y or [n]) " -n 1 -r
    echo

    if [[ ! $REPLY =~ ^[Yy]$ ]];then
        echo "Terminating"
        exit 0
    fi
    rm -rf $DOT_DIR
    mkdir $DOT_DIR
else
    mkdir -p $DOT_DIR
fi

# Check if git is installed
if ! type git >/dev/null 2>&1;then
    echo "Git is not installed"
    echo "Installing ..."
    sudo apt update && sudo apt -y install git ||
    sudo apt-get update && sudo apt-get -y install git ||
    sudo yum -y install git ||
    sudo pacman -Sy --noconfirm git ||
    sudo zypper -n refresh && sudo zypper -n install git ||
    sudo dnf install git
fi

if type git >/dev/null 2>&1;then
    git clone git@github.com:MoronixProduct3/dotfiles.git $DOT_DIR
else
    echo "Git installation failed, downloading with curl"
    curl -L https://github.com/MoronixProduct3/dotfiles/tarball/master |
        tar xz -C $DOT_DIR &&
        EXTRACT=$DOT_DIR/$(ls -1A $DOT_DIR) &&
        cp -r $EXTRACT/. $DOT_DIR &&
        rm -rf $EXTRACT
fi

# Backup old config files


# generate new dotfiles sourcing the ones in the repo
