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

curl -fsSLO --output-dir ~/.config/alacritty https://github.com/catppuccin/alacritty/raw/main/catppuccin-latte.toml
curl -fsSLO --output-dir ~/.config/alacritty https://github.com/catppuccin/alacritty/raw/main/catppuccin-frappe.toml
curl -fsSLO --output-dir ~/.config/alacritty https://github.com/catppuccin/alacritty/raw/main/catppuccin-macchiato.toml
curl -fsSLO --output-dir ~/.config/alacritty https://github.com/catppuccin/alacritty/raw/main/catppuccin-mocha.toml
