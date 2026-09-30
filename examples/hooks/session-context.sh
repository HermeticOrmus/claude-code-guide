#!/bin/bash
# SessionStart hook: give Claude a one-line git summary when a session starts.
#
# Claude Code sends the hook input as JSON on stdin, including cwd. For
# SessionStart, whatever this prints on stdout (with exit code 0) is added to
# Claude's context. Outside a git repository it prints nothing.
#
# Register it in ~/.claude/settings.json (see README, Hooks):
#   "SessionStart": [{"hooks": [{"type": "command", "command": "bash ~/.claude/hooks/session-context.sh"}]}]

# No set -e: a hook must exit 0 even when jq or git fails, so each
# command handles its own failure and the script ends with exit 0.
set -uo pipefail
IFS=$'\n\t'

command -v jq &> /dev/null || exit 0

DIR=$(jq -r '.cwd // empty' 2>/dev/null)
[ -n "$DIR" ] || exit 0
git -C "$DIR" rev-parse --is-inside-work-tree &> /dev/null || exit 0

BRANCH=$(git -C "$DIR" branch --show-current 2>/dev/null)
CHANGED=$(git -C "$DIR" status --porcelain 2>/dev/null | wc -l | tr -d ' ')
echo "Git: branch ${BRANCH:-detached}, ${CHANGED} uncommitted file(s)."

exit 0
