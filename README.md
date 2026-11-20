# Linux Security Hardening Lab

An evidence-led Linux administration and defensive hardening project built on a Kali Linux virtual machine. It demonstrates service reduction, host firewall policy, SSH hardening, Fail2ban, restricted administrative automation, backup validation, and repeatable security checks.

## Environment

- Kali GNU/Linux Rolling 2026.1
- Linux kernel 6.18.12+kali-amd64, x86_64
- VMware Workstation
- systemd and APT
- Administrative account: kali, used as a non-root account for normal work

Kali is a Debian-based penetration-testing distribution. This project documents the actual lab environment rather than presenting it as a production Ubuntu or Debian server.

## Implemented controls

- Apache was stopped and disabled after confirming it was not required. TCP port 80 was verified closed.
- UFW is active with default-deny incoming and default-allow outgoing policy.
- A Windows-host-to-guest test confirmed that an unsolicited connection to a temporary guest listener was blocked.
- Outbound DNS resolution and HTTPS access were verified.
- Fail2ban is enabled and its SSHD jail is loaded.
- SSH policy requires public-key authentication, disables root/password/keyboard-interactive login, limits attempts, and disables forwarding. The SSH service remains disabled until a protected client key is provisioned and tested.
- MariaDB is bound to loopback.
- A restricted, root-owned administrative wrapper exposes fixed reviewed actions. General sudo remains password-protected.
- Backup/restore demonstration verified archive extraction, content equality, and preservation of file mode.
- A repeatable baseline test currently reports 8 passed, 0 warnings, 0 failures.

## APT maintenance

The additional kali-last-snapshot source was disabled and preserved as a rollback file. APT metadata refresh against kali-rolling succeeded.

A non-destructive apt-get -s dist-upgrade simulation reported:

- 2,242 upgrades
- 180 newly installed packages
- 14 package removals
- 7 packages kept back

The removals include several ABI transitions with replacement packages in the same plan, plus a package rename/removal in the NetworkManager desktop integration. No real upgrade or autoremove has been performed. Review the full simulation in the local evidence directory before any maintenance window.

## Project layout

- configs/: reviewed SSH, Fail2ban, and APT configuration examples.
- scripts/: system audit, backup/restore demo, restricted admin wrapper source, and system-config backup utility.
- tests/: repeatable security baseline checks.
- docs/: setup, implementation log, findings, maintenance and recovery procedures.
- evidence/PORTFOLIO_EVIDENCE.md: sanitized test summary suitable for public review.
- evidence/command-outputs/: local raw outputs; intentionally excluded from Git because they may contain host-specific information.

## Run the checks

From the project root:

    for f in scripts/*.sh tests/*.sh; do bash -n "$f"; done
    ./scripts/system_audit.sh
    ./tests/check_security_baseline.sh
    ./scripts/backup_restore_demo.sh

The system configuration backup utility requires an authenticated root shell:

    sudo ./scripts/system_config_backup.sh

See docs/RECOVERY_AND_BACKUP.md before restoring any system configuration.

## Current limitations and safety gates

- SSH is intentionally disabled. Do not enable it until a passphrase-protected client key is provisioned, key-only login is verified from the private lab network, and console recovery is available.
- The Windows host currently has only an SSH client config file, not a client key pair. No private key was generated or transferred.
- A VMware snapshot has not been created. The VM is stored on a Windows volume with approximately 3.1 GB free at the last check, which is insufficient headroom for a safe rolling-upgrade snapshot.
- The Kali account remains in the rootful Docker group at the user's request. Docker socket access is effectively root-equivalent and weakens the restricted-sudo boundary.
- The package upgrade simulation is not an approval to upgrade. No full upgrade or autoremove has been run.
- This is an educational lab baseline, not a full security audit, penetration test, or production security certification. Upstream network controls and the Windows host have not been comprehensively assessed.
- Raw command outputs are retained locally and excluded from public Git history. Review and sanitize any additional evidence before publishing.

See docs/PROJECT_PLAN.md for milestone status and docs/FINAL_REVIEW.md for the remaining completion gates.
