#!/usr/bin/env bash

curl -sSLO https://github.com/funtoo/keychain/archive/refs/tags/2.8.5.zip
unzip -qq -o 2.8.5.zip
sudo mv keychain-2.8.5/keychain /usr/bin/
sudo mv keychain-2.8.5/keychain.1 /usr/share/man/man1/
rm -rf 2.8.5.zip keychain-2.8.5