#!/usr/bin/env bash

if [ "$(uname -s)" != "Darwin" ]; then
    exit 0
fi

# Dock
defaults write com.apple.dock "tilesize" -int "48"
defaults write com.apple.dock "show-recents" -bool "false"
defaults write com.apple.dock "mru-spaces" -bool "false"
defaults write com.apple.dock "autohide" -bool "true"
defaults write com.apple.dock "autohide-time-modifier" -float "0.25"
defaults write com.apple.dock "expose-group-apps" -bool "true"

killall Dock

# System
defaults write NSGlobalDomain "KeyRepeat" -int "2"
defaults write NSGlobalDomain "InitialKeyRepeat" -int "15"

defaults write com.apple.screencapture "location" -string "~/Pictures/Screenshots"

killall SystemUIServer

# Finder
defaults write com.apple.finder "FXEnableExtensionChangeWarning" -bool "false"
defaults write com.apple.finder "FXPreferredViewStyle" -string "Nlsv"
defaults write com.apple.finder "FXDefaultSearchScope" -string "SCcf"
defaults write com.apple.finder "FXRemoveOldTrashItems" -bool "true"
defaults write com.apple.finder "_FXSortFoldersFirst" -bool "true"

defaults write com.apple.finder "ShowPathbar" -bool "true"
defaults write com.apple.finder "ShowExternalHardDrivesOnDesktop" -bool "false"
defaults write com.apple.finder "ShowRemovableMediaOnDesktop" -bool "false"

killall Finder

# Keyboard Shortcuts for macOS 15.X window tiling
# $ = Shift (⇧)
# ^ = Control (⌃)
# ~ = Option (⌥)
# @ = Command (⌘)
# Up Arrow = \UF700
# Down Arrow = \UF701
# Left Arrow: = \UF702
# Right Arrow = \UF703
defaults write -g NSUserKeyEquivalents -dict-add 'Fill' '^~@f'
defaults write -g NSUserKeyEquivalents -dict-add 'Centre' '^~@c'
defaults write -g NSUserKeyEquivalents -dict-add 'Top' '^~@\UF700'
defaults write -g NSUserKeyEquivalents -dict-add 'Bottom' '^~@\UF701'
defaults write -g NSUserKeyEquivalents -dict-add 'Left' '^~@\UF702'
defaults write -g NSUserKeyEquivalents -dict-add 'Right' '^~@\UF703'
