#!/usr/bin/env bash
# Welgo operator SessionStart forcing hook.
#
# THE FORCING LOOP: when an operator opens Claude Code, this pulls their
# assigned tasks from Welgo Brain and injects a forcing instruction so the
# session CANNOT proceed to work until the operator (1) picks which task they
# are on, (2) confirms the right model, (3) clears any due micro-quiz.
#
# Zero-trust client side. The gateway is the un-bypassable server-side force;
# this is the client-side gate that makes every operator session START on-task.
#
# Contract:
#   - exit 0 ALWAYS. Never block session start on error (fail-open to a softer
#     prompt, never a hard crash).
#   - NO secrets to stdout/stderr. Bearer token only via Authorization header.
#   - Emits SessionStart additionalContext JSON on stdout (the forcing block).
#   - Diagnostic logs to /tmp only.
set -uo pipefail

ENV_FILE="$HOME/welgo/.env"
LOG_FILE="/tmp/welgo-session-brief-$(date +%Y%m%d).log"
BRAIN_URL_DEFAULT="https://mac-mini-brain.tail59326c.ts.net"
LEARN_DB="$HOME/life-os/data/learning/learning.db"
EXPECTED_MODEL_DEFAULT="sonnet"   # operators run Sonnet: capable + cost-right. Opus = Ed only.

log() { printf '[%s] %s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$*" >>"$LOG_FILE" 2>/dev/null || true; }

# additionalContext emitter. $1 = the forcing text. Always exit 0 after.
emit() {
  python3 - "$1" <<'PY' 2>/dev/null || true
import json, sys
print(json.dumps({
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": sys.argv[1],
  }
}))
PY
  exit 0
}

# --- no env / no operator => soft nudge, do not force (Ed dev sessions etc) ---
if [ ! -f "$ENV_FILE" ]; then
  log "no env at $ENV_FILE; soft nudge"
  emit "WELGO SESSION: no operator profile found (~/welgo/.env missing). If you are a Welgo operator, finish plugin setup before working."
fi

OPERATOR=$(awk -F= '/^OPERATOR=/ {sub(/^OPERATOR=/,""); print; exit}' "$ENV_FILE" 2>/dev/null || true)
if [ -z "${OPERATOR:-}" ]; then
  log "no OPERATOR slug; soft nudge"
  emit "WELGO SESSION: operator slug not set in ~/welgo/.env. Set OPERATOR=<your-slug> to enable your task brief."
fi

# --- read brain url + bearer (uncommented lines only; no leakage) ---
WELGO_BRAIN_URL=""; MCP_BEARER_TOKEN=""
while IFS= read -r line; do
  case "$line" in
    \#*|"") continue ;;
    WELGO_BRAIN_URL=*) WELGO_BRAIN_URL="${line#WELGO_BRAIN_URL=}" ;;
    MCP_BEARER_TOKEN=*) MCP_BEARER_TOKEN="${line#MCP_BEARER_TOKEN=}" ;;
    EXPECTED_MODEL=*) EXPECTED_MODEL_DEFAULT="${line#EXPECTED_MODEL=}" ;;
  esac
done <"$ENV_FILE"
BRAIN_URL="${WELGO_BRAIN_URL:-$BRAIN_URL_DEFAULT}"

# --- pull operator's open + in_progress tasks from Brain ---
AUTH=(); [ -n "${MCP_BEARER_TOKEN:-}" ] && AUTH=(-H "Authorization: Bearer $MCP_BEARER_TOKEN")
TASKS_JSON=$(curl -fsS --max-time 6 "${AUTH[@]}" \
  "${BRAIN_URL}/api/mcp/tasks?assigneeId=${OPERATOR}" 2>>"$LOG_FILE") || TASKS_JSON=""

# --- model check (client-side surface; gateway enforces server-side) ---
ACTUAL_MODEL="${ANTHROPIC_MODEL:-${CLAUDE_CODE_MODEL:-unknown}}"

