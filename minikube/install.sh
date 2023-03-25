#!/usr/bin/env bash

case $(uname -s) in
'Linux')
	if [ -f /usr/local/bin/minikube ]; then
		echo "minikube is already installed. Skipping..."
	else
		curl -fsSLO "https://storage.googleapis.com/minikube/releases/latest/minikube-linux-$(dpkg --print-architecture)"
		sudo install "minikube-linux-$(dpkg --print-architecture)" /usr/local/bin/minikube
		rm -rf "minikube-linux-$(dpkg --print-architecture)"
	fi
	;;
'Darwin')
	brew install minikube
	;;
*) ;;
esac