#!/usr/bin/env bash
# Schneidet den Verkehr auf dem Host-Only-Interface mit.
# Nutzung: sudo ./start_tcpdump.sh [interface] [zielordner]
set -euo pipefail

INTERFACE="${1:-enp0s3}"
OUT_DIR="${2:-results/raw}"
STAMP="$(date +%Y%m%d_%H%M%S)"

mkdir -p "$OUT_DIR"

echo "Starte tcpdump auf Interface $INTERFACE -> $OUT_DIR/capture_$STAMP.pcap (Strg+C beendet)"
tcpdump -i "$INTERFACE" -w "$OUT_DIR/capture_$STAMP.pcap" net 192.168.56.0/24
