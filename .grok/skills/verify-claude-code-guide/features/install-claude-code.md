# Install from Claude Code

A user adds claude-code-guide as a plugin marketplace in Claude Code and installs plugins from it by name. Each installed plugin shows as enabled under the `claude-code-guide` marketplace and its components are available after a restart.

## Sub-features

- `claude-marketplace-add` registers the repo as the `claude-code-guide` marketplace.
- `claude-install-one` installs one plugin as `<plugin>@claude-code-guide`.
- `claude-install-all` installs every plugin in the pack (1 in total).
- `claude-list` shows each installed plugin as enabled.

## How to get to it (user POV)

- Inside Claude Code: `/plugin marketplace add HermeticOrmus/claude-code-guide`, then `/plugin install starter-kit@claude-code-guide`.
- From a terminal: `claude plugin marketplace add HermeticOrmus/claude-code-guide`, then `claude plugin install starter-kit@claude-code-guide`.
- `/plugin` inside Claude Code opens the plugin manager to browse the rest of the pack.

## Driving it with control-claude-code-guide

Preconditions:

- `.grok/skills/verify-claude-code-guide/bin/control-claude-code-guide doctor` reports `worth_driving: true`.

- **Add the marketplace and install one plugin.** Run `.grok/skills/verify-claude-code-guide/bin/control-claude-code-guide install --claude --only starter-kit`. `evidence/claude-marketplace-add.log` and `evidence/claude-install-starter-kit.log` end in `exit 0`.
- **Confirm it is enabled.** The same command prints `result.json`: `claude.enabled` is 1, `claude.missing` and `claude.load_errors` are empty. `evidence/claude-list.json` has `starter-kit@claude-code-guide` with `"enabled": true`.
- **Install the whole pack.** Run `.grok/skills/verify-claude-code-guide/bin/control-claude-code-guide run`. `result.json` has `claude.wanted` equal to `claude.enabled` (1) and `ok: true`.
- **Proof.** Keep `evidence/claude-list.json` and `evidence/result.json` from the run.

## Gotchas

- The marketplace name is `claude-code-guide` (from `.claude-plugin/marketplace.json`), not the repo name. `<plugin>@claude-code-guide` fails in Claude Code.
- Installing from `HermeticOrmus/claude-code-guide` installs what is on GitHub's default branch. To prove a change, install from the tree under test, which is what the helper does.
- Claude Code loads new plugins at the next session start. The proof is the list and details read back, not a live session.
