#!/usr/bin/env bash
set -euo pipefail

BIN_DIR="$HOME/.local/bin"
BIN_PATH="$BIN_DIR/nix"
ARCH="$(uname -m)"
URL="https://github.com/DavHau/nix-portable/releases/latest/download/nix-portable-$ARCH"

if ! command -v curl &>/dev/null; then
  echo "Error: curl is not installed"
  exit 1
fi

if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
  echo "Error: $BIN_DIR is not in PATH"
  exit 1
fi

if command -v nix &>/dev/null; then
  echo "Error: nix is already installed at $(command -v nix)"
  exit 1
fi

echo "Downloading nix-portable for $ARCH..."
mkdir -p "$BIN_DIR"
curl -L -o "$BIN_PATH" "$URL"
chmod +x "$BIN_PATH"

echo "Verifying installation..."
if nix --version; then
  echo "Done."
else
  echo "Error: nix failed to run. Check $BIN_PATH"
  exit 1
fi
