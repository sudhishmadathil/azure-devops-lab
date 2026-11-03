#!/usr/bin/env bash
set -euo pipefail

ARCH=$(uname -m)
case "$ARCH" in
  x86_64) ARCH=amd64 ;;
  aarch64|arm64) ARCH=arm64 ;;
  *)
    echo "Unsupported architecture: $ARCH" >&2
    exit 1
    ;;
esac

# Install kind and kubectl.
curl -fsSLo /tmp/kind \
  "https://github.com/kubernetes-sigs/kind/releases/latest/download/kind-linux-${ARCH}"
sudo install -m 0755 /tmp/kind /usr/local/bin/kind

KUBECTL_VERSION=$(curl -fsSL https://dl.k8s.io/release/stable.txt)
curl -fsSLo /tmp/kubectl \
  "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${ARCH}/kubectl"
sudo install -m 0755 /tmp/kubectl /usr/local/bin/kubectl

# Enable kubectl completion and the "k" alias in Bash.
cat >> "$HOME/.bashrc" <<'BASHRC'
alias k=kubectl
source <(kubectl completion bash)
complete -o default -F __start_kubectl k
BASHRC
