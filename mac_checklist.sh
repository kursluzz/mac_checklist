#!/bin/bash

set -e

INSTALL_BREW=0
INSTALL_WGET=0
INSTALL_YOUTUBE_DL=0
INSTALL_FFMPEG=0
INSTALL_WAKEONLAN=0
INSTALL_PYCHARM=0
SET_SSH_KEYS=0
SSH_KEY_NAMES=("" kz)
SET_GIT_CONFIG=0
SET_BASHRC=0

# usage: installdmg https://example.com/path/to/pkg.dmg
# https://apple.stackexchange.com/questions/73926/is-there-a-command-to-install-a-dmg
function installdmg {
    set -x
    tempd=$(mktemp -d)
    curl $1 > $tempd/pkg.dmg
    listing=$(sudo hdiutil attach $tempd/pkg.dmg | grep Volumes)
    volume=$(echo "$listing" | cut -f 3)
    if [ -e "$volume"/*.app ]; then
      sudo cp -rf "$volume"/*.app /Applications
    elif [ -e "$volume"/*.pkg ]; then
      package=$(ls -1 "$volume" | grep .pkg | head -1)
      sudo installer -pkg "$volume"/"$package" -target /
    fi
    sudo hdiutil detach "$(echo "$listing" | cut -f 1)"
    rm -rf $tempd
    set +x
}

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

if [[ ${INSTALL_WAKEONLAN} -eq 1 ]]; then
    echo ---------- installing wakeonlan
    brew install wakeonlan
fi

if [[ ${INSTALL_PYCHARM} -eq 1 ]]; then
    echo ---------- Installing PyCharm
    # https://zeckli.github.io/en/2017/10/06/mac-install-dmg-through-command-line-en.html
    # https://apple.stackexchange.com/questions/73926/is-there-a-command-to-install-a-dmg
    cd ~/Downloads
    # wget https://download.jetbrains.com/python/pycharm-community-2019.1.2.dmg
    wget https://download.jetbrains.com/python/pycharm-professional-2020.1.5.dmg
    sudo hdiutil attach pycharm-professional-2020.1.5.dmg
    sudo cp -rf '/Volumes/PyCharm/PyCharm.app' /Applications/.
    sudo hdiutil detach '/Volumes/PyCharm'
    rm pycharm-professional-2020.1.5.dmg
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
    echo ---------- Setting up git info
    git config --global user.name "oleg"
    git config --global user.email "oleg@work"
fi

if [[ "$SET_BASHRC" -eq 1 ]]; then
    echo ---------- Setting .bashrc
echo 'if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi' >> ~/.zshrc

echo 'if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi' >> ~/.bashrc

fi


echo done.

