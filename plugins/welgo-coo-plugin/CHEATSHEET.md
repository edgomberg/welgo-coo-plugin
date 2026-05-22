# Welgo Operator Cheatsheet

One page. Pin this tab.

## Daily flow

1. Open Claude Code at the start of your shift.
2. Ask Claude: **"list my open tasks."** Brain returns your queue.
3. Work each task in Claude Code.
4. Anything done OUTSIDE Claude Code (phone call, vendor portal click, in-person work): tell Claude what happened so it gets logged.

Rule of thumb: if Brain doesn't know, it didn't happen.

## Top 6 commands

| Command | What it does | When to use |
|---|---|---|
| `/welgo-status` | Brain returns your open + in-progress queue plus team rollup. | Start of shift. End of shift. Anytime. |
| `/welgo-capture <text>` | Logs an outside-work action (call, portal click, in-person) to Brain as a task assigned to you. | After you do anything outside Claude Code that should be in the system of record. |
| `/welgo-delegate <recipient>: <task>` | Creates a Brain task assigned to a teammate + reminds you to Slack DM them with @-mention. | Handing off a single task to Sese, Tom, Angela, Jes, Ron, Patricia, Benjamin, Yna, or Ed. |
| `/ce-brainstorm` | Walks you through a problem and writes a requirements doc. (Requires compound-engineering-plugin install.) | Stuck on scope. Vendor pick. Ambiguous landlord ask. |
| `/ce-compound` | Documents a solved problem so the team doesn't re-solve it. (Requires compound-engineering-plugin install.) | After you finish something tricky. |
| `mark task <id> done` | Plain English. Closes the task in Brain with your note. | Every time you finish something. |

## Welgo Brain MCP queries (plain English, no slash needed)

Just ask Claude:

- "show me the task summary"
- "search comms for `<vendor name>` in the last 60 days"
- "create a finance task titled '<X>' with priority high"
- "give me the rollup for contact `<person name>`"
- "how many financial messages did we send last week"
- "get the canonical org chart"

Claude routes to the right Brain tool. You don't pick.

## Escalation

| Question | Where |
|---|---|
| Operational (vendor, property, guest, HK) | `#opco` thread |
| Above your authority | DM Sese |
| Sese unreachable + urgent | DM Ed |
| Tech / plugin broken | DM Sese first, Ed if Sese stuck |

## Companion docs

- `README.md`: install + verify
- `ONBOARDING.md`: first-week walkthrough
- `COO-SCOPE.md`: what you own vs escalate
- `SKILLS-OVERVIEW.md`: full skill catalog

## Don't use

These are for Ed only. Skip if you see them in the slash palette:

`/morning-briefing`, `/power-down`, `/weekly-review`, `/post-therapy`, `/atg-*`, `/health-*`, `/learn`, `/dashboard`, `/fin*`, `/buy`, `/grocery`, `/coupon-scout`, `/file-police-report`, `/file-insurance-claim`
