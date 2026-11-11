#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

mkdir -p \
  "$ROOT_DIR/results/raw" \
  "$ROOT_DIR/results/processed" \
  "$ROOT_DIR/results/tables" \
  "$ROOT_DIR/results/screenshots"

touch \
  "$ROOT_DIR/results/raw/.gitkeep" \
  "$ROOT_DIR/results/processed/.gitkeep" \
  "$ROOT_DIR/results/tables/.gitkeep" \
  "$ROOT_DIR/results/screenshots/.gitkeep"

echo "Project folders prepared: $ROOT_DIR"
