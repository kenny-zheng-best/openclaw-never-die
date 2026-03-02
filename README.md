# OpenClaw Gateway Auto-Recovery System

> **Making AI agents as reliable as they are brilliant.**

## 🎯 Why This Exists

I installed OpenClaw — a brilliant AI agent that handles tasks autonomously, communicates via Telegram, automates workflows, and acts as an always-available assistant. It's transformative technology that gives ordinary people what CEOs, founders, and executives have always enjoyed: a dedicated secretary, personal assistant, and executor.

**But there was a problem.**

Despite OpenClaw's intelligence and capabilities, it kept going down. No response. Silent. Dead.

Every time it happened, I had to:
- Notice it was down (sometimes hours later)
- SSH into the machine
- Manually restart the service
- Wait and pray it wouldn't happen again
- Lose time, momentum, and trust

**This defeats the entire purpose.** An AI assistant that requires manual intervention isn't an assistant — it's another thing to babysit.

OpenClaw is already incredibly smart and powerful. The limitation isn't intelligence; it's **infrastructure stability**. The environment around it wasn't reliable enough to match its potential.

## 💡 The Solution

This Claude Code skill transforms OpenClaw from a fragile demo into a **production-ready, bulletproof service** that runs 24/7 without human intervention.

### What It Does

**Four Layers of Protection:**

1. **Instant Crash Recovery** (< 10 seconds)
   macOS LaunchAgent with intelligent KeepAlive restarts the process immediately on crashes

2. **Health Monitoring** (60-second intervals)
   Watchdog continuously checks HTTP health and auto-restarts on failure

3. **Smart Recovery Logic**
   - 3 retry attempts with progressive delays (5s → 10s → 15s)
   - Exponential backoff on repeated failures (30s → 5min)
   - Resource checks (disk space, port conflicts)
   - Automatic log rotation (prevents disk full issues)

4. **Sleep Prevention** (optional)
   Keeps your Mac awake 24/7 for continuous operation

**The result?** OpenClaw just works. Always.

## 🌟 The Vision

We're entering an era where **everyone can have their own AI executive team**. Not just the wealthy or the well-connected — anyone.

All you need to provide:
- ✅ **Goals** — what you want accomplished
- ✅ **Power** — electricity to run the machine
- ✅ **Compute** — a Mac Mini or similar hardware
- ✅ **Stability** — this skill handles that

The AI handles everything else: communication, execution, learning, adapting, remembering context, working while you sleep.

But none of that matters if the system goes down at 3 AM and nobody notices until noon.

**This skill makes AI agents as reliable as they are capable.**

## 📊 Real Impact

### Before This Skill
```
Uptime: 85-90%
Manual interventions: 2-3 times per week
Response time when down: Hours
Trust level: "It'll probably work..."
```

### After This Skill
```
Uptime: 99%+
Manual interventions: ~0 (only for updates)
Response time when down: < 60 seconds (automatic)
Trust level: "It just works."
```

## 🚀 Quick Start

### Installation

1. Copy this skill to Claude Code:
   ```bash
   mkdir -p ~/.claude/skills
   cd ~/.claude/skills
   git clone https://github.com/your-username/openclaw-watchdog-skill.git setup-openclaw-watchdog
   ```

2. Run the skill:
   ```
   /setup-openclaw-watchdog --prevent-sleep
   ```

That's it. OpenClaw will now run 24/7 without your intervention.

### What Gets Installed

- **Gateway LaunchAgent** — Auto-starts on boot, restarts on crashes
- **Watchdog LaunchAgent** — Monitors health every 60 seconds
- **Prevent-Sleep Service** — Keeps Mac awake (optional but recommended)
- **Production-Ready Safeguards** — Log rotation, resource checks, smart retry logic

## ✨ Features

### v2.0 Production Enhancements

- 🔄 **Automatic Log Rotation** — Compresses logs > 100MB, keeps last 5 archives
- 🛡️ **Resource Monitoring** — Checks disk space (min 2GB) before restart attempts
- ⚡ **Exponential Backoff** — Prevents rapid restart loops (30s-5min delay on failures)
- 🔍 **Port Conflict Detection** — Detects if port 18789 is blocked by other processes
- 🔁 **Smart Retry Logic** — 3 restart attempts with increasing wait times
- 📊 **Failure Tracking** — Monitors consecutive failures for intelligent recovery
- 🌐 **Network Dependency** — Waits for network availability before starting
- ⚙️ **Throttle Protection** — 10-second minimum between restart attempts

## 📖 Documentation

- [CHANGELOG.md](./CHANGELOG.md) — Version history and migration guide
- [SKILL.md](./SKILL.md) — Technical implementation details for Claude
- [PREVENT-SLEEP.md](./PREVENT-SLEEP.md) — Deep dive on keeping Mac awake 24/7
- [SHARING.md](./SHARING.md) — How to share this skill with others

