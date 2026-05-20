# Skills you have access to (Welgo COO / GSM team)

Inside Claude Code, type `/<skill-name>` to invoke any of these. Many are universal Life OS skills; some are Welgo-specific.

## Daily-use (CRITICAL — use these to keep the system honest)

| Skill | When to use |
|---|---|
| `/capture` | Anything you do outside Claude Code (phone call, vendor portal action, manual app click, in-person work). Tell Claude what happened. Claude logs to Welgo Brain as a task or comm. This is the system-of-record discipline. |
| `/transcribe-voice-note` | Voice memo → transcript. Use for phone calls to vendors, landlords, contractors. |
| `/pull-call` | Force-pull and transcribe a recent phone call from the call pipeline (Cube ACR via Drive). |
| `/voice-check` | MANDATORY before any outbound to landlord, vendor, guest. Catches AI-tells + voice mismatch. |
| `/pre-delegate` | Before you delegate a task to anyone (cleaner, vendor, contractor): spec deliverable + deadline + fallback. |

## Welgo Brain MCP queries (English, no skill prefix needed)

You ask the brain in plain English. Examples:

- "List my open tasks"
- "Show me the task summary"
- "Search comms for `<vendor name>` in the last 60 days"
- "Create a finance task for me titled 'X' with priority high"
- "Mark task `<id>` as resolved with note 'done'"
- "Give me the rollup for contact `<person>`"
- "How many financial messages did we send last week"
- "Get the canonical org chart" (CFO/COO scope facts)

Claude routes to the right MCP tool.

## Work flow / quality

| Skill | When |
|---|---|
| `/grill-me` | Pressure-test any decision (vendor pick, escalation framing, scope question) before you commit. |
| `/clarify-before-solve` (built-in) | Ed's house rule: before any multi-step action, restate what you know + ask one clarifying question. |
| `/preserve-evidence` | Any incident, dispute, or evidence-bearing artifact: preserve before you act. |
| `/cheatsheet` | Quick reference of common commands. |

## Coordination

| Skill | When |
|---|---|
| `/pre-call` | Before a 1:1 with Sese or Ed: pulls role card + recent context. |
| `/one-on-one` | Structured 1:1 with manager. |
| `/role-card` | View / update your own role card. |
| `/goals-card` | Quarterly goals. |
| `/follow-up-track` | Tag any outbound (email, Slack, vendor message) you expect a reply on. Receipt watch auto-fires. |

## DON'T use these (they are for Ed only OR personal contexts)

- `/morning-briefing`, `/power-down`, `/weekly-review`, `/post-therapy`, `/atg-analyze`, `/health-photo-track`, `/learn`, `/dashboard` — Ed's personal Life OS ritual surface
- `/fin*`, `/buy`, `/grocery`, `/coupon-scout` — Ed's personal finance + purchasing
- `/file-police-report`, `/file-insurance-claim` — Ed-direct legal / insurance

## Discovery

Type `/` inside Claude Code to see the full slash-command palette. Skills you should not use are listed above so you can skip them.

## Rule of thumb

Claude Code is your operator surface. Welgo Brain is your system of record. If you did the work but it is not in Brain, the work did not happen.
