# Sanitized Portfolio Evidence

Environment: Kali GNU/Linux Rolling 2026.1 in VMware Workstation
Validation date: 2026-11-20
Repository: https://github.com/shehzadres/Linux-Security-Hardening-Lab

## Security baseline

```text
[PASS] Running as a non-root account.
[PASS] systemd is running.
[PASS] UFW is active with default-deny incoming and allow-outgoing policies.
[PASS] Fail2ban is active with the SSHD jail loaded.
[PASS] SSH root login is disabled.
[PASS] SSH permits public-key authentication only.
[PASS] Unneeded Apache service is disabled and stopped.
[PASS] SSH remains disabled pending public-key access verification.

Summary: 8 passed, 0 warnings, 0 failed.
```

This is an eight-check lab baseline, not a comprehensive security scanner.

## Network validation

- **Inbound:** A temporary TCP listener was started on the guest and tested from the Windows host. The connection did not establish under the active UFW policy. The listener was stopped and the port was verified closed.
- **Outbound:** DNS resolution succeeded and an HTTPS request to the Kali website returned HTTP/2 200.
- **Scope:** These results validate the tested host-to-guest TCP path and tested outbound DNS/HTTPS requests, not every network route, protocol, or firewall interaction.

## Service and policy validation

- Apache: disabled/inactive; no TCP port 80 listener.
- UFW: active; incoming deny, outgoing allow, routed deny.
- Fail2ban: active; SSHD jail loaded.
- SSH: public-key-only policy syntax and effective settings validated; service intentionally disabled pending a client-key login test.
- MariaDB: loopback-only listener at the recorded audit.
- Docker: daemon active at the recorded audit; user remains in docker group as an accepted, documented root-equivalent privilege.

## Backup validation

The sample backup/restore test passed. Restored file content matched the source and file mode 0600 was preserved. The separate root-only system configuration backup utility was syntax-checked but has not been executed with authenticated root privileges.

## Post-upgrade validation

The operator confirmed the Kali Rolling upgrade was completed. Follow-up checks recorded:
- dpkg audit: no incomplete package configurations reported.
- systemctl failed: no failed units.
- UFW and Fail2ban: active.
- SSH and Apache: disabled/inactive by design.
- Reboot-required marker: absent at validation time.
- Security baseline: 8 passed, 0 warnings, 0 failures.
- Shell syntax: all five project shell/test scripts passed bash -n.

Limitations: apt-get check could not run from the unprivileged remote session because it could not acquire the dpkg frontend lock. A residual rc package record for libgvc6 was observed and not purged. No VMware snapshot was created before the upgrade, at the operator's direction.

## Evidence handling

Raw command outputs and screenshots are retained only in the local working copy and are excluded from public Git history by ignore rules. This file is the sanitized public-facing summary. Re-review new evidence before committing it.