## 🔧 Usage Examples

### Basic Setup (No Notifications)
```
/setup-openclaw-watchdog
```

### With Telegram Notifications
```
/setup-openclaw-watchdog --telegram-bot-token YOUR_BOT_TOKEN --telegram-chat-id YOUR_CHAT_ID
```

### Full Setup (Recommended for 24/7 Operation)
```
/setup-openclaw-watchdog --prevent-sleep --telegram-bot-token TOKEN --telegram-chat-id ID
```

### Custom Health Check Interval
```
/setup-openclaw-watchdog --check-interval 30
```

## 🛠️ Monitoring & Control

### Check Status
```bash
# View all OpenClaw services
launchctl list | grep openclaw

# Check gateway status
curl http://127.0.0.1:18789

# View logs
tail -f ~/.openclaw/logs/gateway.log
tail -f ~/.openclaw/watchdog/watchdog.log
```

### Manual Control
```bash
# Restart gateway
launchctl kickstart -k gui/$(id -u)/ai.openclaw.gateway

# Stop all services
launchctl bootout gui/$(id -u)/ai.openclaw.gateway
launchctl bootout gui/$(id -u)/ai.openclaw.watchdog
launchctl bootout gui/$(id -u)/ai.openclaw.prevent-sleep
```

## 🎯 Reliability Metrics

**Production Readiness Score: 8.5/10**

| Metric | Score | Notes |
|--------|-------|-------|
| **Uptime** | 99%+ | With proper configuration |
| **MTTR** | < 60s | Mean time to recovery |
| **Auto-healing** | ✅ | No manual intervention needed |
| **Log Management** | ✅ | Automatic rotation & compression |
| **Resource Protection** | ✅ | Disk/port monitoring |
| **Sleep Prevention** | ✅ | 24/7 operation support |

**Ready for:**
- ✅ Personal AI assistants
- ✅ Team automation tools
- ✅ Small-scale production services
- ✅ Development servers
- ✅ 24/7 automation tasks

**Consider additional monitoring for:**
- ⚠️ Business-critical services
- ⚠️ High-traffic applications
- ⚠️ Compliance requirements

## 🖥️ Requirements

- **macOS** (LaunchAgent is macOS-specific)
- **Node.js** installed
- **OpenClaw** installed
- **Claude Code** (for running the skill)

## 📱 Optional: Telegram Notifications

To receive alerts when OpenClaw goes down or recovers:

1. Create a Telegram bot: Message [@BotFather](https://t.me/BotFather)
2. Get your chat ID: Message [@userinfobot](https://t.me/userinfobot)
3. Run with notifications:
   ```
   /setup-openclaw-watchdog --telegram-bot-token YOUR_TOKEN --telegram-chat-id YOUR_ID
   ```

## 🔍 Troubleshooting

### Gateway Won't Start
```bash
# Check error logs
cat ~/.openclaw/logs/gateway.err.log

# Verify OpenClaw is installed
which openclaw

# Check if port is in use
lsof -i :18789

# Try starting manually
~/.openclaw/bin/openclaw gateway
```

### Watchdog Not Working
```bash
# Test watchdog script manually
bash ~/.openclaw/watchdog/gateway-watchdog.sh

# Check watchdog logs
cat ~/.openclaw/watchdog/watchdog.log

# Verify LaunchAgent is loaded
launchctl list | grep watchdog
```

### Mac Still Sleeps
```bash
# Check caffeinate is running
ps aux | grep caffeinate

# Check power assertions
pmset -g assertions | grep -i prevent

# Restart sleep prevention
launchctl kickstart -k gui/$(id -u)/ai.openclaw.prevent-sleep
```

## 🤝 Contributing

Improvements welcome! Consider:
- Support for Linux (systemd units)
- Enhanced notification options (email, Slack, etc.)
- Configurable retry logic
- Dashboard/status page
- Docker deployment option

## 📄 License

MIT License — Feel free to use, modify, and share!

## 🙏 Credits

Created out of necessity. OpenClaw is brilliant but needs a stable foundation.

This skill bridges the gap between AI capability and infrastructure reliability.

**Because an AI assistant that's down is just an expensive paperweight.**

---

## 💬 Philosophy

The future of work isn't about replacing humans — it's about **amplifying human capability**.

AI agents like OpenClaw are tools that let anyone operate at the scale of a CEO with a full executive team. But tools are only valuable if they're **reliable**.

We've solved intelligence. Now we're solving stability.

**Your AI should work harder than you do. This skill makes sure it can.**

---

**Questions? Issues? Improvements?**
Open an issue or contribute improvements. Let's make AI agents reliable for everyone.