# --- due quiz count (Claude-Code operators only; learning.db local) ---
DUE_QUIZ=0
QUIZ_DOMAIN="operator-skills"
if [ -f "$LEARN_DB" ]; then
  # card_state view LEFT-JOINs latest review; NULL next_due_ts = never reviewed = due.
  # next_due_ts is ISO text, so compare against an ISO 'now', not epoch.
  DUE_QUIZ=$(sqlite3 "$LEARN_DB" \
    "SELECT COUNT(*) FROM card_state WHERE domain='${QUIZ_DOMAIN}' AND (next_due_ts IS NULL OR next_due_ts <= strftime('%Y-%m-%dT%H:%M:%SZ','now'));" 2>/dev/null || echo 0)
  [ -z "$DUE_QUIZ" ] && DUE_QUIZ=0
fi

# --- build the forcing block ---
BRIEF=$(OPERATOR="$OPERATOR" ACTUAL_MODEL="$ACTUAL_MODEL" \
        EXPECTED_MODEL="$EXPECTED_MODEL_DEFAULT" DUE_QUIZ="$DUE_QUIZ" \
        python3 - "$TASKS_JSON" <<'PY' 2>/dev/null || true
import json, os, sys
op  = os.environ.get("OPERATOR","?")
act = os.environ.get("ACTUAL_MODEL","unknown")
exp = os.environ.get("EXPECTED_MODEL","sonnet")
due = os.environ.get("DUE_QUIZ","0")
raw = sys.argv[1] if len(sys.argv) > 1 else ""

tasks = []
try:
    d = json.loads(raw) if raw else {}
    if isinstance(d, list):
        tasks = d
    elif isinstance(d, dict):
        # Brain REST envelope is {success, data, timestamp}; data is the task list.
        tasks = d.get("data", d.get("tasks", []))
    if not isinstance(tasks, list):
        tasks = []
except Exception:
    tasks = []

def status(t): return (t.get("status") or "").lower()
inprog = [t for t in tasks if status(t) == "in_progress"]
openish = [t for t in tasks if status(t) == "open"]

lines = []
lines.append(f"WELGO ZERO-TRUST SESSION GATE — operator: {op}")
lines.append("")
lines.append("Before doing ANY work this session you MUST walk the operator through these three checks, in order. Do not start a task until all three clear.")
lines.append("")
# 1 — task
lines.append("1) ON-TASK CHECK. The operator's Welgo Brain queue right now:")
if inprog:
    lines.append("   IN PROGRESS (finish these first):")
    for t in inprog[:5]:
        lines.append(f"     - [{t.get('priority','?')}] {t.get('title','(untitled)')}  (id {str(t.get('id',''))[:8]})")
if openish:
    lines.append("   OPEN (not started):")
    for t in openish[:5]:
        lines.append(f"     - [{t.get('priority','?')}] {t.get('title','(untitled)')}  (id {str(t.get('id',''))[:8]})")
if not inprog and not openish:
    lines.append("   (no open/in-progress tasks found for this operator — confirm with Ed before inventing work)")
lines.append("   ASK the operator which ONE task they are working on this session. If they name something NOT on this list, that is off-task: stop and have them check with Ed.")
lines.append("")
# 2 — model
mflag = "OK" if exp.lower() in act.lower() else "WRONG MODEL"
lines.append(f"2) MODEL CHECK. Expected: {exp}. Detected: {act}.  -> {mflag}")
if mflag != "OK":
    lines.append(f"   The operator is NOT on the right model. Tell them to switch to {exp} (cheaper + correct for operator work) before continuing. Opus is Ed-only.")
lines.append("")
# 3 — quiz
lines.append("3) LEARN CHECK.")
if due and due != "0":
    lines.append(f"   {due} micro-quiz card(s) DUE (operator-skills: which model, commands, modes, prompting). Run ONE now: `/learn operator-skills` (1 question, ~30s). Not optional — this is how skill stays sharp.")
else:
    lines.append("   No quiz cards due. (If none ever appear, the operator-skills card set has not been generated — flag to Ed.)")
lines.append("")
lines.append("Run these as a short coached exchange (one at a time, plain language). Then proceed to the chosen task.")
print("\n".join(lines))
PY
)

[ -z "${BRIEF:-}" ] && BRIEF="WELGO SESSION: could not reach Brain for your task brief (offline or auth). Confirm your task + model with Ed before working. Detail in $LOG_FILE."
log "brief built operator=$OPERATOR model=$ACTUAL_MODEL due_quiz=$DUE_QUIZ tasks_bytes=${#TASKS_JSON}"
emit "$BRIEF"
