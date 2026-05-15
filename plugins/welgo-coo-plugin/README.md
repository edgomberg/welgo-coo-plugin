# welgo-coo-plugin

Welgo COO plugin for Jessica Sese. Zero-token install via Tailscale identity.

## Prereqs

1. Tailscale installed and signed in with your Welgo email.
2. Ed has shared the mac-mini-brain node with you (you see it in Tailscale machines list).

## Install

```
claude plugin marketplace add edgomberg/welgo-coo-plugin
claude plugin install welgo-coo-plugin@welgo-coo
```

Restart Claude Code. Plugin auto-downloads the Welgo Brain wrapper on first session.

## Verify

Ask Claude: "what's in my Welgo task summary?"

If it returns task counts, you are connected.

## How it works

- Plugin ships an MCP config pointing at the Mac Mini via Tailscale.
- Wrapper script downloads automatically on plugin install.
- Authentication is via Tailscale identity — your tailnet email auto-maps to your role on the Welgo Brain server.
- No token paste required. No secrets in this repo.

## Escalation

Slack `#opco`, tag Ed.
