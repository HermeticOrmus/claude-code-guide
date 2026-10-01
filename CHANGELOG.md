# Changelog

All notable changes to this guide are recorded here. The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and versions follow [Semantic Versioning](https://semver.org/).

## [2.1.0] - 2026-09-30

### Added

- A public pantry in [`pantry/`](pantry/README.md): a competitor map, an X mine, a people mine and a pantry queue of Goal atoms, each row with its source, plus the templates for the next run.
- [`pantry/MENU.md`](pantry/MENU.md), generated from the pantry queue, which names one up-next item with a Done-when anyone can check.
- Two issue forms: routing miss (Claude picked the wrong agent, skill or command) and plugin proposal, with the `routing-miss` and `plugin-proposal` labels.
- A "Ways to contribute" section at the top of `CONTRIBUTING.md` (Menu items, routing misses, additions to the starter kit and their layout, translations, sharing what you built) with the local test loop, and a short "Contribute" section in the README.
- Grok Build support: `.grok-plugin/marketplace.json`, generated from the Claude manifest by `scripts/sync-grok-manifest.py`, so `grok plugin marketplace add HermeticOrmus/claude-code-guide` then `grok plugin install starter-kit@claude-code-guide` works, as does `grok plugin install HermeticOrmus/claude-code-guide#starter-kit`. CI checks the generated file, runs `grok plugin validate` on the starter kit, and installs it into a clean Grok home. The README shows the Grok Build install; the auto-format hook is not yet verified in a live Grok session.
- `./setup.sh --grok` installs through the `grok` CLI instead of `claude`, with the same `--only`, `--list`, and `--uninstall` behavior.
- `LEDGER.md`, the kintsugi ledger: every crack the second edition found and sealed, with its evidence, and the crack still open.

## [2.0.0] - 2026-09-30

Second edition. Checked against Claude Code 2.1.285: every command, flag, file path, and setting the guide mentions was confirmed with `claude --help` and the subcommand help, `claude doctor`, `claude plugin validate`, the reference text built into the CLI, or a run in a throwaway `CLAUDE_CONFIG_DIR`. All first-edition content is still in the README; stale parts were corrected where they stand.

### What an existing reader gains

- The starter kit installs as a plugin: `/plugin marketplace add HermeticOrmus/claude-code-guide`, then `/plugin install starter-kit@claude-code-guide`.
- The auto-format hook actually runs. In the first edition its config used a shape Claude Code 2.1 ignores.
- Every MCP example installs. Five of them pointed at npm packages that are deprecated or do not exist.
- New chapters on settings and permission modes, and on plugins and marketplaces.

### What changes for you

- If you copied the first-edition hook block into `~/.claude/settings.json`, replace it with the block in `starter-kit/hooks/settings.json`. `claude doctor` lists the old one under "Invalid settings".
- If you put MCP servers in `~/.claude/mcp.json`, Claude Code never read that file. Add them with `claude mcp add` (see the MCP chapter).
- If you ran `cp -r starter-kit ~/.claude` into an existing `~/.claude`, your files landed in `~/.claude/starter-kit/`, where nothing loads them. Install the plugin, or copy the folders as the Quick Start shows; `~/.claude/starter-kit/` can then be deleted.
- `starter-kit/CLAUDE.md`, `starter-kit/settings.json`, and `starter-kit/mcp.json` moved to `starter-kit/templates/`.
- Installed as a plugin, the commands are namespaced: `/starter-kit:dev:init`, `/starter-kit:dev:test`, `/starter-kit:learning:explain`. Copied by hand, they stay `/dev:init`, `/dev:test`, `/learning:explain`.

### Added

- `.claude-plugin/marketplace.json`: the `claude-code-guide` marketplace, listing the `starter-kit` plugin.
- `starter-kit/.claude-plugin/plugin.json` and `starter-kit/hooks/hooks.json` (PostToolUse on `Edit|Write`, through `${CLAUDE_PLUGIN_ROOT}`).
- `setup.sh`: registers the marketplace and installs through `claude plugin`; supports `--list`, `--only`, `--scope`, `--uninstall`.
- `examples/hooks/protect-secrets.sh` (PreToolUse, returns `permissionDecision: "ask"` for secret-looking paths) and `examples/hooks/session-context.sh` (SessionStart, one-line git summary).
- README: "What's new in the second edition", "Settings and permission modes", "Plugins and marketplaces" (install, details and its token cost, team sharing, build, validate, tag, eval), and a "Feedback" section.
- README chapters on commands, skills, agents, and hooks now cover the frontmatter each reads, where each loads from, naming, context cost, hook input as JSON on stdin, exit codes, and PreToolUse decisions.
- `.github/workflows/validate.yml`: validates the marketplace and plugin, then clean-installs it, on every pull request.
- `.github/ISSUE_TEMPLATE/feedback.yml`: a feedback form.

### Changed

- Agents, commands, and the skill have routing descriptions ("Use this agent when..."). Agents use `model: inherit`.
- `/learning:explain` takes the concept as an argument (`$ARGUMENTS`).
- `auto-format.sh` reads its stdin JSON with jq, formats only files inside the session's working directory, falls back to `ruff format` when `black` is missing, stays silent, and always exits 0.
- Permission rules use the `Bash(git *)` form shown in `claude --help`.
- MCP examples: GitHub, Slack, Supabase, and Todoist use their hosted HTTP servers; git, SQLite, and Obsidian use the published Python packages through `uvx`.

### Fixed

- Hook config: an array of matchers with `type`, `command`, and `timeout` in seconds, replacing a single object per event with `timeout: 5000`.
- MCP location: `claude mcp add` and its scopes, replacing `~/.claude/mcp.json`.
- Removed `thinking: true` from command frontmatter; Claude Code 2.1 does not read it.
- `--max-turns` (not a 2.1 flag) replaced with `--max-budget-usd` in the CLI flags list.
- "think", "think hard", "think harder" no longer set a budget; the guide now covers `--effort`, `/effort`, and `ultrathink`.
- `/cost` is now `/usage` (the old name is an alias).
- Double Escape opens rewind, not message history.
- Auto-memory lives in `~/.claude/projects/<project>/memory/`, not `~/.claude/memory/`.
- `mcp-discord` reads `DISCORD_TOKEN`, not `DISCORD_BOT_TOKEN`.

## First edition

The original, unversioned release of the guide: philosophy, architecture, MCP servers, commands, skills, agents, the global CLAUDE.md, hooks, IDE and terminal tips, Boris Cherny's patterns, and the starter kit.
