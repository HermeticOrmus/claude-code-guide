# Pantry queue: Claude Code Guide

## How this fills

1. Read the latest competitor map, X mine and people mine.
2. Propose 5 to 8 Goal atoms that answer their themes. The Menu needs at least 3.
3. Each atom needs a Done predicate someone else can check on this repo, a surface, the evidence rows it answers, and a confidence (high, medium or low).
4. Save as `YYYY-MM-DD-pantry-queue.md`; the Menu reads the newest one.
5. Retire an atom only with a bullet under "Explicitly not stocked" of the form `<Title>: shipped, PR #N` or `<Title>: parked, <reason>`.

Sources for this run: [competitor map](2026-09-30-competitor-map.md), [X mine](2026-09-30-x-mine.md), [people mine](2026-09-30-people-mine.md) (no outside voices yet).

## Atoms

| # | Title | Done predicate | Surface | Evidence | Confidence |
|---|-------|----------------|---------|----------|------------|
| 1 | Check the guide's CLI commands in CI (`check-cli-refs`) | `scripts/check-cli-refs.sh` collects every `claude <subcommand>` invocation from the code blocks in `README.md` and runs `claude <subcommand> --help` for each, printing one line per command; it exits 0 on `master`, exits 1 when a documented subcommand no longer exists, and `.github/workflows/validate.yml` runs it on pull requests | repo | Matrix rows "States which Claude Code version it was checked against" (claude-howto and zebbern stamp 2.1.285 too, so the stamp alone does not set us apart) and "Automated check that documented commands still exist" (Us N); X row bcherny async hooks (a hooks option announced on X that a docs issue then reported missing from the reference) | high |
| 2 | Cover background hooks in the Hooks chapter (`async-hooks`) | The README Hooks chapter shows a command hook with `"async": true`, says that an async hook cannot return a decision and when `asyncRewake` fits, and links https://code.claude.com/docs/en/hooks#run-hooks-in-the-background; the example, placed in a throwaway plugin's `hooks/hooks.json`, passes `claude plugin validate --strict` | repo | X row bcherny async hooks and its docs issue anthropics/claude-code#21090; matrix row "Hooks with a working config example" (the official hooks reference documents `async` and `asyncRewake`; the guide does not mention them) | high |
| 3 | Show when a rule belongs in CLAUDE.md, settings or a hook (`rule-placement`) | A README section, linked from "The Global CLAUDE.md" and "Settings and permission modes", writes one rule three ways (a CLAUDE.md line, a `permissions` rule in `settings.json`, a PreToolUse hook), says which of the three is enforced and which is advice to the model, and every settings block in it passes `claude doctor` with no "Invalid settings" entry | repo | X rows akshay_pachaar (CLAUDE.md "might forget"), dani_avila7 settings.json versus CLAUDE.md, bcherny `/permissions`; matrix rows "CLAUDE.md and memory" and "Settings and permission modes" | medium |
| 4 | Ship eval cases for the starter kit (`starter-kit-evals`) | `starter-kit/evals/` holds one case for the `code-reviewer` agent and one for `/starter-kit:learning:explain`, each with `prompt.md` and `graders/criteria.md` in the layout `claude plugin eval init --bare` writes; `claude plugin validate --strict starter-kit` exits 0; the README "Evaluate" section links the cases | repo | Matrix row "Plugin eval suite shipped" (Us N: the README says "The starter kit does not ship an eval suite yet."); matrix row "Installable starter kit" | medium |
| 5 | Add the guide's first translation (`first-translation`) | `README.<language code>.md` at the root translates every chapter of `README.md`, names the edition and Claude Code version it was translated from, keeps every command and code block as in English, links back to `README.md`, and `README.md` links it near the top | repo | Matrix row "Translations (non-English editions)" (Us N; the official docs, claude-howto and claude-code-ultimate-guide have them) | medium |

## Explicitly not stocked (and why)

- `claude plugin details` leaving out commands kept in subfolders: not stocked. It is how the CLI reports a plugin, not something in this repo; the README "See what a plugin costs" section already explains it.
- A searchable website for the guide: not stocked this run. It needs a hosting choice made by the maintainer, and the evidence (competitor map) only shows that others have one.
- Moving the starter kit's commands out of their subfolders: not stocked. The `/starter-kit:dev:init` names are documented and working; flattening them would rename commands readers already use.
