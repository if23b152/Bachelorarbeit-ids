#!/usr/bin/env bash
set -euo pipefail

DEST_DIR="${1:-results/raw/logs}"
STAMP="$(date +%Y%m%d_%H%M%S)"

mkdir -p "$DEST_DIR/$STAMP"

echo "Sammle Logs nach $DEST_DIR/$STAMP"

for path in /var/log/snort /var/log/suricata /opt/zeek/logs/current; do
  if [ -d "$path" ]; then
    cp -R "$path" "$DEST_DIR/$STAMP/"
  fi
done
