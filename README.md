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

## 📸 “Screenshot” of the HTML Report (Embedded Mock)

<!--
  This block is HTML-only with inline styles (GitHub-safe).
  It visually mimics a browser window screenshot without using an actual image.
-->
<div style="max-width: 980px; margin: 16px auto; border: 1px solid #d0d7de; border-radius: 12px; overflow: hidden; box-shadow: 0 2px 8px rgba(27,31,35,.12); background: #fff;">
  <!-- Fake browser chrome -->
  <div style="display:flex; align-items:center; gap:8px; padding:8px 12px; background:#f6f8fa; border-bottom:1px solid #d0d7de;">
    <span style="width:12px; height:12px; background:#ff5f56; border-radius:50%; display:inline-block;"></span>
    <span style="width:12px; height:12px; background:#ffbd2e; border-radius:50%; display:inline-block;"></span>
    <span style="width:12px; height:12px; background:#27c93f; border-radius:50%; display:inline-block;"></span>
    <div style="flex:1; text-align:center;">
      <div style="display:inline-block; padding:4px 12px; background:#fff; border:1px solid #d0d7de; border-radius:16px; font-size:12px; color:#57606a; min-width:60%;">
        file:///Users/you/system-dash.html
      </div>
    </div>
  </div>

  <!-- Page content -->
  <div style="padding: 20px;">
    <h1 style="margin:0 0 8px 0; font-size:22px; line-height:1.25; color:#24292f;">System Health Report</h1>
    <p style="margin:0 0 16px 0; color:#57606a; font-size:13px;">Generated: 2024-10-31 14:32:12</p>

    <!-- Two-column layout using a table (reliable in GitHub rendering) -->
    <table style="width:100%; border-spacing:16px 0;">
      <tr>
        <td style="width:50%; vertical-align:top;">
          <h2 style="font-size:16px; margin:0 0 8px 0;">📉 Before Cleanup</h2>
          <table style="width:100%; border-collapse:collapse;">
            <tr>
              <th style="text-align:left; border:1px solid #d0d7de; padding:8px; background:#f6f8fa;">Metric</th>
              <th style="text-align:left; border:1px solid #d0d7de; padding:8px; background:#f6f8fa;">Value</th>
            </tr>
            <tr>
              <td style="border:1px solid #d0d7de; padding:8px;">Free Memory</td>
              <td style="border:1px solid #d0d7de; padding:8px;">2.1 GB</td>
            </tr>
            <tr>
              <td style="border:1px solid #d0d7de; padding:8px;">Disk Space Free</td>
              <td style="border:1px solid #d0d7de; padding:8px;">18%</td>
            </tr>
            <tr>
              <td style="border:1px solid #d0d7de; padding:8px;">CPU Load</td>
              <td style="border:1px solid #d0d7de; padding:8px;">76%</td>
            </tr>
          </table>
        </td>
        <td style="width:50%; vertical-align:top;">
          <h2 style="font-size:16px; margin:0 0 8px 0;">📈 After Cleanup</h2>
          <table style="width:100%; border-collapse:collapse;">
            <tr>
              <th style="text-align:left; border:1px solid #d0d7de; padding:8px; background:#f6f8fa;">Metric</th>
              <th style="text-align:left; border:1px solid #d0d7de; padding:8px; background:#f6f8fa;">Value</th>
            </tr>
            <tr>
              <td style="border:1px solid #d0d7de; padding:8px;">Free Memory</td>
              <td style="border:1px solid #d0d7de; padding:8px;">5.4 GB</td>
            </tr>
            <tr>
              <td style="border:1px solid #d0d7de; padding:8px;">Disk Space Free</td>
              <td style="border:1px solid #d0d7de; padding:8px;">42%</td>
            </tr>
            <tr>
              <td style="border:1px solid #d0d7de; padding:8px;">CPU Load</td>
              <td style="border:1px solid #d0d7de; padding:8px;">29%</td>
            </tr>
          </table>
        </td>
      </tr>
    </table>

    <div style="margin-top:12px; color:#57606a; font-size:13px;">
      <em>Cleanup actions performed: Homebrew cleanup, cache purge, log cleanup, memory flush</em>
    </div>
  </div>
</div>

---

## 🧩 Raw HTML (Copy/Paste Source)
<details>
<summary>Show the exact HTML your script writes (helpful for local previews)</summary>

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>System Status Report</title>
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
