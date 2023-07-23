#!/usr/bin/env bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." &>/dev/null && pwd)"

wget -qO- https://get.pnpm.io/install.sh | sh -
git checkout HEAD -- "$DIR/zshrc.symlink"
export PNPM_HOME="$HOME/.local/share/pnpm"
pnpm env use --global lts

