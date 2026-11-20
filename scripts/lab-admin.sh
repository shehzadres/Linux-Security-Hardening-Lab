#!/bin/sh
set -eu
umask 077
LOG_FILE="/var/log/linux-security-lab-admin.log"
log_action() { printf '%s actor=%s action=%s\n' "$(date -Is)" "${SUDO_USER:-unknown}" "$1" >> "$LOG_FILE"; }
require_root() { [ "$(id -u)" -eq 0 ] || { echo "Run through sudo." >&2; exit 1; }; }
usage() {
cat <<'USAGE'
Usage: sudo -n /usr/local/sbin/lab-admin ACTION
Approved actions:
  audit                    Read-only system, service, firewall and SSH inventory
  apache-disable           Stop and disable Apache
  security-tools-install   Install UFW and Fail2ban from configured APT sources
  firewall-status          Display UFW status
  firewall-baseline        Set deny-incoming/allow-outgoing and enable UFW
  fail2ban-enable          Install reviewed SSH jail config, validate and enable Fail2ban
  ssh-harden-configure     Install SSH hardening drop-in and validate; does not start SSH
  fstab-repair-header      Back up/fix the known malformed fstab template header and reload systemd
  ssh-status               Display SSH service and port 22 listener status
USAGE
}
require_root
[ "$#" -eq 1 ] || { usage; exit 2; }
case "$1" in
audit)
 log_action audit
 echo '=== OS ==='; cat /etc/os-release
 echo '=== Services ==='
 for service in apache2 ssh ufw fail2ban docker mariadb; do
   printf '%-12s enabled=' "$service"; systemctl is-enabled "$service" 2>/dev/null || true
   printf '%-12s active=' "$service"; systemctl is-active "$service" 2>/dev/null || true
 done
 echo '=== Listening sockets ==='; ss -tulpn
 echo '=== Firewall ==='
 if command -v ufw >/dev/null 2>&1; then ufw status verbose; else echo 'UFW not installed'; fi
 echo '=== Fail2ban jails ==='
 if command -v fail2ban-client >/dev/null 2>&1; then fail2ban-client status 2>&1 || true; else echo 'Fail2ban not installed'; fi
 echo '=== SSH effective configuration summary ==='
 if [ -x /usr/sbin/sshd ]; then /usr/sbin/sshd -T 2>/dev/null | grep -E '^(port|listenaddress|permitrootlogin|passwordauthentication|kbdinteractiveauthentication|pubkeyauthentication|authenticationmethods|allowusers|maxauthtries) ' || true; else echo 'sshd not installed'; fi
 ;;
apache-disable)
 log_action apache-disable
 systemctl disable --now apache2
 systemctl is-enabled apache2 2>&1 || true
 systemctl is-active apache2 2>&1 || true
 ;;
security-tools-install)
 log_action security-tools-install
 apt-get update
 DEBIAN_FRONTEND=noninteractive apt-get install -y ufw fail2ban
 ;;
firewall-status)
 log_action firewall-status
 command -v ufw >/dev/null 2>&1 || { echo 'UFW not installed'; exit 3; }
 ufw status verbose
 ;;
firewall-baseline)
 log_action firewall-baseline
 command -v ufw >/dev/null 2>&1 || { echo 'UFW not installed'; exit 3; }
 ufw default deny incoming
 ufw default allow outgoing
 ufw --force enable
 ufw status verbose
 ;;
fail2ban-enable)
 log_action fail2ban-enable
 command -v fail2ban-client >/dev/null 2>&1 || { echo 'Fail2ban not installed'; exit 3; }
 CONFIG_SOURCE="/home/kali/Linux-Security-Hardening-Lab/configs/fail2ban/sshd.local"
 [ -f "$CONFIG_SOURCE" ] || { echo "Reviewed SSH jail configuration missing: $CONFIG_SOURCE" >&2; exit 4; }
 install -o root -g root -m 0644 "$CONFIG_SOURCE" /etc/fail2ban/jail.d/sshd.local
 fail2ban-client -t
 systemctl enable --now fail2ban
 i=0
 until fail2ban-client ping >/dev/null 2>&1; do
   i=$((i + 1))
   [ "$i" -lt 10 ] || { echo 'Fail2ban daemon did not become ready.' >&2; exit 5; }
   sleep 1
 done
 fail2ban-client status
 fail2ban-client status sshd
 ;;
ssh-harden-configure)
 log_action ssh-harden-configure
 CONFIG_SOURCE="/home/kali/Linux-Security-Hardening-Lab/configs/ssh/99-lab-hardening.conf"
 [ -f "$CONFIG_SOURCE" ] || { echo "Reviewed SSH configuration missing: $CONFIG_SOURCE" >&2; exit 4; }
 install -o root -g root -m 0644 "$CONFIG_SOURCE" /etc/ssh/sshd_config.d/99-lab-hardening.conf
 /usr/sbin/sshd -t
 echo 'SSH configuration syntax: PASS'
 /usr/sbin/sshd -T | grep -E '^(port|permitrootlogin|passwordauthentication|kbdinteractiveauthentication|pubkeyauthentication|authenticationmethods|allowusers|maxauthtries|x11forwarding|allowtcpforwarding) '
 echo 'SSH service intentionally remains disabled until key-based access is verified.'
 ;;
fstab-repair-header)
 log_action fstab-repair-header
 [ -f /etc/fstab ] || { echo '/etc/fstab not found.' >&2; exit 4; }
 line_two="$(sed -n '2p' /etc/fstab)"
 case "$line_two" in
   options\>*)
     install -d -o root -g root -m 0755 /var/backups
     backup="/var/backups/fstab.pre-lab-hardening.$(date +%Y%m%d%H%M%S)"
     cp -a /etc/fstab "$backup"
     sed -i '2s/^/# /' /etc/fstab
     echo "Backup created: $backup"
     echo 'Corrected malformed line 2 by commenting out the stray template fragment.'
     systemctl daemon-reload
     findmnt --verify --tab-file /etc/fstab
     ;;
   '# options>'*)
     echo 'The malformed template fragment is already commented; reloading systemd.'
     systemctl daemon-reload
     findmnt --verify --tab-file /etc/fstab
     ;;
   *)
     echo 'The known malformed line 2 pattern was not present; no changes made.'
     exit 6
     ;;
 esac
 ;;
ssh-status)
 log_action ssh-status
 systemctl status ssh --no-pager 2>&1 || true
 ss -ltnp | grep -E '(:22[[:space:]]|:22$)' || true
 ;;
*)
 printf 'Action not allowed: %s\n' "$1" >&2
 usage
 exit 2
 ;;
esac
