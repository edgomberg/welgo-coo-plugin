#!/bin/bash
# Welgo plugin auto-update check.
# Runs at Claude Code session start. Compares local plugin version to remote
# (GitHub main branch). Surfaces banner if newer remote exists.
# Operator runs `/plugin update welgo-coo-plugin` to pull.
# Locked 2026-05-22 per operator-mcp-auth-multi-token rule + plugin distribution architecture A.

set -uo pipefail

PLUGIN_NAME="welgo-coo-plugin"
REPO_OWNER="edgomberg"
REPO_BRANCH="main"
MARKETPLACE_NAME="welgo-coo"

# Locate this plugin's plugin.json relative to the hook script
PLUGIN_DIR="$(cd "$(dirname "$0")/.." && pwd)"
LOCAL_PLUGIN_JSON="$PLUGIN_DIR/.claude-plugin/plugin.json"

[ -f "$LOCAL_PLUGIN_JSON" ] || exit 0

LOCAL_VERSION=$(python3 -c "import json; print(json.load(open('$LOCAL_PLUGIN_JSON')).get('version',''))" 2>/dev/null)
[ -n "$LOCAL_VERSION" ] || exit 0

# Fetch remote plugin.json (5s timeout — never block session start)
REMOTE_URL="https://raw.githubusercontent.com/${REPO_OWNER}/${PLUGIN_NAME}/${REPO_BRANCH}/plugins/${PLUGIN_NAME}/.claude-plugin/plugin.json"
REMOTE_JSON=$(curl -fsSL --max-time 5 "$REMOTE_URL" 2>/dev/null) || exit 0
REMOTE_VERSION=$(echo "$REMOTE_JSON" | python3 -c "import sys,json; print(json.load(sys.stdin).get('version',''))" 2>/dev/null)

[ -n "$REMOTE_VERSION" ] || exit 0

if [ "$LOCAL_VERSION" != "$REMOTE_VERSION" ]; then
  cat >&2 <<BANNER

╭─────────────────────────────────────────────────────────────╮
│ ${PLUGIN_NAME} update available                              
│   local:  v${LOCAL_VERSION}                                 
│   remote: v${REMOTE_VERSION}                                
│                                                             
│   Run: /plugin update ${PLUGIN_NAME}@${MARKETPLACE_NAME}    
╰─────────────────────────────────────────────────────────────╯

BANNER
fi

exit 0
