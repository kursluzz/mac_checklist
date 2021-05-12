#!/bin/bash

MYUSER=oleg

INSTALL_BREW=0
INSTALL_WGET=0
INSTALL_YOUTUBE_DL=0
INSTALL_FFMPEG=0
SET_SSH_KEYS=1
SSH_KEY_NAMES=("" kz)
SET_GIT_CONFIG=0
INSTALL_PYCHARM=0

cd ~/Downloads

if [[ ${INSTALL_BREW} -eq 1 ]]; then
    echo --------- installing brew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [[ ${INSTALL_WGET} -eq 1 ]]; then
    echo --------- installing wget
    brew install wget
fi

if [[ ${INSTALL_YOUTUBE_DL} -eq 1 ]]; then
    echo ---------- installing youtube-dl
    pip3 install youtube-dl
fi

if [[ ${INSTALL_FFMPEG} -eq 1 ]]; then
    echo ---------- installing ffmpeg
    brew install ffmpeg
fi

if [[ ${SET_SSH_KEYS} -eq 1 ]]; then
    for SSH_KEY_NAME in "${SSH_KEY_NAMES[@]}"; do
        echo ---------- installing SSH key ${SSH_KEY_NAME}
	DO_SSH=0
	if [[ ${SSH_KEY_NAME} == '' ]]; then
	    SSH_KEY_NAME='id_rsa'
	fi
	if [[ -e ~/.ssh/${SSH_KEY_NAME} ]]; then
	    read -p "File ~/.ssh/${SSH_KEY_NAME} already exists! Do you want do replace it? [Y/n] " CH
	    if [[ "${CH}" = '' || "${CH}" = 'y' || "${CH}" = 'Y' ]]; then
	        rm "~/.ssh/${SSH_KEY_NAME}*"
	        DO_SSH=1
	    fi
	else
	    DO_SSH=1
	fi
	if [ ${DO_SSH} -eq 1 ]; then
	    ssh-keygen -f ~/.ssh/${SSH_KEY_NAME} -P ''
	    eval `ssh-agent`
	    ssh-add -K ~/.ssh/${SSH_KEY_NAME}
	fi
    done
fi

if [[ "$SET_GIT_CONFIG" -eq 1 ]]; then
    git config --global user.name "oleg"
    git config --global user.email "oleg@work"
fi

if [[ ${INSTALL_PYCHARM} -eq 1 ]]; then
    cd ~/Downloads
    #wget https://download.jetbrains.com/python/pycharm-community-2019.1.2.dmg
    # https://zeckli.github.io/en/2017/10/06/mac-install-dmg-through-command-line-en.html
    hdiutil attach pycharm-community-2019.1.2.dmg
    cp -rf '/Volumes/PyCharm CE/PyCharm CE.app' /Applications/.
    hdiutil detach '/Volumes/PyCharm CE/'
    #rm pycharm-community-2019.1.2.dmg
fi

echo done.

