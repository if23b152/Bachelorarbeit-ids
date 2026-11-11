#!/usr/bin/env bash
# Zaehlt Alerts bzw. relevante Log-Eintraege der drei IDS.
# Nutzung: ./count_alerts.sh [suricata_log_dir] [snort_alert_file] [zeek_log_dir]
set -euo pipefail

SURICATA_DIR="${1:-/var/log/suricata}"
SNORT_FILE="${2:-/var/log/snort/alert_fast.txt}"
ZEEK_DIR="${3:-.}"

echo "== Suricata ($SURICATA_DIR)"
if [ -f "$SURICATA_DIR/eve.json" ] && command -v jq >/dev/null; then
  jq -r 'select(.event_type=="alert") | .alert.signature' "$SURICATA_DIR/eve.json" | sort | uniq -c | sort -rn
elif [ -f "$SURICATA_DIR/fast.log" ]; then
  sed -E 's/.*\] (.*) \[\*\*\].*/\1/' "$SURICATA_DIR/fast.log" | sort | uniq -c | sort -rn
else
  echo "keine Logs gefunden"
fi

echo
echo "== Snort ($SNORT_FILE)"
if [ -f "$SNORT_FILE" ]; then
  grep -o '"[^"]*"' "$SNORT_FILE" | sort | uniq -c | sort -rn
else
  echo "keine Alert-Datei gefunden (bei Terminal-Ausgabe: snort ... -A alert_fast | tee alert_fast.txt)"
fi

echo
echo "== Zeek ($ZEEK_DIR)"
if [ -f "$ZEEK_DIR/conn.log" ]; then
  echo "conn.log nach conn_state:"
  grep -v '^#' "$ZEEK_DIR/conn.log" | awk -F'\t' '{print $12}' | sort | uniq -c | sort -rn
  for f in ntlm.log smb_mapping.log smb_files.log notice.log; do
    [ -f "$ZEEK_DIR/$f" ] && echo "$f: $(grep -vc '^#' "$ZEEK_DIR/$f") Eintraege"
  done
else
  echo "kein conn.log gefunden"
fi
