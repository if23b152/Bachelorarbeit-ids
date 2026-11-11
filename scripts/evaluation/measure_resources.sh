#!/usr/bin/env bash
# Misst CPU/RAM eines laufenden IDS-Prozesses in festen Intervallen.
# Nutzung: ./measure_resources.sh <suricata|snort|zeek> [sekunden] [intervall]
set -euo pipefail

PROC="${1:?Prozessname angeben (suricata|snort|zeek)}"
DURATION="${2:-60}"
INTERVAL="${3:-5}"
OUT_DIR="${OUT_DIR:-results/processed}"
STAMP="$(date +%Y%m%d_%H%M%S)"
OUT="$OUT_DIR/resources_${PROC}_${STAMP}.csv"

PID="$(pgrep -o -x "$PROC" || true)"
if [ -z "$PID" ]; then
  echo "Kein laufender Prozess '$PROC' gefunden." >&2
  exit 1
fi

mkdir -p "$OUT_DIR"
echo "timestamp,pid,cpu_percent,mem_percent,rss_kb,vsz_kb" > "$OUT"
echo "Messe $PROC (PID $PID) fuer ${DURATION}s -> $OUT"

END=$((SECONDS + DURATION))
while [ "$SECONDS" -lt "$END" ] && kill -0 "$PID" 2>/dev/null; do
  ps -p "$PID" -o pid=,%cpu=,%mem=,rss=,vsz= \
    | awk -v ts="$(date +%H:%M:%S)" '{print ts","$1","$2","$3","$4","$5}' >> "$OUT"
  sleep "$INTERVAL"
done

awk -F, 'NR>1 {c+=$3; m+=$4; r+=$5; n++} END {if (n) printf "Mittel: CPU %.1f %% | MEM %.1f %% | RSS %d KB (%d Messungen)\n", c/n, m/n, r/n, n}' "$OUT"
