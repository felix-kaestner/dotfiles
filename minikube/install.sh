#!/usr/bin/env bash

case $(uname -s) in
'Linux')
    ARCH_NAME="$(uname -m)"
    case ${ARCH_NAME##*-} in
    x86_64) OS_ARCH_SUFFIX=amd64 ;;
    aarch64) OS_ARCH_SUFFIX=arm64 ;;
    armv7l) OS_ARCH_SUFFIX=arm ;;
    ppc64le) OS_ARCH_SUFFIX=ppc64le ;;
    s390x) OS_ARCH_SUFFIX=s390x ;;
    *)
        echo >&2 "error: unsupported architecture: '${ARCH_NAME}'"
        exit 1
        ;;
    esac
    curl -fsSLO "https://storage.googleapis.com/minikube/releases/latest/minikube-linux-${OS_ARCH_SUFFIX}"
    sudo install "minikube-linux-${OS_ARCH_SUFFIX}" /usr/local/bin/minikube
    rm -rf "minikube-linux-${OS_ARCH_SUFFIX}"
    ;;
'Darwin')
    brew install minikube
    ;;
*) ;;
esac
