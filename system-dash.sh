
#!/usr/bin/env bash
# macOS System Health Dashboard + Speed Toolkit (Bash 3.2 compatible)
# - Live CPU/MEM/DISK/NET
# - Safe speed-ups: kill heavy tasks, clean caches, flush DNS, Brew cleanup, Docker prune, manage login items, Spotlight tools, npm cache, optional purge
# - Persistent confirmations via STATUS banner + ~/system-dash.log + (best-effort) macOS notifications
# - NEW: Export before/after stats to an HTML dashboard (~/system-dash.html)

set -u

# ----------------- globals -----------------
LOG_FILE="${HOME}/system-dash.log"
LAST_STATUS=""
LAST_BEFORE=""
LAST_AFTER=""

NET_IF=""
RX0=0
TX0=0
TS0=0

# ----------------- helpers -----------------
has() { command -v "$1" >/dev/null 2>&1; }

human() {
  local b=${1:-0} s=0
  local S=(B KB MB GB TB)
  while [ "$b" -gt 1024 ] && [ "$s" -lt 4 ]; do b=$((b/1024)); s=$((s+1)); done
  echo "$b ${S[$s]}"
}

ts() { date +"%Y-%m-%d %H:%M:%S"; }

log() {
  printf "[%s] %s\n" "$(ts)" "$1" | tee -a "$LOG_FILE" >/dev/null
}

notify() {
  LAST_STATUS="$1"
  log "$1"
  osascript -e "display notification \"${1}\" with title \"System Dashboard\"" >/dev/null 2>&1 || true
}

pause() { read -r -p "Press Enter to continue..."; }

confirm() {
  read -r -p "$1 [y/N] " ans
  ans_l=$(printf '%s' "${ans:-}" | tr '[:upper:]' '[:lower:]')
  [ "$ans_l" = "y" ] || [ "$ans_l" = "yes" ]
}

disk_free_kb() { df -k / | awk 'NR==2{print $4}'; }

# ----------------- metrics -----------------
cpu_usage() {
  local line idle used
  line=$(top -l 1 -n 0 2>/dev/null | awk '/CPU usage/ {print}')
  idle=$(echo "$line" | awk -F',' '{print $3}' | awk '{print $1}' | tr -d '%')
  [ -z "$idle" ] && { echo "0.0"; return; }
  used=$(awk -v i="$idle" 'BEGIN {print 100 - i}')
  printf "%.1f" "$used"
}

mem_usage() {
  local pagesize free active inactive wired compressed total used_gb total_gb
  pagesize=$(vm_stat 2>/dev/null | awk '/page size of/ {print $8}')
  [ -z "$pagesize" ] && pagesize=4096
  free=$(vm_stat 2>/dev/null | awk '/Pages free/ {print $3}' | tr -d '.')
  active=$(vm_stat 2>/dev/null | awk '/Pages active/ {print $3}' | tr -d '.')
  inactive=$(vm_stat 2>/dev/null | awk '/Pages inactive/ {print $3}' | tr -d '.')
  wired=$(vm_stat 2>/dev/null | awk '/Pages wired/ {print $4}' | tr -d '.')
  compressed=$(vm_stat 2>/dev/null | awk '/Pages occupied by compressor/ {print $6}' | tr -d '.')
  total=$((free+active+inactive+wired+compressed))
  used_gb=$(awk -v a="$active" -v i="$inactive" -v w="$wired" -v c="$compressed" -v p="$pagesize" \
            'BEGIN {print ( (a+i+w+c)*p )/1024/1024/1024 }')
  total_gb=$(awk -v t="$total" -v p="$pagesize" 'BEGIN {print (t*p)/1024/1024/1024}')
  printf "%.1f/%.1f GB" "$used_gb" "$total_gb"
}

disk_usage() { df -H / | awk 'NR==2{print $3" used / "$2" ("$5" full)"}'; }

net_speed_init() {
  NET_IF=$(route get default 2>/dev/null | awk '/interface:/{print $2}')
  [ -z "$NET_IF" ] && NET_IF=$(ifconfig -l | awk '{print $1}')
  RX0=$(netstat -ib | awk -v IF="$NET_IF" '$1==IF && $0 !~ /Link/ {print $7; exit}')
  TX0=$(netstat -ib | awk -v IF="$NET_IF" '$1==IF && $0 !~ /Link/ {print $10; exit}')
  TS0=$(date +%s)
  [ -z "${RX0:-}" ] && RX0=0
  [ -z "${TX0:-}" ] && TX0=0
}

