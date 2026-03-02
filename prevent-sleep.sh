#!/bin/bash
# Prevent Mac from sleeping to ensure OpenClaw runs continuously
# This script provides multiple methods to prevent sleep

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🌙 OpenClaw - Prevent Sleep Configuration${NC}"
echo "=========================================="
echo ""

# Check current power settings
echo "📊 Current Power Settings:"
echo ""
pmset -g | grep -E "(sleep|displaysleep)" | sed 's/^/ /'
echo ""

# Method 1: LaunchAgent with caffeinate (Recommended)
setup_caffeinate_agent() {
    echo -e "${BLUE}Method 1: LaunchAgent with caffeinate (Recommended)${NC}"
    echo "This keeps the system awake using a background service."
    echo ""

    PLIST_PATH="$HOME/Library/LaunchAgents/ai.openclaw.prevent-sleep.plist"

    cat > "$PLIST_PATH" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>ai.openclaw.prevent-sleep</string>

    <key>Comment</key>
    <string>Keep Mac awake for OpenClaw Gateway</string>

    <key>ProgramArguments</key>
    <array>
      <string>/usr/bin/caffeinate</string>
      <string>-dims</string>
    </array>

    <key>RunAtLoad</key>
    <true/>

    <key>KeepAlive</key>
    <true/>

    <key>StandardOutPath</key>
    <string>/dev/null</string>

    <key>StandardErrorPath</key>
    <string>/dev/null</string>
  </dict>
</plist>
EOF

    # Load the LaunchAgent
    launchctl bootout gui/$(id -u)/ai.openclaw.prevent-sleep 2>/dev/null || true
    launchctl bootstrap gui/$(id -u) "$PLIST_PATH"

    sleep 2

    if launchctl list | grep -q "ai.openclaw.prevent-sleep"; then
        echo -e "${GREEN}✅ Prevent-sleep service installed and running${NC}"
        echo "   Service: ai.openclaw.prevent-sleep"
        echo "   Method: caffeinate -dims (display + idle + system + disk)"
        echo ""
        return 0
    else
        echo -e "${RED}❌ Failed to load service${NC}"
        return 1
    fi
}

# Method 2: pmset configuration (Requires sudo)
setup_pmset() {
    echo -e "${BLUE}Method 2: System Power Settings (pmset)${NC}"
    echo "This modifies system power management settings."
    echo -e "${YELLOW}⚠️  Requires administrator password${NC}"
    echo ""

    read -p "Do you want to configure pmset? (y/N) " -n 1 -r
    echo ""

    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Skipped pmset configuration"
        return 0
    fi

    echo "Configuring power settings..."
    echo ""

    # Disable sleep
    sudo pmset -a sleep 0 || { echo -e "${RED}Failed to set sleep${NC}"; return 1; }
    echo "✓ System sleep: disabled"

    # Disable display sleep
    sudo pmset -a displaysleep 0 || { echo -e "${RED}Failed to set displaysleep${NC}"; return 1; }
    echo "✓ Display sleep: disabled"

    # Disable disk sleep
    sudo pmset -a disksleep 0 || { echo -e "${RED}Failed to set disksleep${NC}"; return 1; }
    echo "✓ Disk sleep: disabled"

    # Enable wake on network access
    sudo pmset -a womp 1 || { echo -e "${RED}Failed to set womp${NC}"; return 1; }
    echo "✓ Wake on network: enabled"

    # Enable automatic restart on power loss
    sudo pmset -a autorestart 1 || { echo -e "${RED}Failed to set autorestart${NC}"; return 1; }
    echo "✓ Auto-restart on power loss: enabled"

    echo ""
    echo -e "${GREEN}✅ Power settings configured${NC}"
    return 0
}

# Method 3: Show manual caffeinate command
show_manual_method() {
    echo -e "${BLUE}Method 3: Manual caffeinate (Temporary)${NC}"
    echo ""
    echo "Run this command in a terminal (keeps running until you close it):"
    echo ""
    echo -e "${GREEN}  caffeinate -dims${NC}"
    echo ""
    echo "Flags explanation:"
    echo "  -d : Prevent display from sleeping"
    echo "  -i : Prevent system from idle sleeping"
    echo "  -m : Prevent disk from sleeping"
    echo "  -s : Prevent system from sleeping (on power button)"
    echo ""
}

