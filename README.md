# lingtai — Codex CLI Plugin

Connect [OpenAI Codex CLI](https://github.com/openai/codex) to a [LingTai](https://lingtai.ai) agent network. Read mail from your agents, send instructions, check liveness, and manage the network — all through the shared human mailbox.

> **Using Claude Code?** Use [`Lingtai-AI/claude-code-plugin`](https://github.com/Lingtai-AI/claude-code-plugin) instead — it auto-installs via `claude plugin add`.
>
> **Other coding agents:** see [`Lingtai-AI/lingtai-skill`](https://github.com/Lingtai-AI/lingtai-skill), the canonical protocol skill.

## Install

```bash
git clone https://github.com/Lingtai-AI/codex-plugin.git
cd codex-plugin
./install.sh
```

This places:

- `skills/lingtai/` → `~/.codex/skills/lingtai/`
- A `SessionStart` hook → `~/.codex/hooks.json` (created if absent; merge required if you already have one)

Hooks are enabled by default in Codex CLI 0.129.0+ — no feature flag needed.

To uninstall the skill:

```bash
./install.sh --uninstall
```

## What you get

- **SessionStart hook** — detects `.lingtai/` projects on session start and reports inbox count plus any mail awaiting pickup
- **`lingtai` skill** — full reference for the filesystem mailbox protocol:
  - Send mail via the human's outbox (pseudo-agent model — agents poll and claim)
  - Read incoming mail with threading via `in_reply_to`
  - Agent discovery and orchestrator identification
  - Liveness checks (heartbeat)
  - Lifecycle management — sleep, suspend, CPR, refresh, clear
  - Signal files — prompt injection, soul inquiry
  - Delivery + reply monitoring
  - Read tracking across sessions (per-host `.last_read_codex` state file)
  - **Remote networks via SSH** — read/send mail, discover agents, check liveness, manage lifecycle, monitor remote `.lingtai/` directories

## Usage

Once installed, Codex auto-detects LingTai projects on session start. Ask it to:

- *"Check my inbox"*
- *"Send a message to the orchestrator: research X"*
- *"Are any agents alive?"*
- *"CPR the orchestrator"*
- *"What's the network status?"*
- *"Connect to my remote at zesen@lab:/home/zesen/project/.lingtai"*
- *"Check inbox on the lab server"*
- *"Send 'hello' to the orchestrator on my remote"*

The skill activates on demand — it won't interrupt your coding unless you ask. In projects without `.lingtai/`, the plugin does nothing.

## Reference skills

The `lingtai` skill in this plugin is the **integration protocol** — how Codex talks to the mailbox. For deeper reference about the agent runtime itself, Codex should load the skills that ship with the LingTai TUI. When the TUI (`lingtai-tui`) is installed, these live at `~/.lingtai-tui/bundled-skills/`:

| Skill | Location | What it covers |
|-------|----------|---------------|
| **lingtai-anatomy** | `~/.lingtai-tui/bundled-skills/lingtai-anatomy/SKILL.md` | Memory system, filesystem layout, runtime anatomy (turn loop, state machine, signals, molt, mail atomicity) |
| **lingtai-tutorial-guide** | `~/.lingtai-tui/bundled-skills/lingtai-tutorial-guide/SKILL.md` | How LingTai works — concepts, philosophy, lessons |
| **lingtai-portal-guide** | `~/.lingtai-tui/bundled-skills/lingtai-portal-guide/SKILL.md` | Portal API endpoints, topology recording, replay |
| **lingtai-recipe** | `~/.lingtai-tui/bundled-skills/lingtai-recipe/SKILL.md` | Behavioral recipes, network cloning, export/import |
| **lingtai-mcp** | `~/.lingtai-tui/bundled-skills/lingtai-mcp/SKILL.md` | MCP server configuration for agents |
| **lingtai-changelog** | `~/.lingtai-tui/bundled-skills/lingtai-changelog/SKILL.md` | Breaking changes, renames, migrations |

The plugin doesn't bundle these — they're maintained in the [main LingTai repo](https://github.com/Lingtai-AI/lingtai) and populated to `~/.lingtai-tui/bundled-skills/` on TUI install.

**For plugin developers**: the integration skill at `skills/lingtai/SKILL.md` is **vendored from the canonical [`Lingtai-AI/lingtai-skill`](https://github.com/Lingtai-AI/lingtai-skill) repo**. Do not edit it here — edit it upstream and run `scripts/sync-from-canonical.sh` to pull the latest.

## Requirements

- A running LingTai project (`.lingtai/` directory with agents)
- Codex CLI 0.129.0+ (hooks enabled by default)
- Python 3 (for UUID generation and liveness checks)
- SSH keys configured for remote networks (`ssh-copy-id user@host`)
- `lingtai-tui` installed (populates `~/.lingtai-tui/bundled-skills/` with the reference skills above)

## License

MIT
