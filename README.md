# lingtai — Codex CLI Plugin

Connect [OpenAI Codex CLI](https://github.com/openai/codex) to a [LingTai](https://lingtai.ai) agent network. Read mail from your agents, send instructions, check liveness, and manage the network — all through the shared human mailbox.

> **Using Claude Code?** Use [`Lingtai-AI/claude-code-plugin`](https://github.com/Lingtai-AI/claude-code-plugin) instead — it auto-installs via `claude plugin add`.
>
> **Other coding agents:** see [`Lingtai-AI/lingtai-skill`](https://github.com/Lingtai-AI/lingtai-skill), the canonical protocol skill.

## Install

```bash
codex plugin marketplace add Lingtai-AI/codex-plugin
codex plugin add lingtai@lingtai
```

This installs the `lingtai` skill and the plugin's `SessionStart` hook. Codex asks you to trust a plugin's hooks before running them; trust it from the `/plugins` menu if the session-start mail count does not appear.

To upgrade: `codex plugin marketplace upgrade lingtai && codex plugin add lingtai@lingtai`. To uninstall: `codex plugin remove lingtai@lingtai`.

**Older Codex without `codex plugin`:** clone this repo and run `./install.sh`, which copies the skill to `~/.codex/skills/lingtai/` and the hook to `~/.codex/hooks.json` (merge by hand if that file already exists). `./install.sh --uninstall` removes the skill.

## What you get

- **SessionStart hook** — detects `.lingtai/` projects on session start and reports inbox count plus any mail awaiting pickup
- **`lingtai` skill** — tells Codex how to find and follow the network's own entrance:
  - `.lingtai/human/README.md` — the protocol, written by the LingTai kernel (mail, liveness, signals, restarts)
  - `.lingtai/<agent>/SKILL.md` — each agent's description of itself, written by the agent
  - host rules: `via: codex` attribution, per-host read tracking (`.last_read_codex`), reply polling, verifying "done" claims
  - a minimal, tested fallback recipe for projects whose kernel does not write the entrance yet

Because the protocol is read from the project rather than copied into the plugin, the plugin does not go stale when the kernel changes.

## Usage

Once installed, Codex auto-detects LingTai projects on session start. Ask it to:

- *"Check my inbox"*
- *"Send a message to the orchestrator: research X"*
- *"Are any agents alive?"*
- *"CPR the orchestrator"*
- *"What's the network status?"*

The skill activates on demand — it won't interrupt your coding unless you ask. In projects without `.lingtai/`, the plugin does nothing.

## Deeper reference

Each agent carries the kernel's manuals at `.lingtai/<agent>/.library/intrinsic/capabilities/<skill>/SKILL.md` (for example `lingtai-kernel-anatomy`, `email`, `system-manual`), and the LingTai TUI installs guides at `~/.lingtai-tui/utilities/` (for example `lingtai-tutorial-guide`, `lingtai-portal-guide`, `lingtai-tui-anatomy`). The skill points Codex at these when you ask how LingTai works.

**For plugin developers**: the integration skill at `skills/lingtai/SKILL.md` is **vendored from the canonical [`Lingtai-AI/lingtai-skill`](https://github.com/Lingtai-AI/lingtai-skill) repo**. Do not edit it here — edit it upstream and run `scripts/sync-from-canonical.sh` to pull the latest.

## Requirements

- A LingTai project (`.lingtai/` directory with agents)
- Codex CLI with `codex plugin` (0.160 tested); older versions use `install.sh`
- Python 3 (for message ids and timestamps in the fallback recipe)

## License

Apache-2.0
