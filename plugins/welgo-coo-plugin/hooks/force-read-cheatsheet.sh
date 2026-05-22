#!/usr/bin/env bash
# Force-display CHEATSHEET.md on first session per major version.
# Marker stored in ~/.welgo/.cheatsheet-version-read
# Operator must see cheatsheet once per plugin version bump.

set -u

MARKER_DIR="$HOME/.welgo"
MARKER_FILE="$MARKER_DIR/.cheatsheet-version-read"
CHEATSHEET="${CLAUDE_PLUGIN_ROOT}/CHEATSHEET.md"
VERSION_FILE="${CLAUDE_PLUGIN_ROOT}/.version"

[ -f "$CHEATSHEET" ] || exit 0

CURRENT_VERSION="$(cat "$VERSION_FILE" 2>/dev/null || echo "unknown")"
LAST_READ="$(cat "$MARKER_FILE" 2>/dev/null || echo "")"

if [ "$CURRENT_VERSION" = "$LAST_READ" ]; then
  exit 0
fi

mkdir -p "$MARKER_DIR"

cat >&2 <<EOF

============================================================
  📘 WELGO COO PLUGIN — CHEATSHEET (v${CURRENT_VERSION})
  First time on this version. Read once. Then we proceed.
============================================================

EOF

cat "$CHEATSHEET" >&2

cat >&2 <<EOF

============================================================
  Marker set: ~/.welgo/.cheatsheet-version-read = ${CURRENT_VERSION}
  Will display again on next plugin version bump.
============================================================

EOF

echo "$CURRENT_VERSION" > "$MARKER_FILE"
exit 0
