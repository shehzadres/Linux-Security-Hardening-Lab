#!/usr/bin/env bash
set -u

section() { printf '\n===== %s =====\n' "$1"; }
run_if_available() {
  local label="$1"; shift
  printf '\n--- %s ---\n' "$label"
  if command -v "$1" >/dev/null 2>&1; then "$@" 2>&1 || true
  else printf 'Not available: %s\n' "$1"; fi
}

section "AUDIT METADATA"
printf 'Timestamp: '; date -Is 2>/dev/null || date
printf 'Host: '; hostname
printf 'Identity: '; id

section "OPERATING SYSTEM"
cat /etc/os-release 2>/dev/null || true
uname -a
uptime

section "RESOURCES AND STORAGE"
free -h 2>/dev/null || true
df -hT 2>/dev/null || df -h
lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINT 2>/dev/null || true

section "NETWORK"
ip -brief address 2>/dev/null || true
ip route 2>/dev/null || true
run_if_available "Listening TCP/UDP sockets" ss -tulpen

section "ACCOUNTS AND PRIVILEGES"
awk -F: '$7 !~ /(nologin|false)$/ {print $1 ":" $3 ":" $7}' /etc/passwd 2>/dev/null || true
getent group sudo 2>/dev/null || true
getent group wheel 2>/dev/null || true

section "SYSTEMD SERVICES"
run_if_available "Running services" systemctl --type=service --state=running --no-pager
run_if_available "SSH service state" systemctl is-active ssh

section "SECURITY CONTROLS"
audit_file="$(mktemp)"
trap 'rm -f "$audit_file"' EXIT
if command -v sudo >/dev/null 2>&1 &&
   sudo -n /usr/local/sbin/lab-admin audit >"$audit_file" 2>&1; then
  printf '%s\n' '--- Restricted privileged security audit ---'
  cat "$audit_file"
else
  printf '%s\n' 'Restricted privileged audit unavailable; following checks may be incomplete for a non-root user.'
  run_if_available "UFW status (may require root)" ufw status verbose
  run_if_available "Fail2ban status (may require root)" fail2ban-client status
  if [ -x /usr/sbin/sshd ]; then
    printf '\n--- SSH daemon effective configuration (root access required) ---\n'
    /usr/sbin/sshd -T 2>&1 || true
  else
    printf 'OpenSSH server binary not available.\n'
  fi
fi

section "PACKAGE MANAGEMENT"
if command -v apt >/dev/null 2>&1; then
  apt list --upgradable 2>/dev/null | sed -n '1,50p'
else
  printf 'APT not available.\n'
fi

section "AUDIT COMPLETE"
printf 'Read-only inventory. Review and redact host/network details before publishing.\n'
