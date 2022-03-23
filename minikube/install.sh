#!/usr/bin/env bash

case $(uname -s) in
  'Linux')
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    sudo install minikube-linux-amd64 /usr/local/bin/minikube
    ;;
  'Darwin') 
    brew install minikube
    ;;
  *) ;;
esac
