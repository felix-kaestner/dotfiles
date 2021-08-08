#!/usr/bin/env bash

if [ -f /etc/os-release ]
then
    awk -F= '/^ID=/{print $2}' /etc/os-release | grep -Eiq 'debian|ubuntu|mint'
    if [ $? -eq 0 ]
    then
        sudo apt install -y neovim
    fi
fi