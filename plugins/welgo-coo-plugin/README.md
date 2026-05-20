# welgo-coo-plugin

Pre-packed Claude Code setup for the Welgo COO and GSM team. Built for Jessica Sese (COO) and her 24/7 GSM rotation (Jes, Ron, Patricia, Benjamin, Yna).

## What it does

Bundles everything you need to run COO / GSM work inside Claude Code: scope docs, an MCP connection to Welgo Brain, and session-start hooks. One install command, full operator kit on your laptop.

## Prereqs (one-time per machine)

1. **Claude Code installed.** Free: https://claude.com/claude-code
2. **Tailscale installed and signed in** with your Welgo Google account. Ed sends the tailnet invite or node share. Open the Tailscale app on your Mac.
3. **Your machine appears on Ed's tailnet** as a connected node (Ed verifies this from his side).

The Welgo Brain server has two auth paths:

- **Path A (preferred): tailnet identity.** If your Mac is signed into Ed's tailnet AND `mac-mini-brain.tail59326c.ts.net` resolves on your machine, no token is needed. The server reads your tailnet identity from the proxy header.
- **Path B (fallback): per-operator bearer token.** If you are off-tailnet (e.g., Tailscale install pending OR travel without VPN), Ed sends you a personal bearer token via Slack DM. Paste it into `~/welgo/.env` (the plugin creates this file at session-start as a scaffold).

The plugin handles both paths automatically. You do not pick.

## Install

Inside Claude Code, run:

```
/plugin marketplace add edgomberg/welgo-coo-plugin
/plugin install welgo-coo-plugin@welgo-coo
```

Claude Code prompts you to confirm. Hit yes. Restart Claude Code.

The session-start hook auto-downloads the Welgo Brain wrapper file to `~/welgo/welgo-brain-remote-mcp.js` and creates the `~/welgo/.env` scaffold on first run.

## Verify install

In a new Claude Code session, type:

```
Use welgo-brain to give me the task summary.
```

You should see real Welgo task data: counts of open / in-progress / blocked tasks plus a `byAssignee` array. NOT a generic AI answer. If you see an error, ping Sese OR Ed in Slack DM and paste the error text.

## Daily flow (mandate)

1. Open Claude Code at start of your shift.
2. Run `/plugin list` to confirm `welgo-coo-plugin` is loaded.
3. Ask Claude for your open tasks: "list my open tasks."
4. Work each task inside Claude Code where possible.
5. Anything you do OUTSIDE Claude Code (phone call, vendor portal click, manual app action, in-person work): describe it in Claude chat afterwards AND tell Claude to log it to Welgo Brain. Claude records it as a task or comm so the system knows.

Rule of thumb: if it happened and it matters to Welgo, Brain knows. If Brain does not know, it did not happen.

## Scope

- **COO-SCOPE.md** in this plugin — Sese owns ops end-to-end. GSM rotation executes within Sese's scope.
- Cross-reference **CFO-SCOPE.md** in `welgo-cfo-plugin` (Angela's) for money-side cross-checks.

## Escalation

| Question | Channel |
|---|---|
| Operational (vendor, property, guest, cleaning, HK) | `#opco` thread |
| Anything above your role's authority | DM Sese (COO) |
| Sese unreachable + urgent | DM Ed |

## Reading history

- 2026-05-19 v0.3 — Dual-auth (tailnet identity preferred, per-operator bearer fallback via `~/welgo/.env`). Scope expanded from "Sese only" to "Sese + GSM rotation". README rewritten. Adds Daily flow mandate: Claude Code is the operator surface; outside-work logs back to Brain.
- 2026-05-14 v0.1 — Initial COO scaffold for Sese.
