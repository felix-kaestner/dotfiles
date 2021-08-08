#!/usr/bin/env bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

WINGET=$(command -v winget.exe)
if [ "$WINGET" != "" ]
then
    "${WINGET}" import -i "${DIR}/pkgs.json"
fi