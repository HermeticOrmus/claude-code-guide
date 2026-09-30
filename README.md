<p align="center">
  <img src="https://ormus.solutions/mascot/pixellab_liquid_to_compass.gif" alt="Claude Code Guide" width="128" style="image-rendering: pixelated;" />
</p>

<h1 align="center">Claude Code Guide</h1>

<p align="center">
  <em>Complete guide to Claude Code as a system-wide assistant</em>
</p>

<p align="center">
  <a href="https://github.com/HermeticOrmus/claude-code-guide/stargazers"><img src="https://img.shields.io/github/stars/HermeticOrmus/claude-code-guide?style=flat-square&color=aa8142" alt="Stars" /></a>
  <a href="https://github.com/HermeticOrmus/claude-code-guide/blob/master/LICENSE"><img src="https://img.shields.io/github/license/HermeticOrmus/claude-code-guide?style=flat-square&color=aa8142" alt="License" /></a>
  <a href="https://github.com/HermeticOrmus/claude-code-guide/commits"><img src="https://img.shields.io/github/last-commit/HermeticOrmus/claude-code-guide?style=flat-square&color=aa8142" alt="Last Commit" /></a>
  <img src="https://img.shields.io/badge/Claude Code-aa8142?style=flat-square&logo=anthropic&logoColor=white" alt="Claude Code" />
</p>

---

> **DON'T PANIC.** Transform Claude Code from "project-based coding tool" into "computer-wide intelligent assistant."

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