# Check current status
check_status() {
    echo -e "${BLUE}📊 Current Status Check${NC}"
    echo "=========================================="
    echo ""

    # Check LaunchAgent
    if launchctl list | grep -q "ai.openclaw.prevent-sleep"; then
        echo -e "${GREEN}✓${NC} Prevent-sleep LaunchAgent: Running"
        CAFFEINATE_PID=$(launchctl list | grep "ai.openclaw.prevent-sleep" | awk '{print $1}')
        if [ "$CAFFEINATE_PID" != "-" ]; then
            echo "  PID: $CAFFEINATE_PID"
        fi
    else
        echo -e "${YELLOW}○${NC} Prevent-sleep LaunchAgent: Not running"
    fi

    # Check caffeinate processes
    CAFFEINATE_COUNT=$(ps aux | grep -c "[c]affeinate" || true)
    if [ "$CAFFEINATE_COUNT" -gt 0 ]; then
        echo -e "${GREEN}✓${NC} Caffeinate processes: $CAFFEINATE_COUNT running"
        ps aux | grep "[c]affeinate" | awk '{print "  PID " $2 ": " $11 " " $12 " " $13 " " $14}'
    else
        echo -e "${YELLOW}○${NC} Caffeinate processes: None"
    fi

    echo ""

    # Check power assertions
    echo "Active sleep prevention assertions:"
    pmset -g assertions | grep -A 2 "PreventUserIdleSystemSleep" | sed 's/^/  /'

    echo ""

    # Check power settings
    echo "Current power settings:"
    pmset -g | grep -E "(sleep|displaysleep|disksleep)" | sed 's/^/  /'

    echo ""
}

# Uninstall
uninstall() {
    echo -e "${BLUE}🗑️  Uninstalling Prevent-Sleep Service${NC}"
    echo "=========================================="
    echo ""

    if launchctl list | grep -q "ai.openclaw.prevent-sleep"; then
        launchctl bootout gui/$(id -u)/ai.openclaw.prevent-sleep 2>/dev/null || true
        echo "✓ Service stopped"
    fi

    PLIST_PATH="$HOME/Library/LaunchAgents/ai.openclaw.prevent-sleep.plist"
    if [ -f "$PLIST_PATH" ]; then
        rm "$PLIST_PATH"
        echo "✓ LaunchAgent file removed"
    fi

    echo ""
    echo -e "${GREEN}✅ Uninstall complete${NC}"
    echo ""
    echo "Note: This does NOT revert pmset settings."
    echo "To re-enable sleep, run:"
    echo "  sudo pmset -a sleep 10"
    echo "  sudo pmset -a displaysleep 10"
}

# Main menu
show_menu() {
    echo ""
    echo "Choose an option:"
    echo ""
    echo "  1) Install LaunchAgent (caffeinate service) [Recommended]"
    echo "  2) Configure pmset (system power settings) [Requires sudo]"
    echo "  3) Both (LaunchAgent + pmset)"
    echo "  4) Show manual method (temporary)"
    echo "  5) Check current status"
    echo "  6) Uninstall LaunchAgent"
    echo "  0) Exit"
    echo ""
    read -p "Enter choice [0-6]: " choice

    case $choice in
        1)
            echo ""
            setup_caffeinate_agent
            ;;
        2)
            echo ""
            setup_pmset
            ;;
        3)
            echo ""
            setup_caffeinate_agent && setup_pmset
            ;;
        4)
            echo ""
            show_manual_method
            ;;
        5)
            echo ""
            check_status
            ;;
        6)
            echo ""
            uninstall
            ;;
        0)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid choice${NC}"
            ;;
    esac
}

# Check if running with arguments
if [ $# -eq 0 ]; then
    # Interactive mode
    while true; do
        show_menu
        echo ""
        read -p "Press Enter to continue or Ctrl+C to exit..."
    done
else
    # Command-line mode
    case "$1" in
        install|setup)
            setup_caffeinate_agent
            ;;
        pmset)
            setup_pmset
            ;;
        all)
            setup_caffeinate_agent && setup_pmset
            ;;
        status|check)
            check_status
            ;;
        uninstall|remove)
            uninstall
            ;;
        help|--help|-h)
            echo "Usage: $0 [command]"
            echo ""
            echo "Commands:"
            echo "  install    - Install caffeinate LaunchAgent"
            echo "  pmset      - Configure power settings (requires sudo)"
            echo "  all        - Install LaunchAgent + configure pmset"
            echo "  status     - Check current configuration"
            echo "  uninstall  - Remove LaunchAgent"
            echo "  help       - Show this help"
            echo ""
            echo "No arguments: Interactive menu"
            ;;
        *)
            echo "Unknown command: $1"
            echo "Run '$0 help' for usage"
            exit 1
            ;;
    esac
fi

echo ""
echo -e "${GREEN}Done!${NC}"