net_speed_now() {
  local rx tx ts dt drx dtx down up downi upi
  rx=$(netstat -ib | awk -v IF="$NET_IF" '$1==IF && $0 !~ /Link/ {print $7; exit}')
  tx=$(netstat -ib | awk -v IF="$NET_IF" '$1==IF && $0 !~ /Link/ {print $10; exit}')
  [ -z "${rx:-}" ] && rx=$RX0
  [ -z "${tx:-}" ] && tx=$TX0
  ts=$(date +%s)
  dt=$((ts-TS0)); [ "$dt" -lt 1 ] && dt=1
  drx=$((rx-RX0)); dtx=$((tx-TX0))
  downi=$(awk -v b="$drx" -v d="$dt" 'BEGIN{print (b/d)}')
  upi=$(awk -v b="$dtx" -v d="$dt" 'BEGIN{print (b/d)}')
  down=$(printf '%.0f' "$downi"); up=$(printf '%.0f' "$upi")
  echo "$(human "$down")/s ↓  $(human "$up")/s ↑"
  RX0=$rx; TX0=$tx; TS0=$ts
}

top_hogs() {
  echo "Top CPU processes:"
  ps -Ao pid,pcpu,pmem,comm -r | head -n 11
}

# ----------------- HTML Report -----------------
export_report() {
  local html="${HOME}/system-dash.html"
  cat > "$html" <<EOF2
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8"/>
<title>System Dashboard Report</title>
<style>
  body { font-family: Arial, sans-serif; margin: 20px; background: #f4f4f4; }
  h1 { color: #333; }
  table { border-collapse: collapse; width: 100%; background: white; }
  th, td { border: 1px solid #ccc; padding: 8px; text-align: center; }
  th { background: #eee; }
</style>
</head>
<body>
  <h1>System Dashboard Report</h1>
  <p>Generated at: $(ts)</p>
  <table>
    <tr><th>Metric</th><th>Before</th><th>After</th></tr>
    <tr><td>CPU Usage</td><td>${LAST_BEFORE_CPU:-N/A}</td><td>${LAST_AFTER_CPU:-N/A}</td></tr>
    <tr><td>Memory Usage</td><td>${LAST_BEFORE_MEM:-N/A}</td><td>${LAST_AFTER_MEM:-N/A}</td></tr>
    <tr><td>Disk Usage</td><td>${LAST_BEFORE_DISK:-N/A}</td><td>${LAST_AFTER_DISK:-N/A}</td></tr>
  </table>
  <p>Status: ${LAST_STATUS:-N/A}</p>
</body>
</html>
EOF2
  open "$html" >/dev/null 2>&1 || notify "HTML report saved to $html"
}

capture_before() {
  LAST_BEFORE_CPU="$(cpu_usage)%"
  LAST_BEFORE_MEM="$(mem_usage)"
  LAST_BEFORE_DISK="$(disk_usage)"
}
capture_after() {
  echo "Cooling down for accurate post-action stats..."
  sleep 5
  LAST_AFTER_CPU="$(cpu_usage)%"
  LAST_AFTER_MEM="$(mem_usage)"
  LAST_AFTER_DISK="$(disk_usage)"
}

# ----------------- actions -----------------
kill_heavy() {
  capture_before
  top_hogs
  read -r -p "Enter PID to kill (or blank to cancel): " pid
  [ -z "${pid:-}" ] && { notify "Kill cancelled."; pause; return; }
  if confirm "Kill PID $pid?"; then
    kill -15 "$pid" 2>/dev/null || true
    sleep 1
    if ps -p "$pid" >/dev/null 2>&1; then kill -9 "$pid" 2>/dev/null || true; fi
    notify "Process $pid terminated (if it was running)."
  else
    notify "Kill cancelled."
  fi
  capture_after
  export_report
  pause
}

clean_user_caches() {
  capture_before
  echo "Cleaning caches, logs >5MB, and Trash..."
  if confirm "Proceed with cleanup?"; then
    before=$(disk_free_kb)
    rm -rf ~/Library/Caches/* 2>/dev/null || true
    find ~/Library/Logs -type f -name "*.log" -size +5M -delete 2>/dev/null || true
    rm -rf ~/.Trash/* 2>/dev/null || true
    after=$(disk_free_kb)
    freed_kb=$((after-before)); [ "$freed_kb" -lt 0 ] && freed_kb=0
    notify "Cleanup complete. Freed ~$(human "$freed_kb")."
  else
    notify "Cleanup cancelled."
  fi
  capture_after
  export_report
  pause
}

flush_dns() {
  capture_before
  if confirm "Flush DNS cache? (sudo)"; then
    if sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder; then
      notify "DNS cache flushed."
    else
      notify "DNS flush attempted (check $LOG_FILE)."
    fi
  else
    notify "DNS flush cancelled."
  fi
  capture_after
  export_report
  pause
}

brew_cleanup() {
  capture_before
  if ! has brew; then notify "Homebrew not found."; pause; return; fi
  if confirm "Run brew cleanup/autoremove?"; then
    before=$(disk_free_kb)
    brew cleanup -s 2>&1 | tee -a "$LOG_FILE"
    brew autoremove -y 2>&1 | tee -a "$LOG_FILE" || true
    after=$(disk_free_kb)
    freed_kb=$((after-before)); [ "$freed_kb" -lt 0 ] && freed_kb=0
    notify "Homebrew cleanup done. Freed ~$(human "$freed_kb")."
  else
    notify "Brew cleanup cancelled."
  fi
  capture_after
  export_report
  pause
}

docker_prune() {
  capture_before
  if ! has docker; then notify "Docker not found."; pause; return; fi
  if confirm "Run docker system prune?"; then
    before=$(disk_free_kb)
    docker system prune -a -f 2>&1 | tee -a "$LOG_FILE"
    after=$(disk_free_kb)
    freed_kb=$((after-before)); [ "$freed_kb" -lt 0 ] && freed_kb=0
    notify "Docker prune complete. Freed ~$(human "$freed_kb")."
  else
    notify "Docker prune cancelled."
  fi
  capture_after
  export_report
  pause
}

manage_login_items() {
  osascript -e 'tell application "System Events" to get the name of every login item' 2>/dev/null \
    | sed 's/, /\n/g'
  read -r -p "Type a login item name to remove: " item
  [ -z "${item:-}" ] && { notify "No login item removed."; pause; return; }
  if confirm "Remove login item \"$item\"?"; then
    osascript -e "tell application \"System Events\" to delete login item \"$item\"" 2>/dev/null \
      && notify "Removed \"$item\"." || notify "Could not remove \"$item\"."
  else
    notify "Removal cancelled."
  fi
  pause
}

spotlight_tools() {
  echo "Spotlight options:"
  echo "1) Status  2) Reindex /  3) Disable volume  4) Enable volume"
  read -r -p "Choose [1-4]: " choice_s
  case "$choice_s" in
    1) mdutil -s / | tee -a "$LOG_FILE"; notify "Spotlight status shown." ;;
    2) if confirm "Reindex / ?"; then sudo mdutil -E / | tee -a "$LOG_FILE"; notify "Reindex started."; fi ;;
    3) read -r -p "Volume path: " vol; [ -n "${vol:-}" ] && sudo mdutil -i off "$vol" ;;
    4) read -r -p "Volume path: " vol; [ -n "${vol:-}" ] && sudo mdutil -i on "$vol" ;;
  esac
  pause
}

npm_cache_maint() {
  if ! has npm; then notify "npm not found."; pause; return; fi
  npm cache verify 2>&1 | tee -a "$LOG_FILE"
  if confirm "Also clean npm cache?"; then
    npm cache clean --force 2>&1 | tee -a "$LOG_FILE"
    notify "npm cache cleaned."
  fi
  pause
}

optional_purge_inactive() {
  if ! has purge; then notify "purge not available"; pause; return; fi
  if confirm "Run sudo purge?"; then
    sudo purge 2>/dev/null && notify "Purge done."
  else
    notify "Purge cancelled."
  fi
  pause
}

# ----------------- UI -----------------
draw() {
  clear
  echo "====================== macOS System Dashboard ======================"
  [ -n "${LAST_STATUS:-}" ] && echo "STATUS: $LAST_STATUS | Report: ~/system-dash.html"
  echo "--------------------------------------------------------------------"
  printf "CPU: %s%%  |  MEM: %s  |  DISK: %s\n" "$(cpu_usage)" "$(mem_usage)" "$(disk_usage)"
  printf "NET: %s\n" "$(net_speed_now)"
  echo "--------------------------------------------------------------------"
  top_hogs
  echo "--------------------------------------------------------------------"
  cat <<'MENU'
Actions:
  K) Kill heavy process      C) Clean caches/logs/Trash
  D) Flush DNS               B) Homebrew cleanup
  O) Docker prune            L) Manage Login Items
  S) Spotlight tools         N) npm cache maintenance
  P) Purge inactive caches   Q) Quit
MENU
  printf "Choice: "
}

main() {
  net_speed_init
  while true; do
    draw
    read -r choice
    case "$(echo "$choice" | tr '[:lower:]' '[:upper:]')" in
      K) kill_heavy ;;
      C) clean_user_caches ;;
      D) flush_dns ;;
      B) brew_cleanup ;;
      O) docker_prune ;;
      L) manage_login_items ;;
      S) spotlight_tools ;;
      N) npm_cache_maint ;;
      P) optional_purge_inactive ;;
      Q) clear; exit 0 ;;
    esac
  done
}

# ----------------- gate -----------------
if [ "$(uname)" != "Darwin" ]; then
  echo "This dashboard is macOS-only."
  exit 1
fi

main
