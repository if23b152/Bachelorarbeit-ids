#!/usr/bin/env bash
# Copies the logs of all IDS into a timestamped folder.
# Usage: sudo ./collect_logs.sh [target_dir]
set -euo pipefail

DEST_DIR="${1:-results/raw/logs}"
STAMP="$(date +%Y%m%d_%H%M%S)"

mkdir -p "$DEST_DIR/$STAMP"

echo "Collecting logs into $DEST_DIR/$STAMP"

for path in /var/log/snort /var/log/suricata /opt/zeek/logs/current /opt/zeek-win-test*; do
  if [ -d "$path" ]; then
    cp -R "$path" "$DEST_DIR/$STAMP/"
    echo "  + $path"
  fi
done
