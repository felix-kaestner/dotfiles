#!/usr/bin/env bash

if [ -f /etc/os-release ]
then
    awk -F= '/^ID=/{print $2}' /etc/os-release | grep -Eiq 'debian|ubuntu|mint'
    if [ $? -eq 0 ]
    then
        curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
        sudo apt install -y nodejs
        sudo npm install -g yarn
    fi
fi