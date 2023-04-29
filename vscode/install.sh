#!/usr/bin/env bash

case $(uname -s) in
'Linux')
    if [ -f /etc/os-release ]; then
        case $(awk -F= '/^ID=/{print $2}' /etc/os-release) in
        'debian' | 'ubuntu')
            sudo apt-get install wget gpg
            wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >packages.microsoft.gpg
            sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
            sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
            rm -f packages.microsoft.gpg
            sudo apt install -y apt-transport-https
            sudo apt update
            sudo apt install -y code
            ;;
        'fedora')
            sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
            sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
            dnf check-update
            sudo dnf install -y code
            ;;
        *) ;;
        esac
    fi
    ;;
'Darwin')
    brew install --cask visual-studio-code
    ;;
*) ;;
esac
