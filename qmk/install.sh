#!/usr/bin/env bash

case $(uname -s) in
'Linux')
    [ -x "$(command -v python3)" ] && python3 -m pip install --user qmk
    ;;
'Darwin')
    brew install qmk/qmk/qmk
    ;;
*) ;;
esac

qmk config user.qmk_home="$HOME/.qmk"
qmk setup -y
