<p align="center">
  <img src="https://ormus.solutions/mascot/pixellab_liquid_to_terminal.gif" alt="Claude Code Guide" width="128" style="image-rendering: pixelated;" />
</p>

<h1 align="center">Claude Code Guide</h1>

<p align="center">
  <em>Complete guide to Claude Code as a system-wide assistant</em>
</p>

<p align="center">
  <a href="https://github.com/HermeticOrmus/claude-code-guide/stargazers"><img src="https://img.shields.io/github/stars/HermeticOrmus/claude-code-guide?style=flat-square&color=aa8142" alt="Stars" /></a>
  <a href="https://github.com/HermeticOrmus/claude-code-guide/blob/main/LICENSE"><img src="https://img.shields.io/github/license/HermeticOrmus/claude-code-guide?style=flat-square&color=aa8142" alt="License" /></a>
  <a href="https://github.com/HermeticOrmus/claude-code-guide/commits"><img src="https://img.shields.io/github/last-commit/HermeticOrmus/claude-code-guide?style=flat-square&color=aa8142" alt="Last Commit" /></a>
  <img src="https://img.shields.io/badge/Claude Code-aa8142?style=flat-square&logo=anthropic&logoColor=white" alt="Claude Code" />
</p>

---

> **DON'T PANIC.** Transform Claude Code from "project-based coding tool" into "computer-wide intelligent assistant."

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

