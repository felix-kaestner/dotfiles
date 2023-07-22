#!/usr/bin/env bash

wget -qO- https://get.pnpm.io/install.sh | sh - > /dev/null
sed -i '/#\ pnpm/,/#\ pnpm\ end/d' ~/.zshrc
export PNPM_HOME="$HOME/.local/share/pnpm"
pnpm env use --global lts

