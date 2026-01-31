#!/bin/bash
# Auto-format code after Claude edits a file
# Place in ~/.claude/hooks/auto-format.sh

HOOK_INPUT=$(cat)
TOOL_NAME=$(echo "$HOOK_INPUT" | jq -r '.tool_name')

if [ "$TOOL_NAME" = "Edit" ] || [ "$TOOL_NAME" = "Write" ]; then
    FILE_PATH=$(echo "$HOOK_INPUT" | jq -r '.tool_input.file_path')

    case "$FILE_PATH" in
        *.py)
            # Python: use black or ruff
            command -v black &> /dev/null && black "$FILE_PATH" 2>/dev/null
            ;;
        *.js|*.ts|*.jsx|*.tsx)
            # JavaScript/TypeScript: use prettier
            command -v prettier &> /dev/null && prettier --write "$FILE_PATH" 2>/dev/null
            ;;
        *.go)
            # Go: use gofmt
            command -v gofmt &> /dev/null && gofmt -w "$FILE_PATH" 2>/dev/null
            ;;
        *.rs)
            # Rust: use rustfmt
            command -v rustfmt &> /dev/null && rustfmt "$FILE_PATH" 2>/dev/null
            ;;
    esac
fi
