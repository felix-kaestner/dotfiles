#!/usr/bin/env bash

case $(uname -s) in
  'Linux')
    if [ -f /etc/os-release ] && awk -F= '/^ID=/{print $2}' /etc/os-release | grep -Eiq 'debian|ubuntu|mint'; then
        curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
        sudo apt install -y nodejs
        sudo npm install -g yarn
    fi
    ;;
  'Darwin') 
    brew install node
    ;;
  *) ;;
esac