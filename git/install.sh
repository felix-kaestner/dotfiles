#!/usr/bin/env bash

case $(uname -s) in
'Linux')
	if [ -f /etc/os-release ]; then
		case $(awk -F= '/^ID=/{print $2}' /etc/os-release) in
		'debian' | 'ubuntu')
			git config --file ~/.gitconfig.local gpg.program gpg2

			curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg
			echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
			sudo apt update
			sudo apt install gh
			;;
		'fedora')
			sudo dnf install -y 'dnf-command(config-manager)'
			sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
			sudo dnf install -y gh
			;;
		*) ;;
		esac
	fi
	;;
'Darwin')
	brew install git gh
	;;
*) ;;
esac
