#!/usr/bin/env bash
set -euo pipefail

VERSION="${1:-}"
if [[ -z "$VERSION" ]]; then
  echo "Usage: $0 <version>"
  echo "Example: $0 14.7.0.7"
  exit 1
fi

REPO_ROOT="$(realpath "$(dirname "$0")/..")"
TEMPLATE="$REPO_ROOT/templates/sox-ng.template.nix"
OUTPUT="$REPO_ROOT/pkgs/sox-ng.nix"

if [[ ! -f "$TEMPLATE" ]]; then
  echo "Error: Template not found: $TEMPLATE"
  exit 1
fi

echo "Updating sox-ng to $VERSION"

echo "Computing source hash..."
TARBALL_URL="https://codeberg.org/sox_ng/sox_ng/archive/sox_ng-${VERSION}.tar.gz"
RAW_HASH=$(nix-prefetch-url "$TARBALL_URL" 2>/dev/null)
SRC_HASH=$(nix hash convert --hash-algo sha256 --to sri "$RAW_HASH")
echo "Source hash: $SRC_HASH"

echo "Generating package..."
sed \
  -e "s|__VERSION__|${VERSION}|g" \
  -e "s|__SRC_HASH__|${SRC_HASH}|g" \
  "$TEMPLATE" > "$OUTPUT"

if grep -q '__[A-Z_]*__' "$OUTPUT"; then
  echo "Error: Unsubstituted placeholders found:"
  grep '__[A-Z_]*__' "$OUTPUT"
  exit 1
fi

echo "Successfully updated sox-ng to $VERSION"
echo ""
cat "$OUTPUT"
