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

## 📊 Sample HTML Before/After Report

Here’s what the generated HTML system health report looks like after running the script:

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>System Status Report</title>
  <style>
    body { font-family: Arial, sans-serif; margin: 20px; }
    table { border-collapse: collapse; width: 100%; margin-bottom: 20px; }
    th, td { border: 1px solid #ccc; padding: 8px; text-align: left; }
    th { background-color: #f4f4f4; }
    h2 { color: #333; }
  </style>
</head>
<body>

  <h1>System Health Report</h1>
  <p>Generated: 2024-10-31 14:32:12</p>

  <h2>📉 Before Cleanup</h2>
  <table>
    <tr><th>Metric</th><th>Value</th></tr>
    <tr><td>Free Memory</td><td>2.1 GB</td></tr>
    <tr><td>Disk Space Free</td><td>18%</td></tr>
    <tr><td>CPU Load</td><td>76%</td></tr>
  </table>

  <h2>📈 After Cleanup</h2>
  <table>
    <tr><th>Metric</th><th>Value</th></tr>
    <tr><td>Free Memory</td><td>5.4 GB</td></tr>
    <tr><td>Disk Space Free</td><td>42%</td></tr>
    <tr><td>CPU Load</td><td>29%</td></tr>
  </table>

  <p><i>Cleanup actions performed: Homebrew cleanup, cache purge, log cleanup, memory flush</i></p>

</body>
</html>
