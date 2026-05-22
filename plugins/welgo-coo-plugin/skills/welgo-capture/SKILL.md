---
name: welgo-capture
description: Log something you did outside Claude Code (phone call, vendor portal click, in-person work, ad-hoc commitment) into Welgo Brain as a task or comm. Use when the operator types /welgo-capture, "log this", "remember I did X", or describes any outside-work action that should be in the system of record.
model: sonnet
allowed-tools: "mcp__welgo-brain-remote__create_task, mcp__welgo-brain-remote__search_comms"
---

# /welgo-capture

Operator-facing capture skill. Logs an outside-work action to Welgo Brain so the team's system of record stays honest.

## When to fire

- Operator typed `/welgo-capture <text>` explicitly
- Operator said "log this to brain" / "remember I just X" / "capture that I called Y"
- Operator described an action they took OUTSIDE Claude Code that has follow-up value (vendor call, portal click, in-person walkthrough, ad-hoc decision, anything not already a Brain task)

## When NOT to fire

- Action already logged via another skill this session
- Pure status question ("how is X going") with no new action
- Operator explicitly says "don't log this"

## What you do

1. Parse the operator's text into:
   - **title**: short imperative summary (≤80 chars). Example: "Called vendor Acme re: HVAC quote, awaiting callback Mon"
   - **description**: full context: what happened, who was involved, what's pending, any deadline mentioned
   - **counterparty**: name of vendor/landlord/guest if mentioned, else null
   - **followup**: was there a next step? If yes, embed in description
   - **priority**: `low` (FYI log), `medium` (default), `high` (operator flagged urgent or blocker)

2. Identify operator slug from `~/welgo/.env` `OPERATOR=` line. If you cannot read it, ask the operator their slug once and remember for the session.

3. Call `mcp__welgo-brain-remote__create_task`:
   ```
   title: <parsed title>
   assigneeId: <operator slug>
   reporterId: <operator slug>
   description: <parsed description>
   priority: <parsed priority>
   ```

4. Return to operator in chat:
   ```
   ✓ Logged to Brain.
     Task ID: <returned id>
     Title: <title>
     Assigned: you (<slug>)
     Priority: <priority>
   ```

5. If `create_task` errors:
   - 403 → tell operator their Brain auth is broken. Suggest restart Claude Code, then DM Sese if still broken. Do NOT silently retry.
   - 4xx other → surface exact error text. Suggest fixing input.
   - 5xx → Brain server down. Tell operator to ping Sese/Ed.

## Voice + tone

Plain English. No em-dashes. No "I'd be happy to" / "great question". Just receipt + next step.

## Anti-pattern: do not log as comm

Welgo Brain `search_comms` is read-only. Operator-initiated captures land as TASKS (with description capturing the comm content), not as new comms. Comms are auto-ingested from Slack / Gmail / WhatsApp pipelines elsewhere.

## Companion

- Daily flow rule: anything done outside Claude Code gets `/welgo-capture` afterwards.
- Pair with `/welgo-status` at end of shift to confirm everything captured.
