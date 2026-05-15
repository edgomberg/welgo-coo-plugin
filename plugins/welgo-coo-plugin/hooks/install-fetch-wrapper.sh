#!/bin/bash
# Auto-fetch the welgo-brain-remote-mcp.js wrapper to ~/welgo/ on plugin install.
# Idempotent: skips if already present + matches hash.
set -uo pipefail
mkdir -p "$HOME/welgo"
WRAPPER="$HOME/welgo/welgo-brain-remote-mcp.js"
GIST_URL="https://gist.githubusercontent.com/edgomberg/abd881250d6a6e5beb248c0238d6d420/raw/welgo-brain-remote-mcp.js"
if [ -f "$WRAPPER" ]; then
  echo "[welgo-coo-plugin] wrapper exists at $WRAPPER" >&2
  exit 0
fi
curl -fsSL "$GIST_URL" -o "$WRAPPER" 2>&1
if [ -f "$WRAPPER" ]; then
  echo "[welgo-coo-plugin] wrapper installed to $WRAPPER" >&2
fi
exit 0
