#!/usr/bin/env bash
set -euo pipefail

INTERFACE="${1:-eth0}"
OUT_DIR="${2:-results/raw}"
STAMP="$(date +%Y%m%d_%H%M%S)"

mkdir -p "$OUT_DIR"

echo "Starte tcpdump auf Interface $INTERFACE"
tcpdump -i "$INTERFACE" -w "$OUT_DIR/capture_$STAMP.pcap"
