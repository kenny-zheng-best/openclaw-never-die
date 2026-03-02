#!/bin/bash
# OpenClaw Watchdog Skill Installer
# Quick install script for sharing this skill with others

set -e

SKILL_NAME="setup-openclaw-watchdog"
SKILL_DIR="$HOME/.claude/skills/$SKILL_NAME"

echo "🦞 OpenClaw Auto-Recovery Skill Installer"
echo "=========================================="
echo ""

# Check if Claude Code is installed
if ! command -v claude &> /dev/null; then
    echo "❌ Claude Code not found. Please install Claude Code first:"
    echo "   https://claude.ai/download"
    exit 1
fi

echo "✅ Claude Code detected"
echo ""

# Check if skill already exists
if [ -d "$SKILL_DIR" ]; then
    read -p "⚠️  Skill already exists. Overwrite? (y/N) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ Installation cancelled"
        exit 0
    fi
    echo "🗑️  Removing existing skill..."
    rm -rf "$SKILL_DIR"
fi

# Create skills directory if it doesn't exist
mkdir -p "$HOME/.claude/skills"

# Copy skill files
echo "📦 Installing skill files..."
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cp -r "$SCRIPT_DIR" "$SKILL_DIR"

# Verify installation
if [ -f "$SKILL_DIR/SKILL.md" ]; then
    echo "✅ Skill installed successfully!"
    echo ""
    echo "📍 Location: $SKILL_DIR"
    echo ""
    echo "🚀 Usage:"
    echo "   1. Start a new Claude Code session"
    echo "   2. Run: /setup-openclaw-watchdog"
    echo ""
    echo "💡 For Telegram notifications:"
    echo "   /setup-openclaw-watchdog --telegram-bot-token YOUR_TOKEN --telegram-chat-id YOUR_CHAT_ID"
    echo ""
    echo "📖 More info: $SKILL_DIR/README.md"
else
    echo "❌ Installation failed - SKILL.md not found"
    exit 1
fi
