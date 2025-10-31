# macOS System Health Dashboard + Speed Toolkit

> A single-file, Bash 3.2–compatible system monitor + cleanup toolkit for macOS.  
> Live CPU/MEM/DISK/NET stats, safe cleanup options, logs, notifications, and an auto-generated HTML before/after report.

---

## ✨ Features

- Live system dashboard: CPU %, Memory use, Disk usage, Network I/O
- Safe, opt-in cleanup operations:
  - Kill heavy processes  
  - Clean caches / logs / Trash  
  - Flush DNS  
  - Homebrew cleanup  
  - Docker prune  
  - Remove login items  
  - Spotlight index maintenance  
  - npm cache purge  
  - Optional memory purge (`sudo purge`)
- Logs to `~/system-dash.log`
- Generates HTML report at `~/system-dash.html`
- macOS-native notifications (`osascript`)

---

## 📸 Example Output (HTML Report)

<p align="center">
  <img width="900" alt="System Dashboard Report" src="https://github.com/user-attachments/assets/84cbd780-75dc-4508-a1eb-2625dcac8f36" />
</p>

---

## 🖥️ Example Terminal View (Live Dashboard UI)

<p align="center">
  <img width="900" alt="Terminal System Dash" src="https://github.com/user-attachments/assets/REPLACE_WITH_TERMINAL_IMG" />
</p>

---

## 🚀 How to Install & Use

### 1️⃣ One-line install (recommended)

```bash
curl -L -o ~/system-dash.sh https://raw.githubusercontent.com/<YOUR-USERNAME>/<YOUR-REPO>/main/system-dash.sh
chmod +x ~/system-dash.sh