*Compiled from insights by [Boris Cherny](https://howborisusesclaudecode.com/) (creator of Claude Code), [Andrej Karpathy](https://karpathy.bearblog.dev/year-in-review-2025/), [Anthropic Best Practices](https://www.anthropic.com/engineering/claude-code-best-practices), and [The Hitch-Hiker's Guide to Vibe Engineering](https://hermeticormus.github.io/hitchhikers-guide-to-vibe-engineering/).*

---

## What's new in the second edition

The first edition was written for an earlier Claude Code. This edition is checked against Claude Code **2.1.285**: every Claude Code command, flag, file path, and setting in it was confirmed with `claude --help` and the subcommand help, `claude doctor`, `claude plugin validate`, the reference text built into the CLI, or a run in a throwaway `CLAUDE_CONFIG_DIR`. Everything from the first edition is still here. What changed:

**New chapters**

- [Settings and permission modes](#settings-and-permission-modes): the three settings files, permission rules, the six permission modes, and checking your files with `claude doctor`.
- [Plugins and marketplaces](#plugins-and-marketplaces): install and manage plugins, read a plugin's token cost before you keep it, share plugins with a team, and build, validate, tag, and evaluate your own.

**Rewritten chapters**

- [MCP Servers](#mcp-servers): `claude mcp add` and its three scopes, hosted HTTP servers with OAuth, and example configs that install today.
- [Commands](#commands), [Skills](#skills), [Agents](#agents): the frontmatter each one reads, where each loads from, how names are formed, and what each costs in context.
- [Hooks](#hooks): the current config shape, input as JSON on stdin, exit codes, `permissionDecision` allow/deny/ask, and `hooks/hooks.json` in plugins with `${CLAUDE_PLUGIN_ROOT}`.

**The starter kit is a plugin.** Install it with two commands instead of copying folders by hand. [Quick Start](#quick-start) has both paths.

**Corrections.** These first-edition instructions are wrong or out of date for Claude Code 2.1:

| First edition | Second edition | How it was checked |
|---|---|---|
| Hook config `"PostToolUse": { "command": ..., "timeout": 5000 }` | An array of matchers, each with a `hooks` array; `timeout` is in seconds | `claude doctor` reports the old block invalid and ignored |
| MCP servers in `~/.claude/mcp.json` | `claude mcp add`: user scope is stored in `~/.claude.json`, project scope in `.mcp.json` | `claude mcp list` does not read `~/.claude/mcp.json` |
| `cp -r starter-kit ~/.claude` | `/plugin install starter-kit@claude-code-guide`, or copy the folders one by one | With an existing `~/.claude`, `cp -r` creates `~/.claude/starter-kit/`, which Claude Code never reads |
| `thinking: true` in command frontmatter | Removed | Not among the frontmatter keys the CLI reads |
| `claude --max-turns 3` | `claude -p --max-budget-usd 1 "query"` | `--max-turns` is not in `claude --help` |
| "think", "think hard", "think harder" budgets | `--effort` and `/effort`; `ultrathink` still asks for deeper reasoning on one turn | Only `ultrathink` appears in the CLI |
| `/cost` | `/usage` (`/cost` still works as an alias) | The CLI defines `cost` as an alias of `usage` |
| `Escape` twice jumps to previous messages | `Esc Esc` opens rewind, which restores code, conversation, or both | CLI tip text |
| `~/.claude/memory/` for persistent context | Auto-memory lives in `~/.claude/projects/<project>/memory/` | `memory_paths` in the session init event |
| Permission rule `Bash(git:*)` | `Bash(git *)` | The form `claude --help` uses |
| `@modelcontextprotocol/server-github`, `@anthropic/slack-mcp`, `server-git`, `server-sqlite`, `server-obsidian` | Hosted HTTP servers and the published Python packages | npm and PyPI lookups: deprecated or not found |

The full list is in [CHANGELOG.md](CHANGELOG.md).

---

## Quick Start

### Install from Claude Code

```
/plugin marketplace add HermeticOrmus/claude-code-guide
/plugin install starter-kit@claude-code-guide
```

Then run `/reload-plugins` (or restart Claude Code). You get:

- Two agents: `starter-kit:code-reviewer` and `starter-kit:learning-assistant`
- Three commands: `/starter-kit:dev:init`, `/starter-kit:dev:test`, `/starter-kit:learning:explain <concept>`
- A skill template: `/starter-kit:example-skill`
- A PostToolUse hook that runs your formatter (black or ruff, prettier, gofmt, rustfmt) on files Claude edits inside the project, when that formatter is installed

The hook ships inside the `starter-kit` plugin; there is no separate hooks plugin to add. To get the agents and commands without the hook, use the manual copy below and skip the hook step.

### From a terminal

```bash
claude plugin marketplace add HermeticOrmus/claude-code-guide
claude plugin install starter-kit@claude-code-guide
claude plugin details starter-kit@claude-code-guide   # what it adds, and its token cost
```

### With setup.sh

```bash
git clone https://github.com/HermeticOrmus/claude-code-guide
cd claude-code-guide
./setup.sh --list        # the plugins in this marketplace
./setup.sh               # register the marketplace and install them
./setup.sh --uninstall   # remove them again
```

`setup.sh` runs the same `claude plugin` commands shown above. It also takes `--only <plugin>` and `--scope user|project|local`.

### Install in Grok Build

Grok Build loads the same plugin folder. Add the marketplace and install the starter kit from a terminal:

```bash
grok plugin marketplace add HermeticOrmus/claude-code-guide
grok plugin install starter-kit@claude-code-guide
```

Or install it straight from its folder, with no marketplace:

```bash
grok plugin install HermeticOrmus/claude-code-guide#starter-kit
```

From a clone, `./setup.sh --grok` installs it through the `grok` CLI; `--only`, `--list`, and `--uninstall` work the same way. The starter kit's auto-format hook uses a hook format Grok Build supports, but it has not been verified in a live Grok session yet.

### Copy the personal files

A plugin cannot ship your `CLAUDE.md` or your settings, so these stay manual. Run them from a clone of this repository (see [With setup.sh](#with-setupsh)):

```bash
# Your global instructions, loaded every session (-n keeps a file you already have)
cp -n starter-kit/templates/CLAUDE.md ~/.claude/CLAUDE.md
nano ~/.claude/CLAUDE.md

# Merge the "permissions" block of starter-kit/templates/settings.json
# into ~/.claude/settings.json by hand

# The memory MCP server, for every project
claude mcp add --scope user memory -- npx -y @modelcontextprotocol/server-memory

# Start Claude Code
claude
```

### Manual copy instead of the plugin

The first edition said `cp -r starter-kit ~/.claude`. When `~/.claude` already exists (it does after your first session), that creates `~/.claude/starter-kit/`, where Claude Code does not look. Copy the folders instead:

```bash
mkdir -p ~/.claude/hooks
cp -rn starter-kit/agents starter-kit/commands starter-kit/skills ~/.claude/
cp -n starter-kit/hooks/auto-format.sh ~/.claude/hooks/
# then add the block in starter-kit/hooks/settings.json to ~/.claude/settings.json
```

Copied this way, the commands are `/dev:init`, `/dev:test`, and `/learning:explain`, and the agents keep their plain names.

---

## Table of Contents

- [What's new in the second edition](#whats-new-in-the-second-edition)
- [Quick Start](#quick-start)
- [Philosophy: Vibe Engineering](#vibe-engineering-philosophy)
- [Architecture Overview](#architecture-overview)
- [MCP Servers (External Tools)](#mcp-servers)
- [Commands (Slash Commands)](#commands)
- [Skills (Procedural Knowledge)](#skills)
- [Agents (Custom Personalities)](#agents)
- [The Global CLAUDE.md](#the-global-claudemd)
- [Hooks (Automation)](#hooks)
- [Settings and permission modes](#settings-and-permission-modes) (new)
- [Plugins and marketplaces](#plugins-and-marketplaces) (new)
- [IDE & Terminal Hacks](#ide--terminal-hacks)
- [Boris Cherny's Patterns](#boris-chernys-patterns)
- [Setup Checklist](#setup-checklist)
- [Key Principles](#key-principles)
- [Feedback](#feedback)
- [Contribute](#contribute)
- [Contributing](#contributing)

---

## Vibe Engineering Philosophy

### DON'T PANIC

> "Vibe Engineering is the second-best way to write software in the known universe. The best way, of course, is to have someone else do it entirely while you sip Pan Galactic Gargle Blasters."

**VIBE ENGINEERING** _(n.)_: The deliberate practice of building software through AI collaboration—describing intent, reviewing output, and iterating toward working systems. Distinguished from "vibe coding" by emphasizing *engineering*: understanding what you build, owning what you ship.

### The Risk Classification System

| Level | Label | Meaning |
|-------|-------|---------|
| 🟢 | **Mostly Harmless** | If it breaks, nothing bad happens |
| 🟡 | **Caution Advised** | Annoying but recoverable |
| 🟠 | **Danger** | Real problems if this fails |
| 🔴 | **Here Be Dragons** | Catastrophic consequences |

### The Karpathy Spectrum

```
"Fully give in to the vibes" ←————————————→ "Read every line"
            ↑                                        ↑
        Prototypes                              Production
```

Match your scrutiny to the risk level.

### The Four Honest Questions

Before shipping to production:

| Question | What It Really Asks |
|----------|---------------------|
| **Can you debug it?** | If this breaks at 3am, can you fix it? |
| **Can you explain it?** | Could you walk someone through it? |
| **Can you extend it?** | When requirements change, can you modify it? |
| **Can you own it?** | Will you take responsibility in production? |

If any answer is "no" — you're not ready to ship.

### The Street Rules

1. **Context is currency** — Specific prompts outperform vague requests
2. **Verify before trust** — The AI cannot test itself
3. **Ship before perfect** — Done beats ideal

### The Towel Principle

> "A towel is about the most massively useful thing an interstellar hitchhiker can have."

In Vibe Engineering, **version control is your towel.**

```bash
# Before any AI session
git add -A && git commit -m "checkpoint: before AI session"
```

---

## Architecture Overview

```
~/.claude/                      # Global Claude configuration
├── CLAUDE.md                   # Master instructions (loaded every session)
├── settings.json               # Permissions, hooks, enabled plugins
├── commands/                   # Slash commands
│   ├── dev/                    # /dev:init, /dev:test
│   └── learning/               # /learning:explain
├── skills/                     # Detailed procedures (<name>/SKILL.md)
├── agents/                     # Custom personalities (subagents)
├── hooks/                      # Scripts your hooks call (a convention)
├── plugins/                    # Installed plugins (managed by claude plugin)
├── keybindings.json            # Custom keyboard shortcuts (/keybindings)
└── projects/<project>/memory/  # Auto-memory, one folder per project

~/.claude.json                  # MCP servers (user scope) and app state.
                                # There is no ~/.claude/mcp.json in 2.1.
```

**Key Insight**: Everything in `~/.claude/` applies globally. Project-specific overrides go in `.claude/` within the project.

```
your-project/
├── CLAUDE.md                   # Project instructions (commit it)
├── CLAUDE.local.md             # Your own notes for this project (keep out of git)
├── .mcp.json                   # Project MCP servers (commit it)
└── .claude/
    ├── settings.json           # Team settings (commit it)
    ├── settings.local.json     # Your overrides (keep out of git)
    ├── commands/
    ├── skills/
    └── agents/
```

`CLAUDE_CONFIG_DIR` moves the whole `~/.claude` tree somewhere else. Pointing it at an empty folder (`export CLAUDE_CONFIG_DIR=$(mktemp -d)`) gives you a clean config to test plugins or settings in without touching your own.

### The Counter-Intuitive Truth

Boris Cherny's setup is "surprisingly vanilla." His advice:

> "Claude Code works great out of the box. Don't over-customize initially."

---

## MCP Servers

MCPs (Model Context Protocol) connect Claude to external systems. This transforms Claude from "chat assistant" to "system-wide agent."

### Categories

| Category | Examples | What It Enables |
|----------|----------|-----------------|
| **Communication** | WhatsApp, Slack, Discord, Gmail | Send/receive messages |
| **Data** | Supabase, SQLite, PostgreSQL | Database queries |
| **Productivity** | Calendar, Todoist, Obsidian | Scheduling, tasks, notes |
| **Development** | GitHub, Git | Repo management, PRs |
| **Automation** | n8n, Puppeteer | Workflows, browser control |
| **Memory** | server-memory | Persistent context |

### Add servers with `claude mcp add`

In 2.1 you register servers with the CLI instead of editing a file in `~/.claude`:

```bash
# A local (stdio) server, available in every project
claude mcp add --scope user memory -- npx -y @modelcontextprotocol/server-memory

# A local server with an argument, for this project only (local scope is the default)
claude mcp add filesystem -- npx -y @modelcontextprotocol/server-filesystem /home/user

# Environment variables go before the --
claude mcp add my-server -e API_KEY=xxx -- npx my-mcp-server

# A hosted (HTTP) server that takes a token in a header
claude mcp add --transport http github https://api.githubcopilot.com/mcp/ \
  --header "Authorization: Bearer ghp_..."

# A hosted server that signs you in with OAuth in the browser
claude mcp add --transport http supabase "https://mcp.supabase.com/mcp?project_ref=your-project-ref"
claude mcp login supabase

claude mcp list            # every server, with a health check
claude mcp get memory      # one server's details
claude mcp remove memory
```

The `--` separates Claude Code's options from the server's own command and flags. Inside a session, `/mcp` manages the same servers.

### Scopes

| Scope | Flag | Stored in | Who gets it |
|---|---|---|---|
| local (default) | `--scope local` | `~/.claude.json`, under this project | You, in this project |
| project | `--scope project` | `.mcp.json` in the project root | Everyone who clones it; each person approves it once |
| user | `--scope user` | `~/.claude.json` | You, in every project |

A project server shows as `Pending approval` in `claude mcp list` until you start `claude` in that project and approve it. Keep tokens out of `.mcp.json`, since it is meant to be committed; add servers that need secrets with `--scope local` or `--scope user`.

### Essential MCPs to Start

`.mcp.json`, `claude --mcp-config <file>`, and the files in [examples/mcp-configs/](examples/mcp-configs/) all use this shape. The first edition's GitHub entry used `@modelcontextprotocol/server-github`, which npm now lists as deprecated; GitHub's hosted server replaces it:

```json
{
  "mcpServers": {
    "memory": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-memory"]
    },
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/home/user"]
    },
    "github": {
      "type": "http",
      "url": "https://api.githubcopilot.com/mcp/",
      "headers": {
        "Authorization": "Bearer ghp_..."
      }
    }
  }
}
```

To try a file for one session without saving anything:

```bash
claude --mcp-config examples/mcp-configs/development.json
claude --mcp-config examples/mcp-configs/development.json --strict-mcp-config   # only these servers
```

`claude mcp add-json <name> '<json>'` takes a single server's object (the part inside `"memory": {...}`), not the whole file.

**Pattern:** If you use it daily, give Claude access to it.

See [examples/mcp-configs/](examples/mcp-configs/) for more configurations. Every package in them was checked against npm and PyPI for this edition; the four hosted servers (GitHub, Slack, Supabase, Todoist) use `"type": "http"`.

---

## Commands

Commands are reusable prompts triggered by `/command-name`.

### Structure

```markdown
---
description: Short description shown in command list
argument-hint: "<what to pass>"  # Optional: shown after the command name
---

# Command Name

Instructions for Claude when this command is invoked.
The text typed after the command replaces $ARGUMENTS.
```

The first edition showed `thinking: true` here. Claude Code 2.1 does not read that key. For a hard task, raise the session's effort with `/effort` or put `ultrathink` in your prompt (see [Extended Thinking](#extended-thinking)).

Other keys a command can set: `allowed-tools` (the permissions it needs, as narrow patterns like `Bash(gh *)`) and `model`.

### Organization

```
commands/
├── dev/init.md           → /dev:init
├── dev/test.md           → /dev:test
├── learning/explain.md   → /learning:explain
└── organize.md           → /organize
```

A subfolder becomes a prefix. Commands from a plugin also carry the plugin's name: the starter kit's `dev/init.md` is `/starter-kit:dev:init`.

Commands load from `~/.claude/commands/` (every project), `.claude/commands/` (this project), and a plugin's `commands/`.

### Commands or skills?

You type a command. A skill can be typed too, and Claude can also choose it on its own from its description. The session's list of skills Claude may call contains skills, not commands. Write a command for a prompt you trigger yourself; write a skill when Claude should reach for the procedure whenever it fits.

See [starter-kit/commands/](starter-kit/commands/) for templates.

---

## Skills

Skills are more detailed than commands — they contain **step-by-step procedures**.

Think of commands as "triggers" and skills as "detailed playbooks."

### Where skills live

| Location | Scope | Invoked as |
|---|---|---|
| `~/.claude/skills/<name>/SKILL.md` | All your projects | `/<name>` |
| `.claude/skills/<name>/SKILL.md` | This project | `/<name>` |
| `<plugin>/skills/<name>/SKILL.md` | Wherever the plugin is enabled | `/<plugin>:<name>` |

A skill is a folder, not a single file: `SKILL.md` plus any scripts, templates, or reference files it needs. Inside `SKILL.md`, `${CLAUDE_SKILL_DIR}` expands to that folder, so the skill can point at a script it ships.

### Structure

```markdown
---
name: skill-name
description: What this skill does. Use when <the situations that should trigger it>.
---

# Skill Name

## When to Use
- Condition 1
- Condition 2

## Procedure

### Step 1: [Name]
Detailed instructions...

### Step 2: [Name]
Detailed instructions...

## Templates
Example outputs...
```

### Frontmatter

| Key | What it does |
|---|---|
| `name` | The skill's name and its slash command |
| `description` | Always in context. Claude reads it to decide when to use the skill, so say what it does and when to use it |
| `when_to_use` | More trigger guidance: phrases and example requests |
| `argument-hint`, `arguments` | Only for skills that take input. The body uses `$ARGUMENTS`, or `$name` for a named argument |
| `allowed-tools` | The permissions it needs, as narrow patterns like `Bash(gh *)` rather than `Bash` |
| `disable-model-invocation: true` | Only you can run it. Use it for skills with side effects, like a deploy |
| `context: fork` | Runs in a separate context. For self-contained skills that need no input midway |

### What a skill costs

Only the description is in context every session; the body loads when the skill runs. `claude plugin details` shows both numbers. For the starter kit's `example-skill` it reports about 80 tokens always-on and about 390 on invoke. Many skills with long descriptions add up, so keep descriptions to what routing needs.

See [starter-kit/skills/](starter-kit/skills/) for templates.

---

## Agents

Agents define specialized personas Claude can adopt.

In Claude Code these are **subagents**: Claude hands a task to one, the agent works with its own instructions and tools, and it returns its result to the main conversation.

### Structure

```markdown
---
name: agent-name
description: Use this agent when <situations>. <What it does>.
model: inherit              # or sonnet, opus, haiku, or a full model ID
tools: [Read, Grep, Glob]   # optional: leave out to allow every tool
---

You are a [role] expert with deep knowledge of [domain].

## Expertise Areas
- Area 1
- Area 2

## Approach
- How to communicate
- Safety guidelines
```

### Frontmatter

| Key | Notes |
|---|---|
| `name` | Required. Two files in one folder with the same `name` collide, and one is dropped |
| `description` | Required: an agent without one never loads. Claude uses it to decide when to delegate, so start with "Use this agent when..." |
| `model` | `inherit` uses the session's model. Or an alias (`sonnet`, `opus`, `haiku`) or a full model ID |
| `tools`, `disallowedTools` | An allow list and a deny list of tools |
| `effort` | Reasoning effort for the agent |
| `maxTurns` | A positive integer cap on the agent's turns |
| `permissionMode` | A [permission mode](#permission-modes) for the agent |
| `skills` | Skills to load for the agent |
| `mcpServers`, `hooks` | MCP servers and hooks for the agent |

Plugin agents ignore `permissionMode`, `hooks`, and `mcpServers`: the CLI logs a warning and points you to `.claude/agents/` for that level of control.

### Where agents live and how to use them

- `~/.claude/agents/` (every project), `.claude/agents/` (this project), or a plugin's `agents/` (named `<plugin>:<agent>`, like `starter-kit:code-reviewer`).
- Claude delegates on its own when a task matches the description. You can also ask: "Use the code-reviewer agent on my last commit."
- `claude --agent code-reviewer` runs a whole session as that agent (`--agent starter-kit:code-reviewer` for the plugin's copy).
- `claude --agents '{"reviewer": {"description": "Reviews code", "prompt": "You are a code reviewer"}}'` defines an agent for one session only.
- To create or change one, ask Claude to write the file, or edit it yourself. In 2.1.285 `/agents` no longer opens a menu; it points you to these two options.

### Example Agents

| Agent | Purpose |
|-------|---------|
| `sysadmin` | Linux system administration |
| `code-reviewer` | Code review focus |
| `learning-assistant` | Teaching mode |

See [starter-kit/agents/](starter-kit/agents/) for templates.

---

## The Global CLAUDE.md

This is loaded automatically every session.

### Essential Sections

```markdown
# Personal Assistant Configuration

## About Me
- Name, timezone, context

## Preferences
- Communication style
- Safety guidelines

## Environment
- Machine details
- Key directories

## Verification
- Commands to run after code changes
```

The starter kit's version is [starter-kit/templates/CLAUDE.md](starter-kit/templates/CLAUDE.md).

### Where instructions load from

| File | Who it is for |
|---|---|
| `~/.claude/CLAUDE.md` | You, in every project |
| `CLAUDE.md` or `.claude/CLAUDE.md` in the project | Everyone on the project (commit it) |
| `CLAUDE.local.md` in the project | You, in this project (keep it out of git) |

Claude Code also reads `AGENTS.md` files. A line such as `@~/.claude/my-notes.md` inside a CLAUDE.md imports another file. In a session, `/init` drafts a CLAUDE.md for the current project and `/memory` opens your CLAUDE.md files for editing.

### The Living Document

> "Anytime we see Claude do something incorrectly we add it to CLAUDE.md, so Claude knows not to do it next time." — Boris Cherny

---

## Hooks

Hooks trigger actions on specific events.

A hook is a command Claude Code runs itself at a set point in the session. It does not depend on the model remembering an instruction, so use a hook for anything that must happen every time.

### Available Events

| Event | When | Use Cases |
|-------|------|-----------|
| `SessionStart` | New session | Load context (stdout goes to Claude) |
| `SessionEnd` | Session ends | Save transcript |
| `UserPromptSubmit` | You send a prompt | Add context, block a prompt |
| `PreToolUse` | Before a tool runs | Allow, deny, or ask; block risky calls |
| `PermissionRequest` | A permission prompt is about to show | Answer it automatically |
| `PostToolUse` | After tool runs | Auto-format code |
| `PostToolUseFailure` | After a tool fails | Log or explain the failure |
| `Notification` | Claude Code sends a notification | Desktop or phone alerts |
| `Stop` | Claude finishes its response | Checks before it hands back |
| `SubagentStart` | Agent starts | Give the agent extra context |
| `SubagentStop` | Agent completes | Verify results |
| `PreCompact`, `PostCompact` | Around compaction | Keep notes across compaction |

For tool events the `matcher` is a tool name, or several joined with `|` (`Edit|Write`). PreCompact and PostCompact match `manual` or `auto`. `claude plugin validate` flags an event name it does not know, and `/hooks` in a session shows the hooks you have configured.

### Configuration

The first edition used one object per event. Claude Code 2.1 ignores that shape: `claude doctor` reports `Hook event "PostToolUse" must be an array of matchers; received object. This entry was ignored.` The current shape is an array of matchers, each with its own `hooks` array. `timeout` is in seconds:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "bash ~/.claude/hooks/auto-format.sh",
            "timeout": 30
          }
        ]
      }
    ]
  }
}
```

This block goes in any settings file: `~/.claude/settings.json`, `.claude/settings.json`, or `.claude/settings.local.json`. Run `claude doctor` after editing; it lists broken hook entries under "Invalid settings".

### Input arrives as JSON on stdin

A hook reads its input from stdin, not from arguments. This is what a SessionStart hook received in a Claude Code 2.1.285 session (IDs and paths shortened):

```json
{
  "session_id": "55ebd8fb-...",
  "transcript_path": "~/.claude/projects/<project>/55ebd8fb-....jsonl",
  "cwd": "/path/to/project",
  "hook_event_name": "SessionStart",
  "source": "startup"
}
```

Every event carries `session_id`, `transcript_path`, `cwd`, and `hook_event_name`. Tool events add `tool_name` and `tool_input`: `tool_input.file_path` for Read, Edit, and Write, `tool_input.command` for Bash. PostToolUse also gets `tool_response`. Read the fields with jq:

```bash
INPUT=$(cat)
FILE_PATH=$(printf '%s' "$INPUT" | jq -r '.tool_input.file_path // empty')
```

### Exit codes

| Exit code | PreToolUse | PostToolUse | SessionStart | UserPromptSubmit | Stop |
|---|---|---|---|---|---|
| `0` | Tool runs | Output visible in transcript mode (`Ctrl+O`) | stdout is added to Claude's context | stdout is added to Claude's context | Nothing shown |
| `2` | Tool call blocked; stderr goes to Claude | stderr goes to Claude | stderr shown to you | Prompt blocked and erased; stderr shown to you | stderr goes to Claude, which keeps working |
| Other | stderr shown to you; the tool still runs | stderr shown to you | stderr shown to you | stderr shown to you | stderr shown to you |

### PreToolUse decisions: allow, deny, ask

Instead of an exit code, a PreToolUse hook can print JSON with `hookSpecificOutput.permissionDecision` set to `allow`, `deny`, or `ask`, and a `permissionDecisionReason`. [examples/hooks/protect-secrets.sh](examples/hooks/protect-secrets.sh) asks before Claude reads or writes a file that usually holds secrets:

```bash
FILE_PATH=$(jq -r '.tool_input.file_path // empty' 2>/dev/null)
[ -n "$FILE_PATH" ] || exit 0

case "$FILE_PATH" in
    */.env|*/.env.*|*.pem|*.key|*credentials*|*secrets*)
        jq -n --arg f "$FILE_PATH" '{
            hookSpecificOutput: {
                hookEventName: "PreToolUse",
                permissionDecision: "ask",
                permissionDecisionReason: ("This file may hold secrets: " + $f)
            }
        }'
        ;;
esac
exit 0
```

Register it for the file tools:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Read|Edit|Write",
        "hooks": [
          { "type": "command", "command": "bash ~/.claude/hooks/protect-secrets.sh", "timeout": 10 }
        ]
      }
    ]
  }
}
```

The older top-level `decision` field is deprecated for PreToolUse; use `hookSpecificOutput.permissionDecision`. Other output fields: `systemMessage` shows a message to you, `hookSpecificOutput.additionalContext` adds text to Claude's context, and `"continue": false` with a `stopReason` stops Claude.

### Test a hook without Claude

Because the input is JSON on stdin, you can pipe a sample in:

```bash
echo '{"tool_name":"Read","tool_input":{"file_path":"/app/.env"}}' | bash examples/hooks/protect-secrets.sh
echo '{"hook_event_name":"SessionStart","source":"startup","cwd":"'"$PWD"'"}' | bash examples/hooks/session-context.sh
```

The first prints the `ask` decision; the second prints a one-line git summary, which is what Claude sees at the start of a session. `claude --debug hooks` turns on debug logging for hooks in a live session.

### Hook types

`"type": "command"` runs a shell command. `"type": "prompt"` asks a model to evaluate a condition, and `"type": "agent"` runs an agent with tools to verify something; those two work only on PreToolUse, PostToolUse, and PermissionRequest.

### Hooks in plugins

A plugin ships its hooks in `hooks/hooks.json`, with the same shape as the settings block. `${CLAUDE_PLUGIN_ROOT}` expands to the plugin's installed folder, so the command can find scripts the plugin carries. The starter kit's [hooks/hooks.json](starter-kit/hooks/hooks.json):

```json
{
  "description": "Format a file with its language's formatter after Claude edits or writes it",
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "bash \"${CLAUDE_PLUGIN_ROOT}/hooks/auto-format.sh\"",
            "timeout": 30
          }
        ]
      }
    ]
  }
}
```

In a 2.1.285 test, a plugin's hook saw `CLAUDE_PLUGIN_ROOT` both expanded in its command line and set in its environment. Plugin hooks run whenever the plugin is enabled.

See [starter-kit/hooks/](starter-kit/hooks/) and [examples/hooks/](examples/hooks/) for examples.

---

## Settings and permission modes

### Settings files

Settings are JSON. Claude Code reads three files, and later ones override earlier ones:

| File | Scope | In git |
|---|---|---|
| `~/.claude/settings.json` | You, every project | Not applicable |
| `.claude/settings.json` | Everyone on the project | Commit it |
| `.claude/settings.local.json` | You, this project | Keep it out of git |

Settings an organization's admin manages apply on top of these. For one run, `--settings <file-or-json>` adds settings, and `--setting-sources user,project` limits which files load. In a session, `/config` opens settings.

`claude doctor` checks your user settings and the settings files in the current directory, and lists anything invalid:

```
Invalid settings
- .claude/settings.json › hooks.PostToolUse: Hook event "PostToolUse" must be an array of matchers; received object. This entry was ignored.
```

### Permission rules

```json
{
  "permissions": {
    "allow": ["Bash(git *)", "Bash(npm run test *)", "Read", "Edit(src/**)"],
    "ask": ["Bash(git push *)"],
    "deny": ["Bash(rm -rf *)", "Bash(sudo *)", "Read(./.env)"],
    "defaultMode": "acceptEdits"
  }
}
```

- `Read`: a tool name alone covers every use of that tool.
- `Bash(npm run test)`: exactly that command.
- `Bash(git *)`: `git` followed by anything. The first edition's `Bash(git:*)` spelling still passes `claude doctor`, but the CLI's help and examples use the space form.
- `Edit(src/**)`, `Read(./.env)`: file paths. `Edit(...)` rules apply to every tool that writes files (Edit, Write, NotebookEdit).

`/permissions` in a session lists and edits the rules. A malformed rule is skipped, and `claude doctor` says so: `Invalid permission rule "Bash(" was skipped: Malformed Tool(content) rule.`

### Permission modes

| Mode | What it does |
|---|---|
| `default` (the CLI flag calls it `manual`) | Prompts before risky operations |
| `acceptEdits` | Accepts file edits without asking |
| `plan` | Analysis only: Claude plans and does not make changes |
| `auto` | A model classifier approves or denies each permission prompt |
| `dontAsk` | Never prompts; anything not already allowed is denied |
| `bypassPermissions` | Skips every check. Needs `--dangerously-skip-permissions` or `--allow-dangerously-skip-permissions` |

Setting the mode:

- For one session: `claude --permission-mode plan`
- During a session: `Shift+Tab` cycles through the modes
- As your default: `"defaultMode"` under `permissions` in a settings file, or `/config`

For `auto` mode, `claude auto-mode defaults` prints the built-in rules, `claude auto-mode config` prints your effective configuration, and `claude auto-mode critique` reviews rules you wrote.

### Other settings you will meet

```json
{
  "model": "sonnet",
  "env": { "DEBUG": "true" },
  "enabledPlugins": { "starter-kit@claude-code-guide": true }
}
```

`model` takes an alias (`sonnet`, `opus`, `haiku`) or a full model ID. `env` sets environment variables for the session. `enabledPlugins` is written for you by `claude plugin install`.

---

## Plugins and marketplaces

A **plugin** bundles agents, commands, skills, hooks, and MCP servers into one folder that installs, updates, and uninstalls as a unit. A **marketplace** is a git repository, a URL, or a local folder with a `.claude-plugin/marketplace.json` that lists plugins. This repository is both: the marketplace `claude-code-guide` lists one plugin, `starter-kit`.

### Install and manage

Inside Claude Code:

```
/plugin                                                    # browse, install, manage
/plugin marketplace add HermeticOrmus/claude-code-guide
/plugin install starter-kit@claude-code-guide
/reload-plugins                                            # load the change without restarting
```

From a terminal:

```bash
claude plugin marketplace add HermeticOrmus/claude-code-guide   # GitHub owner/repo, a URL, or a local path
claude plugin marketplace list
claude plugin install starter-kit@claude-code-guide             # --scope user (default), project, or local
claude plugin list
claude plugin disable starter-kit@claude-code-guide
claude plugin enable starter-kit@claude-code-guide
claude plugin marketplace update claude-code-guide              # fetch the marketplace's latest catalog
claude plugin update starter-kit@claude-code-guide              # then update the plugin (restart to apply)
claude plugin uninstall starter-kit@claude-code-guide
claude plugin marketplace remove claude-code-guide
```

### See what a plugin costs before you keep it

```
$ claude plugin details starter-kit@claude-code-guide
starter-kit 2.0.0
  Description: A code reviewer and a teaching agent, project setup, test, and explain commands, a skill template, and a hook that formats files Claude edits.
  Source: starter-kit@claude-code-guide

Component inventory
  Skills (1)  example-skill
  Agents (2)  code-reviewer, learning-assistant
  Hooks (1)  PostToolUse  (harness-only — no model context cost)
  MCP servers (0)
  LSP servers (0)

Projected token cost
  Always-on:   ~287 tok   added to every session

Per-component (rounded)
  component           always-on  on-invoke
  example-skill             ~80       ~390
  code-reviewer            ~100       ~410
  learning-assistant       ~110       ~480
```

**Always-on** is what every session pays for the plugin being enabled: the descriptions of its skills and agents. **On-invoke** is paid each time a skill or agent runs. Hooks run outside the model and cost no context. Compare a plugin's always-on number against what it does for you before you keep it. Inside a session, `/plugin stats` shows skill usage and context costs, and `/context` shows what is filling the context window.

One gap to know about: the inventory counts a flat `commands/<name>.md` as a skill and leaves out commands in subfolders, such as the starter kit's three. They still load; the session's command list shows `/starter-kit:dev:init`, `/starter-kit:dev:test`, and `/starter-kit:learning:explain`.

### Share plugins with a team

`--scope project` records the marketplace and the plugin in the project's `.claude/settings.json`:

```bash
claude plugin marketplace add --scope project HermeticOrmus/claude-code-guide
claude plugin install --scope project starter-kit@claude-code-guide
```

```json
{
  "extraKnownMarketplaces": {
    "claude-code-guide": {
      "source": { "source": "github", "repo": "HermeticOrmus/claude-code-guide" }
    }
  },
  "enabledPlugins": {
    "starter-kit@claude-code-guide": true
  }
}
```

Commit that file, and the project declares the same marketplace and plugins for everyone who opens it.

### Build your own

```
my-marketplace/
├── .claude-plugin/
│   └── marketplace.json        # name, owner, plugins[]
└── my-plugin/
    ├── .claude-plugin/
    │   └── plugin.json         # name, version, description, author
    ├── agents/<name>.md
    ├── commands/<name>.md
    ├── skills/<name>/SKILL.md
    ├── hooks/hooks.json        # commands use ${CLAUDE_PLUGIN_ROOT}
    └── .mcp.json               # optional: MCP servers the plugin starts
```

A `CLAUDE.md` at the plugin root is not loaded; `claude plugin validate` warns about it and suggests shipping that context as a skill. That is why this repo keeps the starter kit's hand-copied files in `starter-kit/templates/`.

This repository's own [.claude-plugin/marketplace.json](.claude-plugin/marketplace.json):

```json
{
  "name": "claude-code-guide",
  "owner": {
    "name": "Diego Bodart",
    "url": "https://github.com/HermeticOrmus"
  },
  "metadata": {
    "description": "The starter kit from the Claude Code Guide, packaged as a Claude Code plugin.",
    "version": "2.0.0"
  },
  "plugins": [
    {
      "name": "starter-kit",
      "source": "./starter-kit",
      "description": "A code reviewer and a teaching agent, project setup, test, and explain commands, a skill template, and a hook that formats files Claude edits.",
      "version": "2.0.0"
    }
  ]
}
```

and [starter-kit/.claude-plugin/plugin.json](starter-kit/.claude-plugin/plugin.json):

```json
{
  "name": "starter-kit",
  "version": "2.0.0",
  "description": "A code reviewer and a teaching agent, project setup, test, and explain commands, a skill template, and a hook that formats files Claude edits.",
  "author": {
    "name": "Diego Bodart",
    "url": "https://github.com/HermeticOrmus"
  },
  "homepage": "https://github.com/HermeticOrmus/claude-code-guide",
  "repository": "https://github.com/HermeticOrmus/claude-code-guide",
  "license": "MIT",
  "keywords": ["starter-kit", "agents", "commands", "skills", "hooks", "claude-code-guide"]
}
```

Two ways to start:

```bash
# Scaffold a plugin in ~/.claude/skills/my-plugin/; it loads as my-plugin@skills-dir
claude plugin init my-plugin --with skills agents hooks

# Load a plugin folder for one session, without installing it
claude --plugin-dir ./my-plugin
```

### Validate

Output in this section is from this repository, with paths shortened.

```bash
claude plugin validate .                # the marketplace
claude plugin validate ./starter-kit    # one plugin, with its skills, agents, commands, and hooks
claude plugin validate --strict .       # warnings fail too, for CI
```

```
$ claude plugin validate ./starter-kit
Validating plugin manifest: ./starter-kit/.claude-plugin/plugin.json

✔ Validation passed
```

It catches the mistakes this guide's first edition made and more: a hook event given as an object instead of an array ("entry ignored at runtime"), an unknown hook event name, an agent with no description, a skill with no frontmatter, a `CLAUDE.md` at the plugin root. This repository runs it on every pull request in [.github/workflows/validate.yml](.github/workflows/validate.yml), together with a clean install.

### Tag a release

```
$ claude plugin tag --dry-run ./starter-kit
Plugin:  starter-kit
Version: 2.0.0 (from plugin.json)
Marketplace entry: plugins[0] in .claude-plugin/marketplace.json (version: 2.0.0)
Tag:     starter-kit--v2.0.0

✔ Dry run — would create tag starter-kit--v2.0.0 at HEAD
```

`claude plugin tag` checks that `plugin.json` and the marketplace entry agree on the version, then creates a `<name>--v<version>` tag. `--push` pushes it.

### Evaluate

`claude plugin eval` runs a plugin's eval suite, scores the results, and by default compares them with a run that has no plugin loaded, so you see what the plugin adds.

```bash
cd starter-kit
claude plugin eval init --bare explain-basics   # a blank case
claude plugin eval .                            # run every case
```

`init --bare` writes `evals/explain-basics/prompt.md` (the task, with `max_turns` and `allowed_tools` in its frontmatter) and `evals/explain-basics/graders/criteria.md` (what a good answer looks like, graded by a model). A run starts real Claude Code sessions on your own account, several per case by default, so it uses your plan or API budget; `--runs`, `--max-cost-usd`, and `--threshold` control that. Evaluate only plugins you trust: the suite runs on your machine, as you. The starter kit does not ship an eval suite yet.

---

## IDE & Terminal Hacks

### Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Escape` | Stop Claude |
| `Escape` twice | Rewind: restore code, conversation, or both to an earlier point (same as `/rewind`) |
| `Shift+Tab` | Cycle permission modes |
| `Shift+Tab` twice | Enter Plan Mode |
| `Shift+Enter` | New line without sending |
| `Ctrl+O` | Transcript mode, including hook output |
| `Ctrl+V` | Paste an image |

`Shift+Enter` works out of the box in iTerm2, WezTerm, Ghostty, Kitty, Warp, and Windows Terminal; in other terminals run `/terminal-setup`. `/keybindings` opens `~/.claude/keybindings.json` to change any shortcut.

### Essential CLI Flags

```bash
claude --model opus                     # Heavy reasoning
claude --model haiku                    # Fast, cheap
claude -c                               # Continue last session
claude -r                               # Pick a session to resume
claude -p "query"                       # Non-interactive
claude -p --max-budget-usd 1 "query"    # Cap spend (2.1 has no --max-turns)
claude --effort high                    # low, medium, high, xhigh, or max
claude --permission-mode plan           # Start in Plan Mode
claude --agent code-reviewer            # Run the session as one agent
claude doctor                           # Check the install and your settings files
```

### Slash Commands

| Command | Purpose |
|---------|---------|
| `/clear` | Reset conversation (use often!). The old session stays resumable with `/resume` |
| `/compact` | Reduce tokens |
| `/usage` | Show session cost and plan usage (`/cost` is an alias) |
| `/context` | See what fills the context window |
| `/permissions` | Manage safe commands |
| `/doctor` | Check installation |
| `/effort` | Set reasoning effort |
| `/memory` | Edit CLAUDE.md files |
| `/hooks` | View configured hooks |
| `/mcp` | Manage MCP servers |
| `/plugin` | Browse, install, and manage plugins |
| `/rewind` | Restore code or conversation |
| `/resume` | Return to an earlier session |

### Extended Thinking

| Phrase | First edition | Claude Code 2.1 |
|--------|---------------|-----------------|
| "think" | Low | No special meaning |
| "think hard" | Medium | No special meaning |
| "think harder" | High | No special meaning |
| "ultrathink" | Maximum | Deeper reasoning for that one turn |

In 2.1, reasoning depth for a session is an effort level: `/effort <level>` in a session, `claude --effort <level>` at launch, with `low`, `medium`, `high`, `xhigh`, or `max`. Higher effort is more thorough and uses more of your plan limits.

### Parallel Sessions

```bash
# Git worktrees for isolated branches
git worktree add ../feature-1 feature-1
cd ../feature-1 && claude

# Or let Claude Code create the worktree
claude -w feature-1
```

`claude --bg "task"` starts a session in the background. `claude agents` lists background sessions, `claude attach <id>` opens one, and `claude logs <id>` prints its recent output.

---

## Boris Cherny's Patterns

### The #1 Tip

> "Give Claude a way to verify its work. If Claude has that feedback loop, it will **2-3x the quality** of the final result."

Add to CLAUDE.md:
```markdown
## Verification
After code changes, run:
- `npm run typecheck`
- `npm run test`
- `npm run lint`
```

### Permissions: The Safe Way

**Don't:** `--dangerously-skip-permissions`

**Do:** `/permissions` to pre-allow safe commands

The rule syntax is in [Permission rules](#permission-rules).

### The Boris Workflow

1. **Start in Plan Mode** (Shift+Tab twice)
2. **Iterate on plan** until satisfied
3. **Switch to auto-accept** mode
4. **Claude executes** (usually one-shots)
5. **Verification runs** automatically

### Team Sharing

Share via git:
- `.claude/settings.json` — Permissions
- `.claude/commands/` — Slash commands
- `.mcp.json` — MCP configs
- `CLAUDE.md` — Project instructions

Skills and agents travel the same way, in `.claude/skills/` and `.claude/agents/`. `.claude/settings.json` can also carry hooks and the team's plugins (`enabledPlugins`, `extraKnownMarketplaces`; see [Share plugins with a team](#share-plugins-with-a-team)).

---

## Setup Checklist

### Phase 1: Foundation

- [ ] Install Claude Code
- [ ] Install the starter kit: `/plugin marketplace add HermeticOrmus/claude-code-guide`, then `/plugin install starter-kit@claude-code-guide` (or copy `starter-kit/` folders into `~/.claude/` as in [Quick Start](#quick-start))
- [ ] Copy `starter-kit/templates/CLAUDE.md` to `~/.claude/CLAUDE.md` and edit it with your details
- [ ] Run `claude doctor`

### Phase 2: External Connections

- [ ] Add memory MCP: `claude mcp add --scope user memory -- npx -y @modelcontextprotocol/server-memory`
- [ ] Add one communication MCP
- [ ] Test each loads: `claude mcp list`

### Phase 3: Personal Workflows

- [ ] Identify 2-3 frequent tasks
- [ ] Create commands for them
- [ ] Test with `/command-name`

### Phase 4: Deeper Customization

- [ ] Skills for complex procedures
- [ ] Agents for specialty domains
- [ ] Hooks for automation
- [ ] Set up `/permissions`
- [ ] Check what your plugins cost with `claude plugin details`

### Ongoing Evolution

- Claude makes mistake → add to CLAUDE.md
- Task repetitive → make it a command
- Command complex → promote to skill
- Need different mode → create agent
- Must happen every time → make it a hook
- Worth sharing → package it as a plugin

---

## Key Principles

1. **Start vanilla** — Add complexity only when needed
2. **Iterate CLAUDE.md** — Add rules when Claude errs
3. **Give Claude verification** — 2-3x quality improvement
4. **Match scrutiny to risk** — 🟢 prototype freely, 🔴 production carefully
5. **Git is your towel** — Never vibe without it

---

## Feedback

Starred this? Tell us what worked and what is missing: [open a feedback issue](https://github.com/HermeticOrmus/claude-code-guide/issues/new?template=feedback.yml). Every piece of feedback gets an answer, and changes that come from it are credited in the release notes.

Cracks we found and sealed: [LEDGER.md](LEDGER.md).

Questions and setups you want to share belong in [Discussions](https://github.com/HermeticOrmus/claude-code-guide/discussions).

## Contribute

- Pick up work from the [Menu](pantry/MENU.md): every item has a Done-when anyone can check. Open items carry the [`menu` label](https://github.com/HermeticOrmus/claude-code-guide/issues?q=is%3Aopen+label%3Amenu), and [good first issues](https://github.com/HermeticOrmus/claude-code-guide/contribute) are on the contribute page.
- A starter-kit agent, skill or command did not run when it should have? File a [routing miss](https://github.com/HermeticOrmus/claude-code-guide/issues/new?template=routing-miss.yml).
- Want a new agent, skill, command or hook in the starter kit? File a [plugin proposal](https://github.com/HermeticOrmus/claude-code-guide/issues/new?template=plugin-proposal.yml), or tell us in a [feedback issue](https://github.com/HermeticOrmus/claude-code-guide/issues/new?template=feedback.yml).
- Show your setup in [Discussions, under Show and tell](https://github.com/HermeticOrmus/claude-code-guide/discussions/categories/show-and-tell).
- Layout and the local test loop: [Ways to contribute](CONTRIBUTING.md#ways-to-contribute).

## Contributing

Contributions welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md) first.

## License

MIT License - see [LICENSE](LICENSE)

---

**DON'T PANIC. Share and Enjoy.**

---

## Part of the Libre Open-Source Stack for Claude Code

This repository is part of a growing family of open-source toolkits for Claude Code.

### Libre suite — comprehensive plugin bundles

- [LibreUIUX-Claude-Code](https://github.com/HermeticOrmus/LibreUIUX-Claude-Code) — UI/UX development (152 agents, 70 plugins, 76 commands, 74 skills)
- [LibreArch-Claude-Code](https://github.com/HermeticOrmus/LibreArch-Claude-Code) — Software architecture and system design
- [LibreCopy-Claude-Code](https://github.com/HermeticOrmus/LibreCopy-Claude-Code) — Technical writing and documentation engineering
- [LibreDevOps-Claude-Code](https://github.com/HermeticOrmus/LibreDevOps-Claude-Code) — DevOps engineering and infrastructure automation
- [LibreEmbed-Claude-Code](https://github.com/HermeticOrmus/LibreEmbed-Claude-Code) — Embedded systems, firmware, and IoT development
- [LibreFinTech-Claude-Code](https://github.com/HermeticOrmus/LibreFinTech-Claude-Code) — Financial technology development
- [LibreGEO-Claude-Code](https://github.com/HermeticOrmus/LibreGEO-Claude-Code) — AI-search optimization (ChatGPT, Perplexity, Gemini, Google AI Overviews)
- [LibreGameDev-Claude-Code](https://github.com/HermeticOrmus/LibreGameDev-Claude-Code) — Game development across Godot, Unity, Unreal
- [LibreMLOps-Claude-Code](https://github.com/HermeticOrmus/LibreMLOps-Claude-Code) — ML engineering and AI operations
- [LibreMobileDev-Claude-Code](https://github.com/HermeticOrmus/LibreMobileDev-Claude-Code) — Mobile app development (Flutter, React Native, native iOS, native Android)
- [LibreSecOps-Claude-Code](https://github.com/HermeticOrmus/LibreSecOps-Claude-Code) — Security operations

### Skills mini-repos — single CLAUDE.md drop-ins

- [vibe-engineer-skills](https://github.com/HermeticOrmus/vibe-engineer-skills) — Direct AI codegen well (hypothesis → scope → validate → reject working-but-wrong)
- [markdown-discipline-skills](https://github.com/HermeticOrmus/markdown-discipline-skills) — Strip AI-slop from markdown (no em dashes, no marketing fluff)
- [shell-safety-skills](https://github.com/HermeticOrmus/shell-safety-skills) — `set -euo pipefail` discipline + 15 failure-mode examples
- [commit-standard-skills](https://github.com/HermeticOrmus/commit-standard-skills) — Ormus Commit Standard v1.0 + commit-msg hook + commitlint
- [unwoke-skills](https://github.com/HermeticOrmus/unwoke-skills) — Strip AI theater (ten sins to eliminate, symmetric engagement)
- [python-conventions-skills](https://github.com/HermeticOrmus/python-conventions-skills) — Modern Python 3.11+ (types, pathlib, async, ruff, mypy, uv)
- [typescript-conventions-skills](https://github.com/HermeticOrmus/typescript-conventions-skills) — TypeScript strict mode, discriminated unions, Result types
- [hermetic-laws-skills](https://github.com/HermeticOrmus/hermetic-laws-skills) — Seven Hermetic Principles applied to engineering
- [riper-workflow-skills](https://github.com/HermeticOrmus/riper-workflow-skills) — Research / Innovate / Plan / Execute / Review systematic dev
- [six-day-cycle-skills](https://github.com/HermeticOrmus/six-day-cycle-skills) — Sustainable shipping cadence with mandatory rest
- [token-optimization-skills](https://github.com/HermeticOrmus/token-optimization-skills) — Claude Code token + context optimization
- [osint-skills](https://github.com/HermeticOrmus/osint-skills) — OSINT research methodology (multi-wave investigative spiral)
- [calcinate-skills](https://github.com/HermeticOrmus/calcinate-skills) — Stage 1 of the Magnum Opus (burn project bloat)
- [claude-md-overhaul-skills](https://github.com/HermeticOrmus/claude-md-overhaul-skills) — Audit CLAUDE.md and MEMORY.md against caps
- [session-handoff-skills](https://github.com/HermeticOrmus/session-handoff-skills) — Session handoff + pickup discipline
- [naming-skills](https://github.com/HermeticOrmus/naming-skills) — Product naming methodology (mine the brand's vocabulary)
- [magnum-opus-skills](https://github.com/HermeticOrmus/magnum-opus-skills) — Seven-stage alchemy applied to project transformation

### Template source

- [andrej-karpathy-skills](https://github.com/HermeticOrmus/andrej-karpathy-skills) — the canonical single-file CLAUDE.md pattern (fork of jiayuan_jy's original)

Star the family, not just one — that's how the suite stays coherent.
