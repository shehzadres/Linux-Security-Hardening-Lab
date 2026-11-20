#!/usr/bin/env bash
set -euo pipefail
umask 077

if [[ "$(id -u)" -ne 0 ]]; then
  printf 'Run this utility from an authenticated root shell: sudo %s\n' "$0" >&2
  exit 1
fi

BACKUP_DIR="/var/backups/linux-security-lab"
STAMP="$(date +%Y%m%dT%H%M%S%z)"
ARCHIVE="$BACKUP_DIR/system-config-$STAMP.tar.gz"
CHECKSUM="$ARCHIVE.sha256"

set -- \
  etc/fstab \
  etc/ssh/sshd_config \
  etc/ssh/sshd_config.d/99-lab-hardening.conf \
  etc/ufw \
  etc/fail2ban/jail.d/sshd.local \
  etc/sudoers.d/linux-lab-admin \
  etc/apt/sources.list \
  etc/apt/sources.list.d/kali-old.list.disabled

for item do
  if [[ ! -e "/$item" ]]; then
    printf 'Required configuration path is missing: /%s\n' "$item" >&2
    exit 2
  fi
done

install -d -o root -g root -m 0700 "$BACKUP_DIR"
tar --create --gzip --file="$ARCHIVE" --directory=/ --numeric-owner "$@"
chown root:root "$ARCHIVE"
chmod 0600 "$ARCHIVE"

tar --list --gzip --file="$ARCHIVE" >/dev/null
sha256sum "$ARCHIVE" > "$CHECKSUM"
chown root:root "$CHECKSUM"
chmod 0600 "$CHECKSUM"
sha256sum --check "$CHECKSUM"

printf 'Backup archive: %s\n' "$ARCHIVE"
printf 'Checksum file: %s\n' "$CHECKSUM"
printf 'Archive mode: %s\n' "$(stat -c '%a' "$ARCHIVE")"
printf 'Backup directory mode: %s\n' "$(stat -c '%a' "$BACKUP_DIR")"
