#!/bin/bash
# Idempotent installer for the Welgo Brain remote MCP wrapper + ~/welgo/.env scaffold.
# Runs at Claude Code session start (per hooks.json).
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
# Welgo Brain MCP credentials + identity for this operator.
#
# OPERATOR field (REQUIRED): your operator slug as recognized by Welgo Brain.
#   Valid slugs: ed | angela | sese | tom | jes | ron | patriciad | benjamin | yna
# Ed tells you which slug is yours when he sends your token.
OPERATOR=sese
#
# Two auth paths to Brain (server accepts either):
#   1. Tailscale identity (preferred). If your Mac is signed into Ed's tailnet
#      AND mac-mini-brain.tail59326c.ts.net resolves, NO token is needed.
#   2. Bearer token (fallback for off-tailnet OR while Tailscale install pending).
#      Ed sends your personal MCP_BEARER_TOKEN privately. Uncomment + paste.
# WELGO_BRAIN_URL=https://mac-mini-brain.tail59326c.ts.net
# MCP_BEARER_TOKEN=paste-your-token-here-from-Ed
EOF
  chmod 600 "$ENV_FILE"
fi

# Session-start greeting (self-identify). Reads OPERATOR + prints a one-liner to stderr.
if [ -f "$ENV_FILE" ]; then
  OP=$(awk -F= '/^OPERATOR=/ {sub(/^OPERATOR=/,""); print; exit}' "$ENV_FILE" 2>/dev/null)
  if [ -n "${OP:-}" ]; then
    echo "[welgo-coo-plugin] session-start: you are '${OP}'. Welgo Brain ready. Ask: 'list my open tasks'." >&2
  fi
fi

exit 0
