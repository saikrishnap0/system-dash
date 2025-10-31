# macOS System Health Dashboard + Speed Toolkit

> A one-file, Bash 3.2–compatible dashboard for live CPU/MEM/DISK/NET stats and safe, opt-in cleanups — with logs, notifications, and an HTML before/after report.

## ✨ Features
- Live metrics for CPU, Memory, Disk, and Network
- Safe, confirmed system maintenance actions:
  - Kill heavy tasks  
  - Clean caches/logs/trash  
  - Flush DNS  
  - Homebrew cleanup  
  - Docker prune  
  - Login items cleanup  
  - Spotlight reindex tools  
  - npm cache purge  
  - Optional macOS purge  
- Saves logs to `~/system-dash.log`
- Sends system notifications  
- Generates an **HTML before/after report** at `~/system-dash.html`

---

## 📸 Screenshot of the HTML Report 
System Health Report
Generated: 2024-10-31 14:32:12

📉 Before Cleanup

+-------------------+--------+
| Metric            | Value  |
+-------------------+--------+
| Free Memory       | 2.1 GB |
| Disk Space Free   | 18%    |
| CPU Load          | 76%    |
+-------------------+--------+

📈 After Cleanup

+-------------------+--------+
| Metric            | Value  |
+-------------------+--------+
| Free Memory       | 5.4 GB |
| Disk Space Free   | 42%    |
| CPU Load          | 29%    |
+-------------------+--------+

Cleanup actions performed: Homebrew cleanup, cache purge,
log cleanup, memory flush
