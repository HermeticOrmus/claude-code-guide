# Personal Assistant Configuration

> Copy this file to ~/.claude/CLAUDE.md and customize it.

---

## About Me

- **Name**: [Your name]
- **Timezone**: [Your timezone]
- **Learning**: [What you're currently learning]
- **Experience**: [Your technical background]

---

## Preferences

### Communication
- Explain things clearly before doing them
- Ask before destructive operations
- Be concise but complete

### Safety
- Always commit before major changes
- Warn about potentially dangerous operations
- Verify work with tests when possible

---

## Environment

- **Machine**: [OS and version]
- **Primary directories**:
  - Projects: ~/projects/
  - Documents: ~/Documents/

### Available MCPs
<!-- List your configured MCPs here -->
- memory
- filesystem
- github

---

## Verification

After any code change, run these commands:
```bash
# Customize for your stack
npm run typecheck
npm run test
npm run lint
```

If any command fails, fix before continuing.

---

## Workflows

| Situation | Approach |
|-----------|----------|
| New feature | Plan first, then implement |
| Bug fix | Understand root cause first |
| Exploration | Ask questions, read docs |
| Quick question | Answer directly |

---

## Rules

<!-- Add rules here when Claude makes mistakes -->

### Example Rules
- Always use `bun` instead of `npm` in this environment
- Prefer functional components over class components
- Run tests before committing

---

## Notes

<!-- Add any personal notes, preferences, or context -->

---

*Last updated: [date]*
