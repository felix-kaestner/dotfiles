#!/usr/bin/env bash

case $(uname -s) in
'Linux')
    FONT_DIR="${HOME}/.local/share/fonts"
    ;;
'Darwin')
    FONT_DIR="${HOME}/Library/Fonts"
    brew tap homebrew/cask-fonts
    brew install --cask font-cascadia-code
    ;;
*) ;;
esac

NERD_FONT_VERSION="v2.3.3"
curl -fsSLO "https://github.com/ryanoasis/nerd-fonts/releases/download/${NERD_FONT_VERSION}/NerdFontsSymbolsOnly.zip"
unzip -qod "${FONT_DIR}" NerdFontsSymbolsOnly.zip "*Mono.ttf"
rm -rf NerdFontsSymbolsOnly.zip
