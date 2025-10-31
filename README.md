# macOS System Health Dashboard + Speed Toolkit

> A one-file, Bash 3.2–compatible dashboard for live CPU/MEM/DISK/NET stats and safe, opt-in cleanups — with logs, notifications, and an HTML before/after report.

## ✨ Features
- Live metrics for CPU/MEM/DISK/NET
- Safe, confirmed actions: kill heavy tasks, clean caches/logs/trash, flush DNS, Homebrew cleanup, Docker prune, login items, Spotlight tools, npm cache, optional purge
- Logs to ~/system-dash.log, notifications, HTML before/after report at ~/system-dash.html

## Quick Start
```bash
curl -L -o ~/system-dash.sh https://raw.githubusercontent.com/<your-username>/system-dash/main/system-dash.sh
chmod +x ~/system-dash.sh
~/system-dash.sh

