---
name: welgo-delegate
description: Delegate a Welgo task to a teammate. Creates a task in Welgo Brain assigned to the recipient with full context, deadline, and priority. Reminds the operator to also Slack-DM the recipient with @-mention so they get push-notified. Use when operator types /welgo-delegate, "delegate this to <name>", "hand off X to Sese", "Tom needs to do Y", or describes work that should move to someone else's queue.
model: sonnet
allowed-tools: "mcp__welgo-brain-remote__create_task"
---

# /welgo-delegate

Tactical delegation skill for operators. Single discrete task to a single teammate. Brain holds the receipt; operator still owes a Slack DM with @-mention.

## When to fire

- Operator typed `/welgo-delegate <recipient>: <task>` OR `/welgo-delegate` (then guided)
- Operator said "delegate this to <name>" / "hand off to <name>" / "<name> needs to do X"
- Operator finished a task that has a follow-up belonging to someone else

## When NOT to fire

- Recipient is the operator themselves (use `/welgo-capture` instead)
- Recipient is external (vendor, landlord, guest): those go through Slack/email/phone, not Brain tasks
- Principal-mode handoff (ongoing ownership transfer, not single task): escalate to Sese, who routes to Ed for principal framing

## What you do

1. Parse the operator's input into:
   - **recipient slug**: must be one of: `ed | angela | sese | tom | jes | ron | patriciad | benjamin | yna`
   - **title**: short imperative (≤80 chars). Example: "Confirm HVAC vendor quote received from Acme by Mon"
   - **description**: full context: what triggered this, what counterparty is involved, what success looks like, any links/IDs
   - **deadline**: explicit date if mentioned, else null
   - **priority**: `low / medium / high`, default `medium`

2. If recipient is ambiguous or unknown, ask operator to clarify (one question, then proceed).

3. Identify operator slug from `~/welgo/.env` (this is the reporter / requester).

4. Call `mcp__welgo-brain-remote__create_task`:
   ```
   title: <parsed title>
   assigneeId: <recipient slug>
   reporterId: <operator slug>
   description: <parsed description>
   priority: <parsed priority>
   dueDate: <ISO date if parsed, else omit>
   ```

5. Return to operator:
   ```
   ✓ Delegated to <recipient>.
     Task ID: <returned id>
     Title: <title>
     Priority: <priority>
     Due: <date or 'not set'>

     ⚠ Next step (mandatory): Slack DM <recipient> with @-mention so they get push-notified.
       Format: parent post = "**<@USERID>: <title>**" + thread reply with the ask body.
       Why: Brain alone does not auto-ping. Without the DM, recipient may not see this for hours.

     Receipt watch: ping <recipient> again in 4 hours if no acknowledgment.
   ```

6. Do NOT auto-send the Slack DM from this skill. The operator owns the send (per voice-check + delegation-thread-pattern rules).

7. If `create_task` errors:
   - 4xx with "invalid assigneeId" → recipient slug typo, ask operator to correct
   - 403 → auth broken, restart Claude Code then DM Sese
   - 5xx → Brain down, ping Sese/Ed

## Voice + tone

Operational, no fluff. Operator already decided to delegate: your job is to lock the receipt + remind them about the DM step.

## Anti-pattern: do not skip the DM reminder

A task created in Brain without a follow-up Slack DM lands silently in the recipient's queue. They may not check Brain for hours. The 4-hour receipt watch is real. The DM is non-negotiable.

## Companion

- After this skill: operator drafts the Slack DM. They can ask Claude "draft the Slack DM for the task I just delegated to <recipient>" and Claude will produce the parent + thread structure.
- Pair with `/welgo-status` later to confirm recipient acknowledged.
