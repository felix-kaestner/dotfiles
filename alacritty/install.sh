#!/usr/bin/env bash

case $(uname -s) in
'Linux')
    [ -x "$(command -v apt)" ] && sudo apt install -y alacritty
    [ -x "$(command -v dnf)" ] && sudo dnf install -y alacritty
    ;;
'Darwin')
    brew install --cask alacritty
    ;;
*) ;;
esac

mkdir -p ~/.config/alacritty/themes
for palette in latte frappe macchiato mocha; do
    curl -fsSLO --output-dir ~/.config/alacritty/themes https://github.com/catppuccin/alacritty/raw/main/catppuccin-$palette.toml
done

ln -sf ~/.config/alacritty/themes/catppuccin-mocha.toml ~/.config/alacritty/theme.toml
