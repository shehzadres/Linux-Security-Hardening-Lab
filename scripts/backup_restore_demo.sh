#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
RUN_DIR="$(mktemp -d "$PROJECT_ROOT/evidence/backup-lab-run.XXXXXX")"
SOURCE_DIR="$RUN_DIR/source"
RESTORE_DIR="$RUN_DIR/restore"
ARCHIVE="$RUN_DIR/lab-backup.tar.gz"

mkdir -p "$SOURCE_DIR" "$RESTORE_DIR"
printf '%s\n' 'sample configuration data for backup and restore validation' > "$SOURCE_DIR/sample.conf"
chmod 600 "$SOURCE_DIR/sample.conf"

tar -czpf "$ARCHIVE" -C "$SOURCE_DIR" .
sha256sum "$ARCHIVE" | tee "$RUN_DIR/archive.sha256"
tar -xzpf "$ARCHIVE" -C "$RESTORE_DIR"

if cmp -s "$SOURCE_DIR/sample.conf" "$RESTORE_DIR/sample.conf"; then
  printf '[PASS] Restored file content matches source.\n'
else
  printf '[FAIL] Restored file content differs.\n' >&2
  exit 1
fi

source_mode="$(stat -c '%a' "$SOURCE_DIR/sample.conf")"
restored_mode="$(stat -c '%a' "$RESTORE_DIR/sample.conf")"
printf 'Source permissions: %s\nRestored permissions: %s\n' "$source_mode" "$restored_mode"

if [ "$source_mode" = "$restored_mode" ]; then
  printf '[PASS] File permissions were preserved.\n'
else
  printf '[FAIL] File permissions were not preserved.\n' >&2
  exit 1
fi

printf 'Backup validation artifacts: %s\n' "$RUN_DIR"