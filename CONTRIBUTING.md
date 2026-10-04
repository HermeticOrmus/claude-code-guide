# Contributing to Claude Code Guide

Thanks for your interest in contributing!

## Ways to contribute

### Take a Menu item

The [Menu](pantry/MENU.md) is the ordered list of work that is ready to build. It comes from the [pantry](pantry/README.md): a competitor map, posts on X, and what people say in this repo, each row with its source. Every item has a Done-when that anyone can check.

- Open Menu issues: [the `menu` label](https://github.com/HermeticOrmus/claude-code-guide/issues?q=is%3Aopen+label%3Amenu)
- Good first issues: [github.com/HermeticOrmus/claude-code-guide/contribute](https://github.com/HermeticOrmus/claude-code-guide/contribute)

Claim an item by commenting on its issue, then open a pull request whose description says `Closes #N`.

### Report or fix a routing miss

Claude picks an agent, skill or command by its `description:` line. If a starter-kit piece did not run when it should have, or ran when it should not, open a [routing miss](https://github.com/HermeticOrmus/claude-code-guide/issues/new?template=routing-miss.yml). For example: you asked for a review of your diff and `starter-kit:code-reviewer` did not pick it up. The fix is usually one sharper description, which makes it a good first pull request. The same goes for the guide's own description examples: if one of them does not route the way the guide says, report it.

### Propose or build an addition

Open a [plugin proposal](https://github.com/HermeticOrmus/claude-code-guide/issues/new?template=plugin-proposal.yml) if you want a second opinion first, or build it and open a pull request. This repository is a marketplace with one plugin, [`starter-kit/`](starter-kit/), listed in [`.claude-plugin/marketplace.json`](.claude-plugin/marketplace.json). A new piece goes in the matching folder:

```text
starter-kit/
  .claude-plugin/plugin.json      name, version, description, author, license, keywords
  agents/<name>.md                frontmatter: name, description ("Use this agent when ..."), model: inherit
  commands/<group>/<name>.md      frontmatter: description; runs as /starter-kit:<group>:<name>
  skills/<name>/SKILL.md          frontmatter: name, description ("... Use when ...")
  hooks/hooks.json                event matchers; scripts run through ${CLAUDE_PLUGIN_ROOT}
```

Every agent, command and skill needs frontmatter, and its `description` is what routes a request to it, so say when to use it. Explain the new piece in the README chapter for its kind (Commands, Skills, Agents or Hooks). `plugin.json` and the marketplace entry must agree on `version`; `claude plugin tag --dry-run ./starter-kit` checks that. Things people copy by hand rather than load, such as hook scripts and MCP configs, go in [`examples/`](examples/). A whole new plugin would sit next to `starter-kit/` with its own `.claude-plugin/plugin.json` and a second entry in the marketplace; propose that one first.

### Translate

The guide is English only. A translation is welcome as `README.<language code>.md` at the root (for example `README.es.md`) that links back to `README.md` and names the edition it was translated from (see [CHANGELOG.md](CHANGELOG.md)). Search open pull requests first, so two people do not translate the same file.

### Share what you built

Built a setup, a hook or a plugin with the guide? Post it in [Discussions, under Show and tell](https://github.com/HermeticOrmus/claude-code-guide/discussions/categories/show-and-tell), or tell us in a [feedback issue](https://github.com/HermeticOrmus/claude-code-guide/issues/new?template=feedback.yml). What you share can become pantry evidence for the next Menu.

### Test your change locally

You need the `claude` CLI and `jq`. From the root of your checkout:

```bash
# Check the marketplace manifest and the plugin (--strict fails on warnings too)
claude plugin validate .
claude plugin validate starter-kit
claude plugin validate --strict starter-kit

# Load the plugin from its folder for one session, without installing it
claude --plugin-dir ./starter-kit

# Install from this checkout into a clean, throwaway config, the way a new reader would
(
  export CLAUDE_CONFIG_DIR=$(mktemp -d)
  claude plugin marketplace add ./
  claude plugin install starter-kit@claude-code-guide
  claude plugin details starter-kit@claude-code-guide
  claude plugin list --json | jq '.[] | select((.errors // []) | length > 0)'
)
```

`claude plugin details` lists the agents and skills with their token cost. It leaves out commands kept in subfolders, such as `commands/dev/init.md`; that is how the CLI reports them, and they still load as `/starter-kit:dev:init`. The last line prints nothing when the plugin loaded without errors. To try a hook script without Claude, pipe it a JSON event as [Test a hook without Claude](README.md#test-a-hook-without-claude) shows.

CI ([`.github/workflows/check.yml`](.github/workflows/check.yml), running `bash scripts/check.sh`) runs the same checks on every pull request: it validates the marketplace and the plugin, then installs it into a clean config. If this is your first contribution, the CI run waits until a maintainer approves it.

## How to Contribute

### Reporting Issues

- Use GitHub Issues for bugs and suggestions
- Include specific examples when possible
- Describe your environment if relevant

### Submitting Changes

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-addition`)
3. Make your changes
4. Commit with clear messages (`git commit -m "Add amazing addition"`)
5. Push to your fork (`git push origin feature/amazing-addition`)
6. Open a Pull Request

### What We're Looking For

- **New MCP configurations** - Share working configs for useful services
- **Command templates** - Useful slash commands for common tasks
- **Skill examples** - Well-documented procedural skills
- **Agent personalities** - Specialized agents for specific domains
- **Hook scripts** - Automation examples
- **Documentation improvements** - Clarifications, corrections, examples

### Style Guidelines

- Keep examples minimal and focused
- Include comments explaining non-obvious parts
- Test configurations before submitting
- If you change the starter kit, run `claude plugin validate .` and `claude plugin validate starter-kit` (CI runs both, plus a clean install); add `--strict` to fail on warnings too
- Follow existing file structure patterns

### Code of Conduct

- Be respectful and constructive
- Focus on the content, not the person
- Help others learn

## Questions?

Open an issue with the "question" label.

---

**DON'T PANIC. Share and Enjoy.**
