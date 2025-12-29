#!/usr/bin/env bash
set -euo pipefail

# Apply an existing dir-diff patch (origin/ vs extract/) onto a freshly unpacked .deb
# and rebuild a new .deb.
#
# Requirements: dpkg-deb, patch, find, md5sum, sed
#
# Usage:
#   ./apply_changes_and_build.sh \
#     -i IPinside-LWS.x86_64.deb \
#     -p changes.patch \
#     -o ipinside-lws-fixed.x86_64.deb

INPUT_DEB=""
PATCH_FILE=""
OUTPUT_DEB=""

usage() {
  cat <<EOF
Usage: $0 -i <input.deb> -p <changes.patch> -o <output.deb>
EOF
}

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || { echo "Missing command: $1" >&2; exit 2; }
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -i) INPUT_DEB="$2"; shift 2;;
    -p) PATCH_FILE="$2"; shift 2;;
    -o) OUTPUT_DEB="$2"; shift 2;;
    -h|--help) usage; exit 0;;
    *) echo "Unknown arg: $1" >&2; usage; exit 2;;
  esac
done

if [[ -z "$INPUT_DEB" || -z "$PATCH_FILE" || -z "$OUTPUT_DEB" ]]; then
  usage
  exit 2
fi

for c in dpkg-deb patch find md5sum sed; do need_cmd "$c"; done

if [[ ! -f "$INPUT_DEB" ]]; then
  echo "Input .deb not found: $INPUT_DEB" >&2
  exit 2
fi
if [[ ! -f "$PATCH_FILE" ]]; then
  echo "Patch file not found: $PATCH_FILE" >&2
  exit 2
fi

WORKDIR="$(mktemp -d -t debpatch.XXXXXXXX)"
trap 'rm -rf "$WORKDIR"' EXIT

PKGDIR="$WORKDIR/pkg"
mkdir -p "$PKGDIR"

# Unpack entire package (data + DEBIAN control scripts)
dpkg-deb -R "$INPUT_DEB" "$PKGDIR"

# Your patch was generated as: diff -ruN origin extract
# That patch has paths like:
#   --- origin/DEBIAN/control ...
#   +++ extract/DEBIAN/control ...
#
# patch(1) will be much happier if we normalize them to:
#   --- DEBIAN/control ...
#   +++ DEBIAN/control ...
#
NORMPATCH="$WORKDIR/changes.normalized.patch"
sed -E \
  -e 's@^(---[[:space:]]+)origin/@\1@' \
  -e 's@^(\+\+\+[[:space:]]+)extract/@\1@' \
  "$PATCH_FILE" > "$NORMPATCH"

# Apply patch inside the unpacked package root
patch -p0 -d "$PKGDIR" < "$NORMPATCH"

# Regenerate md5sums because files changed (DEBIAN/* is excluded)
(
  cd "$PKGDIR"
  find . -type f ! -path './DEBIAN/*' -print0 \
    | sort -z \
    | xargs -0 md5sum \
    | sed 's/ \.\// /' > DEBIAN/md5sums
)

# Build new deb
dpkg-deb -b "$PKGDIR" "$OUTPUT_DEB" >/dev/null

echo "Built: $OUTPUT_DEB"
echo "Output Depends:"
dpkg-deb -f "$OUTPUT_DEB" Depends || true

