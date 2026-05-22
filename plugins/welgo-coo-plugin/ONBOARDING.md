# Welgo Operator Onboarding

Read this once. Bookmark `CHEATSHEET.md` for daily use.

## What this is

You're being set up with Claude Code as your daily operator surface, connected to **Welgo Brain** (the company memory + task system, running on Ed's Mac Mini).

You will:
- Get your tasks from Brain (not Slack, not Notion, not memory)
- Log everything you do back to Brain (so the team knows)
- Use a small set of slash commands for repeatable work

The setup takes one sitting (~30 min). After that, your daily flow is 6 commands you'll learn in week 1.

## Prereqs (one-time, ask Ed if blocked)

1. **Claude Code installed**. https://claude.com/claude-code (free, takes 5 min)
2. **Tailscale installed + signed in** with your Welgo Google account
3. **Ed sent you the tailnet invite** AND you accepted it
4. **Ed sent you your operator slug** (e.g. `patriciad`, `sese`, `ron`). privately via Slack DM

## Install (5 min)

Open Claude Code. In a session, type:

```
/plugin marketplace add edgomberg/welgo-coo-plugin
/plugin install welgo-coo-plugin@welgo-coo
```

Claude prompts to confirm. Hit yes. Then **fully quit Claude Code (Cmd+Q)** and reopen.

On reopen, the plugin auto-creates `~/welgo/.env` with your operator slug placeholder. Open that file in any editor:

```
open ~/welgo/.env
```

Change `OPERATOR=sese` to your slug (the one Ed sent). Save. Done.

Optional: if Ed sent you a bearer token (only needed if Tailscale not ready), uncomment the `MCP_BEARER_TOKEN=` line and paste your token in.

## Verify it works (2 min)

In a new Claude Code session, type:

```
list my open tasks
```

You should see real Welgo task data: counts of open / in-progress / blocked plus a list of tasks assigned to you. NOT a generic AI answer.

If you see "403 Forbidden" or "MCP connection failed": ping Sese OR Ed in Slack DM with the exact error text. Don't keep retrying.

## Recommended additional plugin

For brainstorming + documenting work (used team-wide):

```
/plugin marketplace add anthropics/compound-engineering-plugin
/plugin install compound-engineering@compound-engineering-plugin
```

Restart Claude Code. Now `/ce-brainstorm` and `/ce-compound` work.

## First week walkthrough

**Day 1: install + verify**
- Complete install above
- Run "list my open tasks" to confirm task data returns
- Read `CHEATSHEET.md` (one-pager, 5 min)
- Pin both this file + CHEATSHEET in your editor

**Day 2: log one outside-work task to Brain**
- Pick something you did manually (a phone call, a vendor portal click)
- Tell Claude: "I just called `<vendor>` about `<topic>`. Log this to Welgo Brain as a comm + create a follow-up task for me."
- Verify in "list my open tasks" that it shows up

**Day 3: use `/ce-brainstorm` on one real ambiguous task**
- Pick anything you're unsure how to approach
- Type `/ce-brainstorm`
- Let Claude walk you through scope + write a requirements doc
- Save the doc path Claude returns

**Day 4: voice-check an outbound message**
- Draft any landlord / vendor / guest message
- BEFORE sending: tell Claude "voice-check this draft" and paste it
- Claude catches AI-tells (em-dashes, "I'd be happy to", "leverage", etc.)
- Apply the rewrite, then send

**Day 5: close out work with `/ce-compound`**
- Pick one thing you solved this week that was non-obvious
- Type `/ce-compound`
- Claude writes a `docs/solutions/` entry so the next teammate doesn't re-solve it

**Week 2+**: daily flow becomes second nature.

## Daily flow (locked rule)

1. Open Claude Code at start of shift
2. Ask: "list my open tasks"
3. Work each task inside Claude Code
4. For anything done OUTSIDE Claude Code: tell Claude afterwards, ask it to log to Brain
5. End of shift: ask Claude for an "EOD task summary" to confirm what's done

**Rule of thumb:** Claude Code is your operator surface. Brain is the system of record. If Brain doesn't know, it didn't happen.

## Scope + escalation

See `COO-SCOPE.md` for what you own end-to-end vs what to escalate.

| Question | Where |
|---|---|
| Operational (vendor, property, guest, cleaning) | `#opco` Slack thread |
| Above your role's authority | DM Sese |
| Sese unreachable + urgent | DM Ed |
| Plugin / tech broken | DM Sese first, Ed second |

## When something breaks

Don't keep retrying. Send the exact error text to Sese (or Ed) via Slack DM. The system is opinionated; silent failures are usually a token / auth / config issue, not your fault.

## Companion docs in this plugin

| File | When |
|---|---|
| `README.md` | Install + verify (you read this already) |
| `CHEATSHEET.md` | Daily one-pager, pin this tab |
| `ONBOARDING.md` | This file. First week. |
| `COO-SCOPE.md` | What you own |
| `PARTNER-SCOPE.md` | (Read-only partners only; not you if you're operator) |
| `SKILLS-OVERVIEW.md` | Full slash command catalog |
| `rules/` | Behavior rules Claude enforces (you don't need to read these directly) |

## Welcome

You now have the same operator surface as Sese + the rest of the GSM team. Brain knows you. Time to ship.
