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

killall Dock

# Finder
defaults write NSGlobalDomain "NSDocumentSaveNewDocumentsToCloud" -bool "false"

defaults write com.apple.finder "FXEnableExtensionChangeWarning" -bool "false"
defaults write com.apple.finder "FXPreferredViewStyle" -string "Nlsv"
defaults write com.apple.finder "FXDefaultSearchScope" -string "SCcf"
defaults write com.apple.finder "FXRemoveOldTrashItems" -bool "true"
defaults write com.apple.finder "_FXSortFoldersFirst" -bool "true"

defaults write com.apple.finder "ShowPathbar" -bool "true"
defaults write com.apple.finder "ShowExternalHardDrivesOnDesktop" -bool "false"
defaults write com.apple.finder "ShowRemovableMediaOnDesktop" -bool "false"

killall Finder

# MacOS-only Software
brew install --cask arc
brew install --cask chatgpt
brew install --cask enpass
brew install --cask gpg-suite
brew install --cask logi-options-plus
brew install --cask monitorcontrol
brew install --cask rectangle
brew install --cask slack
brew install --cask tidal

# Install Rosetta 2
softwareupdate --install-rosetta --agree-to-license
