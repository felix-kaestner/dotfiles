#!/usr/bin/env bash

case $(uname -s) in
  'Linux')
    [ -x "$(command -v apt)" ] && sudo apt install -y neovim
    ;;
  'Darwin') 
    brew install neovim
    ;;
  *) ;;
esac
