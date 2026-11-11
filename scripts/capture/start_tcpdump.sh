#!/usr/bin/env bash
# Captures the traffic on the host-only interface.
# Usage: sudo ./start_tcpdump.sh [interface] [target_dir]
set -euo pipefail

INTERFACE="${1:-enp0s3}"
OUT_DIR="${2:-results/raw}"
STAMP="$(date +%Y%m%d_%H%M%S)"

mkdir -p "$OUT_DIR"

echo "Starting tcpdump on interface $INTERFACE -> $OUT_DIR/capture_$STAMP.pcap (Ctrl+C to stop)"
tcpdump -i "$INTERFACE" -w "$OUT_DIR/capture_$STAMP.pcap" net 192.168.56.0/24
