#!/usr/bin/env bash

if [ -f /etc/os-release ]
then
    awk -F= '/^ID=/{print $2}' /etc/os-release | grep -Eiq 'debian|ubuntu|mint'
    if [ $? -eq 0 ]
    then
        git config --file ~/.gitconfig.local gpg.program gpg2

        curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
        sudo apt update
        sudo apt install gh
    fi
fi