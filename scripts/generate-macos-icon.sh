#!/usr/bin/env bash
set -euo pipefail

# Generate a macOS .icns app icon from img/logo.png
# Usage:
#   bash scripts/generate-macos-icon.sh [source_png] [output_icns]

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC_PNG="${1:-"$ROOT_DIR/img/logo.png"}"
OUT_ICNS="${2:-"$ROOT_DIR/img/icon.icns"}"

if [[ ! -f "$SRC_PNG" ]]; then
  echo "Source PNG not found: $SRC_PNG" >&2
  exit 1
fi

if ! command -v sips >/dev/null 2>&1; then
  echo "Missing required tool: sips (macOS built-in)" >&2
  exit 1
fi

if ! command -v iconutil >/dev/null 2>&1; then
  echo "Missing required tool: iconutil (macOS built-in)" >&2
  exit 1
fi

TMP_DIR="$(mktemp -d)"
ICONSET_DIR="$TMP_DIR/icon.iconset"
mkdir -p "$ICONSET_DIR"

declare -a sizes=(16 32 128 256 512)

# Standard + Retina (@2x) assets. iconutil expects this naming scheme.
for size in "${sizes[@]}"; do
  sips -z "$size" "$size" "$SRC_PNG" --out "$ICONSET_DIR/icon_${size}x${size}.png" >/dev/null
  sips -z "$((size * 2))" "$((size * 2))" "$SRC_PNG" --out "$ICONSET_DIR/icon_${size}x${size}@2x.png" >/dev/null
done

iconutil -c icns "$ICONSET_DIR" -o "$OUT_ICNS"

rm -rf "$TMP_DIR"
echo "Wrote: $OUT_ICNS"
