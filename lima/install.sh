#!/usr/bin/env bash

case $(uname -s) in
'Linux')
    sudo rm -rf /usr/local/bin/*lima* /usr/local/lima
    VERSION=$(curl -fsSL https://api.github.com/repos/lima-vm/lima/releases/latest | jq -r .tag_name)
    curl -fsSL "https://github.com/lima-vm/lima/releases/download/${VERSION}/lima-${VERSION:1}-$(uname -s)-$(uname -m).tar.gz" | sudo tar Cxzm /usr/local --exclude='./share/lima/examples'
    ;;
'Darwin')
    brew install lima

    mkdir -p "$HOME/Developer"

    limactl create --vm-type=vz --rosetta --mount="~/Developer:w" --mount-type=virtiofs --mount-inotify --name=default template://default
    limactl create --vm-type=vz --rosetta --mount="~/Developer:w" --mount-type=virtiofs --mount-inotify --network=vzNAT --name=docker template://docker-rootful
    limactl create --vm-type=vz --rosetta --name=k8s template://k8s

    # Use k8s context from lima-vm instance on host
    if ! [ -f "$HOME/.kube/config" ]; then
      mkdir -p "$HOME/.kube"
      cp "$(limactl list "k8s" --format '{{.Dir}}/copied-from-guest/kubeconfig.yaml')" "$HOME/.kube/config"
    fi
    ;;
*) ;;
esac
