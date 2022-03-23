#!/usr/bin/env bash

if [ -x "$(command -v winget.exe)" ] ; then
    DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
    "${WINGET}" import -i "${DIR}/pkgs.json"
fi