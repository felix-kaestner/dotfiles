#!/usr/bin/env bash

case $(uname -s) in
  'Linux')
    if [ -f /usr/local/bin/minikube ]; then
      echo "minikube is already installed. Skipping..."
    else
      curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
      sudo install minikube-linux-amd64 /usr/local/bin/minikube
      rm -rf minikube-linux-amd64
    fi
    ;;
  'Darwin') 
    brew install minikube
    ;;
  *) ;;
esac
