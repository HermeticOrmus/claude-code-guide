#!/bin/bash
# Auto-format code after Claude edits a file
#
# Claude Code sends hook input as JSON on stdin. This script reads tool_name,
# tool_input.file_path, and cwd with jq, runs the matching formatter when it is
# installed, and always exits 0, so a missing or failing formatter never blocks
# Claude. It stays silent and writes no log files.
#
# As a plugin hook: hooks/hooks.json registers it for PostToolUse (Edit|Write).
# As a manual hook: place in ~/.claude/hooks/auto-format.sh and add the block
# from hooks/settings.json to ~/.claude/settings.json.
#
# Test it without Claude:
#   echo '{"tool_name":"Write","tool_input":{"file_path":"'"$PWD"'/a.py"},"cwd":"'"$PWD"'"}' | bash auto-format.sh

# No set -e: a hook must exit 0 even when a formatter or jq fails, so each
# command handles its own failure and the script ends with exit 0.
set -uo pipefail
IFS=$'\n\t'

command -v jq &> /dev/null || exit 0

HOOK_INPUT=$(cat)
TOOL_NAME=$(printf '%s' "$HOOK_INPUT" | jq -r '.tool_name // empty' 2>/dev/null)

if [ "$TOOL_NAME" = "Edit" ] || [ "$TOOL_NAME" = "Write" ]; then
    FILE_PATH=$(printf '%s' "$HOOK_INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null)
    PROJECT_DIR=$(printf '%s' "$HOOK_INPUT" | jq -r '.cwd // empty' 2>/dev/null)

    [ -n "$FILE_PATH" ] && [ -f "$FILE_PATH" ] || exit 0

    # Only format files inside the project Claude is working in.
    if [ -n "$PROJECT_DIR" ]; then
        case "$FILE_PATH" in
            "$PROJECT_DIR"/*) ;;
            *) exit 0 ;;
        esac
    fi

    case "$FILE_PATH" in
        *.py)
            # Python: use black or ruff
            if command -v black &> /dev/null; then
                black -q "$FILE_PATH" &> /dev/null
            elif command -v ruff &> /dev/null; then
                ruff format -q "$FILE_PATH" &> /dev/null
            fi
            ;;
        *.js|*.ts|*.jsx|*.tsx)
            # JavaScript/TypeScript: use prettier
            command -v prettier &> /dev/null && prettier --write "$FILE_PATH" &> /dev/null
            ;;
        *.go)
            # Go: use gofmt
            command -v gofmt &> /dev/null && gofmt -w "$FILE_PATH" &> /dev/null
            ;;
        *.rs)
            # Rust: use rustfmt
            command -v rustfmt &> /dev/null && rustfmt "$FILE_PATH" &> /dev/null
            ;;
    esac
fi

exit 0
