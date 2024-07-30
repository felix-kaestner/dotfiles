#!/usr/bin/env bash

case $(uname -s) in
'Linux')
    [ -x "$(command -v apt)" ] && sudo apt install -y entr
    [ -x "$(command -v dnf)" ] && sudo dnf install -y entr
    ;;
'Darwin')
    brew install entr
    ;;
*) ;;
esac
