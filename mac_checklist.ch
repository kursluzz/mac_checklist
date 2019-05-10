#!/bin/bash

MYUSER=oleg

INSTALL_BREW=0
INSTALL_PYTHON3=0
INSTALL_YOUTUBE_DL=0
INSTALL_FFMPEG=0
SET_SSH_KEYS=1
SSH_KEY_NAMES=("" bondit smode)

if [[ ${INSTALL_BREW} == 1 ]]; then
    echo --------- installing brew
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

if [[ ${INSTALL_PYTHON3} == 1 ]]; then
    echo --------- installing python3
    brew install python3
    brew analytics off
fi

if [[ ${INSTALL_YOUTUBE_DL} == 1 ]]; then
    echo ---------- installing youtube-dl
    pip3 install youtube-dl
fi

if [[ ${INSTALL_FFMPEG} == 1 ]]; then
    echo ---------- installing ffmpeg
    brew install ffmpeg
fi

if [[ ${SET_SSH_KEYS} == 1 ]]; then
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

echo done.

