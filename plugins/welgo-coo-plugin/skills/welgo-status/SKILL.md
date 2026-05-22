---
name: welgo-status
description: Show the operator's Welgo Brain queue and team-wide task summary. Use when operator types /welgo-status, "what's my queue", "list my open tasks", "show me my tasks", "what am I working on", or starts a shift and needs to see what's pending.
model: sonnet
allowed-tools: "mcp__welgo-brain-remote__list_tasks, mcp__welgo-brain-remote__get_task_summary"
---

# /welgo-status

Operator queue + team-wide summary from Welgo Brain. No local files. No Ed-personal paths.

## When to fire

- Operator typed `/welgo-status` explicitly
- Operator said "list my open tasks" / "what's my queue" / "what am I working on" / "show me my tasks"
- Start of shift (operator opens Claude Code + asks for status)
- End of shift (operator confirming what's done vs pending)

## When NOT to fire

- Operator asked for someone else's queue specifically (use list_tasks with their assigneeId instead)
- Operator asked for a single task by ID (use list_tasks filter or just answer from prior context)

## What you do

1. Identify operator slug from `~/welgo/.env` `OPERATOR=` line. If missing, ask once.

2. Call BOTH tools in parallel (single message, two tool calls):
   - `mcp__welgo-brain-remote__get_task_summary` (no args, returns org-wide rollup)
   - `mcp__welgo-brain-remote__list_tasks` with `assigneeId=<operator slug>` and `status=open,in_progress`

3. Format reply to operator. Default shape:

```
Your queue (<slug>):
  open: <N>    in_progress: <M>    overdue: <K>

Top by priority:
  [high] <task-id>: <title>   (due <date> if set)
  [high] <task-id>: <title>
  [med]  <task-id>: <title>
  ...
  (show up to 7; trim if more)

Team-wide today:
  open: <total>   in_progress: <total>   blocked: <total>
  recently closed: <N>
  byAssignee: sese=<N>, tom=<N>, angela=<N>, ed=<N>, you=<N>, ...
```

4. If operator has 0 open: say so plainly. "Queue empty. Nothing assigned to you right now."

5. Surface overdue items at top in **bold** with `[OVERDUE]` tag and number of days late.

6. If both tools error:
   - 403 → Brain auth broken. Tell operator to fully quit Claude Code (Cmd+Q) + reopen. If still broken, DM Sese.
   - 5xx → Brain server down. Ping Sese/Ed.

## Voice + tone

Scannable. Operator reads in 5 seconds. No filler. No em-dashes.

## Anti-pattern: do not summarize content

Don't paraphrase task titles to "make them friendlier". Show exact task title + ID so operator can reference + update.

## Companion

- Pair with `/welgo-capture` if operator discovers a missing task during status review.
- Pair with `/welgo-delegate` if operator decides to hand a task to a teammate.
- Use `mark task <id> done` (plain English, no slash) to close a task during the same conversation.
