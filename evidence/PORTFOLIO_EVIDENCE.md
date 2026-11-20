# Sanitized Portfolio Evidence

Environment: Kali Linux Rolling 2026.1 in VMware Workstation
Test date: 2026-11-20

## Security baseline

    [PASS] Running as a non-root account.
    [PASS] systemd is running.
    [PASS] UFW is active with default-deny incoming and allow-outgoing policies.
    [PASS] Fail2ban is active with the SSHD jail loaded.
    [PASS] SSH root login is disabled.
    [PASS] SSH permits public-key authentication only.
    [PASS] Unneeded Apache service is disabled and stopped.
    [PASS] SSH remains disabled pending public-key access verification.

    Summary: 8 passed, 0 warnings, 0 failed.

## Network validation

- Inbound: a temporary TCP listener was started on the guest and tested from the Windows host. The connection was blocked by the guest firewall. The listener was stopped and the port was verified closed.
- Outbound: DNS resolution succeeded and an HTTPS request to the Kali website returned HTTP/2 200.
- Scope: these tests validate the specific tested path and destination, not every network route or firewall interaction.

## Service and policy validation

- Apache: disabled/inactive; no TCP port 80 listener.
- UFW: active; incoming deny, outgoing allow, routed deny.
- Fail2ban: active; SSHD jail loaded.
- SSH: public-key-only policy syntax and effective settings validated; service intentionally disabled pending a client-key login test.
- MariaDB: loopback-only listener.
- Docker: daemon active; user remains in docker group as an accepted, documented root-equivalent privilege.

## Backup validation

The sample backup/restore test passed. The restored file content matched the source, and file mode 0600 was preserved.

## APT maintenance review

- Active repository: Kali Rolling only.
- APT metadata refresh: successful.
- Simulated transaction: 2,242 upgrades, 180 new packages, 14 removals, 7 held back.
- Actual upgrade: not performed.
- VMware snapshot: deferred because the VM storage volume had insufficient free space.

Raw command outputs are retained locally and excluded from public Git to avoid disclosing host-specific inventory.
