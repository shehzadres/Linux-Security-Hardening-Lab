#!/usr/bin/env bash
set -u

pass=0
warn=0
fail=0
pass_check() { printf '[PASS] %s\n' "$1"; pass=$((pass + 1)); }
warn_check() { printf '[WARN] %s\n' "$1"; warn=$((warn + 1)); }
fail_check() { printf '[FAIL] %s\n' "$1"; fail=$((fail + 1)); }

printf 'Linux Security Baseline Checks\n'
printf 'Host: %s\n' "$(hostname 2>/dev/null || printf unknown)"
printf 'Timestamp: %s\n' "$(date -Is 2>/dev/null || date)"

if [ "$(id -u)" -eq 0 ]; then
  warn_check "Running as root; use a named administrative account for routine work."
else
  pass_check "Running as a non-root account."
fi

if command -v systemctl >/dev/null 2>&1 && systemctl is-system-running >/dev/null 2>&1; then
  pass_check "systemd is running."
else
  warn_check "systemd is degraded, starting, or otherwise not reporting running."
fi

audit_file="$(mktemp)"
trap 'rm -f "$audit_file"' EXIT
admin_audit=0
if command -v sudo >/dev/null 2>&1 && sudo -n /usr/local/sbin/lab-admin audit >"$audit_file" 2>/dev/null; then
  admin_audit=1
fi

if [ "$admin_audit" -eq 1 ]; then
  if grep -q '^Status: active$' "$audit_file" && grep -q 'Default: deny (incoming), allow (outgoing)' "$audit_file"; then
    pass_check "UFW is active with default-deny incoming and allow-outgoing policies."
  else
    fail_check "UFW is not active or its baseline policy is not confirmed."
  fi

  if grep -Eq '^fail2ban[[:space:]]+enabled=enabled$' "$audit_file" &&
     grep -Eq '^fail2ban[[:space:]]+active=active$' "$audit_file" &&
     grep -Eq 'Jail list:.*sshd' "$audit_file"; then
    pass_check "Fail2ban is active with the SSHD jail loaded."
  else
    fail_check "Fail2ban service or SSHD jail is not confirmed active."
  fi

  if grep -q '^permitrootlogin no$' "$audit_file"; then
    pass_check "SSH root login is disabled."
  else
    fail_check "SSH root login is not confirmed disabled."
  fi

  if grep -q '^passwordauthentication no$' "$audit_file" &&
     grep -q '^kbdinteractiveauthentication no$' "$audit_file" &&
     grep -q '^authenticationmethods publickey$' "$audit_file"; then
    pass_check "SSH permits public-key authentication only."
  else
    fail_check "SSH authentication is not restricted to public keys."
  fi

  if grep -Eq '^apache2[[:space:]]+enabled=disabled$' "$audit_file" &&
     grep -Eq '^apache2[[:space:]]+active=inactive$' "$audit_file"; then
    pass_check "Unneeded Apache service is disabled and stopped."
  else
    warn_check "Apache service is not confirmed disabled and stopped."
  fi

  if grep -Eq '^ssh[[:space:]]+enabled=disabled$' "$audit_file" &&
     grep -Eq '^ssh[[:space:]]+active=inactive$' "$audit_file"; then
    pass_check "SSH remains disabled pending public-key access verification."
  else
    warn_check "SSH service is enabled; confirm key-based access and console recovery."
  fi
else
  warn_check "Restricted administrative audit unavailable; privileged controls could not be verified."
  if command -v ufw >/dev/null 2>&1; then
    if ufw status 2>/dev/null | grep -qi 'Status: active'; then pass_check "UFW is active."; else warn_check "UFW is installed but not confirmed active."; fi
  else
    warn_check "UFW is not installed."
  fi
  if command -v fail2ban-client >/dev/null 2>&1 && fail2ban-client ping 2>/dev/null | grep -qi pong; then
    pass_check "Fail2ban client responds."
  else
    warn_check "Fail2ban service did not respond or could not be queried."
  fi
fi

printf '\nSummary: %s passed, %s warnings, %s failed\n' "$pass" "$warn" "$fail"
printf 'Educational baseline only; this is not a complete security assessment.\n'
[ "$fail" -eq 0 ]
