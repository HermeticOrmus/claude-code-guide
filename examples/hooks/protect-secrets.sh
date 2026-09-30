#!/bin/bash
# PreToolUse hook: ask before Claude reads or writes a file that usually holds secrets.
#
# Claude Code sends the hook input as JSON on stdin. For a file path that looks
# like .env, *.pem, *.key, credentials, or secrets, this prints a JSON decision
# of "ask", so Claude Code shows a permission prompt with the reason. Every other
# call exits 0 with no output, which leaves the normal permission flow alone.
#
# Register it in ~/.claude/settings.json (see README, Hooks):
#   "PreToolUse": [{"matcher": "Read|Edit|Write",
#     "hooks": [{"type": "command", "command": "bash ~/.claude/hooks/protect-secrets.sh"}]}]

# No set -e: a hook must exit 0 even when jq or git fails, so each
# command handles its own failure and the script ends with exit 0.
set -uo pipefail
IFS=$'\n\t'

command -v jq &> /dev/null || exit 0

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
