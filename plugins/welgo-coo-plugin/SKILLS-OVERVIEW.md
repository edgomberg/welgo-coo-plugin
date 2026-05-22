# Skills you have access to (Welgo COO / GSM team)

Inside Claude Code, type `/<skill-name>` to invoke any of these.

## Bundled in this plugin (work today, zero extra install)

These 3 skills ship inside `welgo-coo-plugin` and wrap Welgo Brain MCP directly. They work the moment your `/plugin install` succeeds.

| Skill | When to use |
|---|---|
| `/welgo-capture` | Anything you did outside Claude Code (phone call, vendor portal click, in-person work). Logs to Welgo Brain as a task assigned to you. |
| `/welgo-status` | Start of shift. End of shift. Anytime you forget what's in your queue. Shows your open + in-progress tasks plus team-wide rollup. |
| `/welgo-delegate` | Hand a single task to a teammate (Sese, Tom, Angela, Jes, Ron, Patricia, Benjamin, Yna, Ed). Creates the Brain task + reminds you to Slack DM the recipient. |

## Recommended additional plugin (Anthropic-official, optional)

Install with:
```
/plugin marketplace add anthropics/compound-engineering-plugin
/plugin install compound-engineering@compound-engineering-plugin
```

| Skill | When |
|---|---|
| `/ce-brainstorm` | Pressure-test scope before you commit (vendor pick, escalation framing, ambiguous landlord ask). |
| `/ce-compound` | After you solve something non-obvious, document it so the team does not re-solve. |
| `/ce-plan` | Multi-step work that needs structure before execution. |

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

## Discovery

Type `/` inside Claude Code to see the full slash-command palette. Use the 3 bundled `/welgo-*` skills above + (optionally) the `compound-engineering-plugin` set. Everything else in your palette is Ed's personal Life OS kit and will NOT work for you (those skills read from Ed's local files you do not have).

Examples of Ed-personal skills to skip: `/morning-briefing`, `/power-down`, `/weekly-review`, `/post-therapy`, `/atg-*`, `/health-*`, `/learn`, `/dashboard`, `/fin*`, `/buy`, `/grocery`, `/coupon-scout`, `/file-police-report`, `/file-insurance-claim`, `/capture` (Ed-personal version; you use `/welgo-capture` instead), `/pre-delegate` (Ed-personal; you use `/welgo-delegate` instead), `/welgo` (Ed-personal dashboard; you use `/welgo-status` instead).

## Rule of thumb

Claude Code is your operator surface. Welgo Brain is your system of record. If you did the work but it is not in Brain, the work did not happen.
