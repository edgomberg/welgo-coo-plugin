#!/bin/bash
# Idempotent installer for the Welgo Brain remote MCP wrapper.
# Runs at Claude Code session start (per hooks.json).
# - Downloads the wrapper script if missing.
# - Creates ~/welgo/.env scaffold if missing so the operator can paste their bearer token.
set -uo pipefail

mkdir -p "$HOME/welgo"
WRAPPER="$HOME/welgo/welgo-brain-remote-mcp.js"
GIST_URL="https://gist.githubusercontent.com/edgomberg/abd881250d6a6e5beb248c0238d6d420/raw/welgo-brain-remote-mcp.js"

if [ ! -f "$WRAPPER" ]; then
  curl -fsSL "$GIST_URL" -o "$WRAPPER" 2>&1 || true
fi

ENV_FILE="$HOME/welgo/.env"
if [ ! -f "$ENV_FILE" ]; then
  cat >"$ENV_FILE" <<'EOF'
# Welgo Brain MCP credentials for this operator.
# Two auth paths (Brain accepts either):
#   1. Tailscale identity (preferred). If your Mac is signed into Ed's tailnet
#      AND mac-mini-brain.tail59326c.ts.net resolves, NO token is needed.
#   2. Bearer token (fallback). Ed sends your personal MCP_BEARER_TOKEN privately.
#      Uncomment and paste below.
# WELGO_BRAIN_URL=https://mac-mini-brain.tail59326c.ts.net
# MCP_BEARER_TOKEN=paste-your-token-here-from-Ed
EOF
  chmod 600 "$ENV_FILE"
fi

exit 0
