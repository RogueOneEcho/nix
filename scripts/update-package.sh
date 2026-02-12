#!/usr/bin/env bash
set -euo pipefail

NAME="${1:-}"
VERSION="${2:-}"
REPO="${3:-RogueOneEcho/${NAME}}"
if [[ -z "$NAME" || -z "$VERSION" ]]; then
  echo "Usage: $0 <name> <version> [repo]"
  echo "Example: $0 caesura 0.26.0"
  exit 1
fi

REPO_ROOT="$(realpath "$(dirname "$0")/..")"
TEMPLATE="$REPO_ROOT/templates/${NAME}.template.nix"
OUTPUT="$REPO_ROOT/pkgs/${NAME}.nix"

if [[ ! -f "$TEMPLATE" ]]; then
  echo "Error: Template not found: $TEMPLATE"
  exit 1
fi

echo "Updating $NAME to $VERSION from $REPO"

# Compute source hash
echo "Computing source hash..."
TARBALL_URL="https://github.com/${REPO}/archive/refs/tags/v${VERSION}.tar.gz"
RAW_HASH=$(nix-prefetch-url --unpack "$TARBALL_URL" 2>/dev/null)
SRC_HASH=$(nix hash convert --hash-algo sha256 --to sri "$RAW_HASH")
echo "Source hash: $SRC_HASH"

# Generate package with fake cargo hash to trigger build error
FAKE_HASH="sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
echo "Computing cargo hash (this will build dependencies)..."
sed \
  -e "s|__VERSION__|${VERSION}|g" \
  -e "s|__SRC_HASH__|${SRC_HASH}|g" \
  -e "s|__CARGO_HASH__|${FAKE_HASH}|g" \
  "$TEMPLATE" > "$OUTPUT"

# Attempt build to get correct cargo hash
cd "$REPO_ROOT"
BUILD_OUTPUT=$(nix build ".#${NAME}" 2>&1 || true)
CARGO_HASH=$(echo "$BUILD_OUTPUT" | grep -oP 'got:\s+\Ksha256-[A-Za-z0-9+/=]+' | head -1 || true)

if [[ -z "$CARGO_HASH" ]]; then
  echo "Error: Could not extract cargo hash from build output"
  echo "$BUILD_OUTPUT"
  exit 1
fi

echo "Cargo hash: $CARGO_HASH"

# Generate final package with correct hashes
echo "Generating package..."
sed \
  -e "s|__VERSION__|${VERSION}|g" \
  -e "s|__SRC_HASH__|${SRC_HASH}|g" \
  -e "s|__CARGO_HASH__|${CARGO_HASH}|g" \
  "$TEMPLATE" > "$OUTPUT"

# Check for unsubstituted placeholders
if grep -q '__[A-Z_]*__' "$OUTPUT"; then
  echo "Error: Unsubstituted placeholders found:"
  grep '__[A-Z_]*__' "$OUTPUT"
  exit 1
fi

# Update flake.lock
echo "Updating flake.lock..."
nix flake update

echo "Successfully updated $NAME to $VERSION"
echo ""
cat "$OUTPUT"
