#!/usr/bin/env bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." &>/dev/null && pwd)"

curl -sSL https://get.pnpm.io/install.sh | sh -
git checkout HEAD -- "$DIR/zshrc.symlink"
export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"
pnpm env use --global lts

case $(uname -s) in
'Linux')
    curl -fsSL https://bun.sh/install | bash
	;;
'Darwin')
    brew tap oven-sh/bun
    brew install bun
	;;
*) ;;
esac

