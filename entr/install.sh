#!/usr/bin/env bash

curl -fsSL "https://github.com/eradman/entr/archive/master.tar.gz" | tar Cxzm /tmp
(
    cd /tmp/entr-master
    ./configure
    sudo make install
    rm -rf /tmp/entr-master
) >/dev/null 2>&1