*Compiled from insights by [Boris Cherny](https://howborisusesclaudecode.com/) (creator of Claude Code), [Andrej Karpathy](https://karpathy.bearblog.dev/year-in-review-2025/), [Anthropic Best Practices](https://www.anthropic.com/engineering/claude-code-best-practices), and [The Hitch-Hiker's Guide to Vibe Engineering](https://hermeticormus.github.io/hitchhikers-guide-to-vibe-engineering/).*

---

## Quick Start

```bash
# Copy the starter kit to your home directory
cp -r starter-kit ~/.claude

# Edit with your details
nano ~/.claude/CLAUDE.md

# Start Claude Code
claude
```

---

## Table of Contents

- [Philosophy: Vibe Engineering](#vibe-engineering-philosophy)
- [Architecture Overview](#architecture-overview)
- [MCP Servers (External Tools)](#mcp-servers)
- [Commands (Slash Commands)](#commands)
- [Skills (Procedural Knowledge)](#skills)
- [Agents (Custom Personalities)](#agents)
- [The Global CLAUDE.md](#the-global-claudemd)
- [Hooks (Automation)](#hooks)
- [IDE & Terminal Hacks](#ide--terminal-hacks)
- [Boris Cherny's Patterns](#boris-chernys-patterns)
- [Setup Checklist](#setup-checklist)

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
├── mcp.json                    # MCP server connections
├── settings.json               # Permissions, plugins
├── commands/                   # Slash commands
│   ├── dev/                    # /dev:init, /dev:test
│   └── learning/               # /learning:explain
├── skills/                     # Detailed procedures
├── agents/                     # Custom personalities
├── hooks/                      # Automation triggers
└── memory/                     # Persistent context
```

**Key Insight**: Everything in `~/.claude/` applies globally. Project-specific overrides go in `.claude/` within the project.

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

### Essential MCPs to Start

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
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "ghp_..."
      }
    }
  }
}
```

**Pattern:** If you use it daily, give Claude access to it.

See [examples/mcp-configs/](examples/mcp-configs/) for more configurations.

---

## Commands

Commands are reusable prompts triggered by `/command-name`.

### Structure

```markdown
---
description: Short description shown in command list
thinking: true  # Optional: enable extended thinking
---

# Command Name

Instructions for Claude when this command is invoked.
```

### Organization

```
commands/
├── dev/init.md           → /dev:init
├── dev/test.md           → /dev:test
├── learning/explain.md   → /learning:explain
└── organize.md           → /organize
```

See [starter-kit/commands/](starter-kit/commands/) for templates.

---

## Skills

Skills are more detailed than commands — they contain **step-by-step procedures**.

Think of commands as "triggers" and skills as "detailed playbooks."

### Structure

```markdown
---
name: skill-name
description: What this skill does
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

See [starter-kit/skills/](starter-kit/skills/) for templates.

---

## Agents

Agents define specialized personas Claude can adopt.

### Structure

```markdown
---
name: agent-name
description: What this agent specializes in
model: sonnet
---

You are a [role] expert with deep knowledge of [domain].

## Expertise Areas
- Area 1
- Area 2

## Approach
- How to communicate
- Safety guidelines
```

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

### The Living Document

> "Anytime we see Claude do something incorrectly we add it to CLAUDE.md, so Claude knows not to do it next time." — Boris Cherny

---

## Hooks

Hooks trigger actions on specific events.

### Available Events

| Event | When | Use Cases |
|-------|------|-----------|
| `SessionStart` | New session | Load context |
| `SessionEnd` | Session ends | Save transcript |
| `PostToolUse` | After tool runs | Auto-format code |
| `SubagentStop` | Agent completes | Verify results |

### Configuration

```json
{
  "hooks": {
    "PostToolUse": {
      "command": "bash ~/.claude/hooks/auto-format.sh",
      "timeout": 5000
    }
  }
}
```

See [starter-kit/hooks/](starter-kit/hooks/) for examples.

---

## IDE & Terminal Hacks

### Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Escape` | Stop Claude |
| `Escape` twice | Jump to previous messages |
| `Shift+Tab` twice | Enter Plan Mode |
| `Shift+Enter` | New line without sending |

### Essential CLI Flags

```bash
claude --model opus      # Heavy reasoning
claude --model haiku     # Fast, cheap
claude -c                # Continue last session
claude -p "query"        # Non-interactive
claude --max-turns 3     # Limit depth
```

### Slash Commands

| Command | Purpose |
|---------|---------|
| `/clear` | Reset conversation (use often!) |
| `/compact` | Reduce tokens |
| `/cost` | Show session cost |
| `/permissions` | Manage safe commands |
| `/doctor` | Check installation |

### Extended Thinking

| Phrase | Budget |
|--------|--------|
| "think" | Low |
| "think hard" | Medium |
| "think harder" | High |
| "ultrathink" | Maximum |

### Parallel Sessions

```bash
# Git worktrees for isolated branches
git worktree add ../feature-1 feature-1
cd ../feature-1 && claude
```

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

---

## Setup Checklist

### Phase 1: Foundation

- [ ] Install Claude Code
- [ ] Copy `starter-kit/` to `~/.claude/`
- [ ] Edit `CLAUDE.md` with your details

### Phase 2: External Connections

- [ ] Add memory MCP
- [ ] Add one communication MCP
- [ ] Test each loads

### Phase 3: Personal Workflows

- [ ] Identify 2-3 frequent tasks
- [ ] Create commands for them
- [ ] Test with `/command-name`

### Phase 4: Deeper Customization

- [ ] Skills for complex procedures
- [ ] Agents for specialty domains
- [ ] Hooks for automation
- [ ] Set up `/permissions`

### Ongoing Evolution

- Claude makes mistake → add to CLAUDE.md
- Task repetitive → make it a command
- Command complex → promote to skill
- Need different mode → create agent

---

## Key Principles

1. **Start vanilla** — Add complexity only when needed
2. **Iterate CLAUDE.md** — Add rules when Claude errs
3. **Give Claude verification** — 2-3x quality improvement
4. **Match scrutiny to risk** — 🟢 prototype freely, 🔴 production carefully
5. **Git is your towel** — Never vibe without it

---

## Contributing

Contributions welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md) first.

## License

MIT License - see [LICENSE](LICENSE)

---

**DON'T PANIC. Share and Enjoy.**
