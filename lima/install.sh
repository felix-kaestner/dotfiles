#!/usr/bin/env bash

case $(uname -s) in
'Linux')
    sudo rm -rf /usr/local/bin/*lima* /usr/local/lima
    VERSION=$(curl -fsSL https://api.github.com/repos/lima-vm/lima/releases/latest | jq -r .tag_name)
    curl -fsSL "https://github.com/lima-vm/lima/releases/download/${VERSION}/lima-${VERSION:1}-$(uname -s)-$(uname -m).tar.gz" | sudo tar Cxzm /usr/local --exclude='./share/lima/examples'
    ;;
'Darwin')
    brew install lima
    ;;
*) ;;
esac
