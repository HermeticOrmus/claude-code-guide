# Menu: claude-code-guide

Queue: 2026-09-30-pantry-queue.md
Counts: open 5, in flight 0, shipped 0, parked 0, dropped 0, needs fixing 0

## Steer

- none

## Up next

**async-hooks**: Cover background hooks in the Hooks chapter (`async-hooks`) (queue #2, high, repo, since 2026-09-30)

- Done when: The README Hooks chapter shows a command hook with `"async": true`, says that an async hook cannot return a decision and when `asyncRewake` fits, and links https://code.claude.com/docs/en/hooks#run-hooks-in-the-background; the example, placed in a throwaway plugin's `hooks/hooks.json`, passes `claude plugin validate --strict`
- Verify on: repo
- Evidence: X row bcherny async hooks and its docs issue anthropics/claude-code#21090; matrix row "Hooks with a working config example" (the official hooks reference documents `async` and `asyncRewake`; the guide does not mention them)
- Issue: none yet (promote after merge)
- Order: async-hooks, check-cli-refs, first-translation, rule-placement, starter-kit-evals
- Tie: async-hooks over check-cli-refs, by key order (jev off)

## Atoms

| Key | Title | State | Confidence | Class | Since | Queue # | Issue | Because |
|-----|-------|-------|------------|-------|-------|---------|-------|---------|
| async-hooks | Cover background hooks in the Hooks chapter (`async-hooks`) | open | high | repo | 2026-09-30 | 2 | - | - |
| check-cli-refs | Check the guide's CLI commands in CI (`check-cli-refs`) | open | high | repo | 2026-09-30 | 1 | - | - |
| first-translation | Add the guide's first translation (`first-translation`) | open | medium | repo | 2026-09-30 | 5 | - | - |
| rule-placement | Show when a rule belongs in CLAUDE.md, settings or a hook (`rule-placement`) | open | medium | repo | 2026-09-30 | 3 | - | - |
| starter-kit-evals | Ship eval cases for the starter kit (`starter-kit-evals`) | open | medium | eval | 2026-09-30 | 4 | - | - |

## Retired

| Key | Title | State | Since | Issue | Because |
|-----|-------|-------|-------|-------|---------|
| none | | | | | |

## Notes

- none
