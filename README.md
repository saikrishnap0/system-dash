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

## 📊 Sample Report (GitHub-Safe Preview)

Below is a **rendered example** of the report *as a table* so it displays nicely on GitHub. The real report the script writes to `~/system-dash.html` includes styling.

**Generated:** 2024-10-31 14:32:12

### 📉 Before Cleanup
| Metric            | Value |
|-------------------|-------|
| Free Memory       | 2.1 GB |
| Disk Space Free   | 18% |
| CPU Load          | 76% |

### 📈 After Cleanup
| Metric            | Value |
|-------------------|-------|
| Free Memory       | 5.4 GB |
| Disk Space Free   | 42% |
| CPU Load          | 29% |

*Cleanup actions performed: Homebrew cleanup, cache purge, log cleanup, memory flush*

---

## 🧩 Sample HTML (Copy/Paste Source)

> **Note:** GitHub strips most CSS in READMEs. This block is for users who want to copy the exact HTML file or view the structure. The actual file written by the script will include styling locally.

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>System Status Report</title>
  <!-- Minimal inline styles so GitHub won't strip everything when previewing locally -->
  <style>
    body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Arial, sans-serif; margin: 20px; }
    table { border-collapse: collapse; width: 100%; margin: 16px 0; }
    th, td { border: 1px solid #ccc; padding: 8px; text-align: left; }
    th { background: #f6f8fa; }
    h1, h2, h3 { margin: 0.6em 0; }
    .muted { color: #666; font-size: 0.95em; }
    .grid { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
    @media (max-width: 720px) { .grid { grid-template-columns: 1fr; } }
  </style>
</head>
<body>

  <h1>System Health Report</h1>
  <p class="muted">Generated: 2024-10-31 14:32:12</p>

  <div class="grid">
    <section>
      <h2>📉 Before Cleanup</h2>
      <table>
        <tr><th>Metric</th><th>Value</th></tr>
        <tr><td>Free Memory</td><td>2.1 GB</td></tr>
        <tr><td>Disk Space Free</td><td>18%</td></tr>
        <tr><td>CPU Load</td><td>76%</td></tr>
      </table>
    </section>

    <section>
      <h2>📈 After Cleanup</h2>
      <table>
        <tr><th>Metric</th><th>Value</th></tr>
        <tr><td>Free Memory</td><td>5.4 GB</td></tr>
        <tr><td>Disk Space Free</td><td>42%</td></tr>
        <tr><td>CPU Load</td><td>29%</td></tr>
      </table>
    </section>
  </div>

  <p class="muted"><em>Cleanup actions performed: Homebrew cleanup, cache purge, log cleanup, memory flush</em></p>

</body>
</html>
