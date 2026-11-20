# Project Plan and Milestone Status

This plan records implementation status rather than aspirational completion. Checked items were performed and verified to the extent described; open items remain open.

## Stage 1: Baseline and inventory
- [x] Verify Kali distribution, kernel, architecture, storage, memory, network, and systemd.
- [x] Capture initial system, service, package, and network inventory.
- [x] Review sudoers permissions and Docker-group implications.

## Stage 2: Linux administration
- [x] Review users, groups, sudoers privileges, and Docker-group implications.
- [ ] Practice a dedicated least-privilege lab account.
- [x] Review installed packages, APT sources, systemd services, and system logs.
- [x] Review package-removal proposals before the rolling upgrade.

## Stage 3: SSH hardening
- [x] Confirm OpenSSH server package and host keys are present.
- [x] Configure public-key-only authentication; disable root, password, and keyboard-interactive login; limit attempts; disable forwarding.
- [x] Validate SSH daemon configuration and effective policy through the restricted admin wrapper.
- [ ] Provision a passphrase-protected client key.
- [ ] Verify key-only login from the Windows host over the private lab network.
- [ ] Add a narrow firewall rule and enable SSH only after key test and console recovery check.

## Stage 4: Host protection
- [x] Disable Apache after confirming it was not needed.
- [x] Verify TCP port 80 is no longer listening.
- [x] Apply UFW default-deny incoming, allow-outgoing, and routed-deny policy.
- [x] Test inbound filtering from Windows host against a temporary guest listener.
- [x] Test outbound DNS and HTTPS.
- [x] Enable and validate the Fail2ban SSHD jail.
- [x] Review Docker firewall interaction; no containers were running at the recorded audit.

## Stage 5: Logs and recovery
- [x] Inspect authentication and system logs.
- [x] Run sample backup/restore and verify content and file mode.
- [x] Write a root-only system configuration backup utility.
- [x] Document configuration recovery and restore principles.
- [ ] Run the system configuration backup utility from an authenticated root console.

## Stage 6: Package maintenance
- [x] Preserve exact copies and checksums of original APT source files.
- [x] Disable the additional kali-last-snapshot source and preserve it for reference.
- [x] Refresh APT metadata and confirm Kali Rolling is the only active source.
- [x] Run and save a non-destructive dist-upgrade simulation.
- [x] Review simulated package removals and replacements.
- [x] Operator completed the Kali Rolling upgrade without a VMware snapshot.
- [x] Run post-upgrade dpkg audit, failed-unit, service, reboot-marker, baseline, and shell-syntax checks.
- [ ] Run `sudo apt-get check` from an authenticated session; remote unprivileged attempt could not acquire the dpkg lock.
- [ ] Review residual `rc` package state for `libgvc6` before cleanup.
- [ ] Create and verify a VMware snapshot before a future high-risk maintenance window.

## Stage 7: Evidence and release
- [x] Capture before/after command outputs locally.
- [x] Run final baseline and shell syntax checks.
- [x] Prepare sanitized portfolio evidence.
- [x] Exclude raw host-specific command outputs and local backups from public Git.
- [x] Update README and operational documentation.
- [x] Initialize local Git repository and create reviewed commits.
- [x] Create public GitHub repository and push `main`.
- [x] Verify remote `main` points to the same commit as local HEAD.
- [ ] Continue reviewing new evidence before committing it.

## Current status snapshot

- Baseline: 8 passed, 0 warnings, 0 failures at the recorded post-upgrade check.
- Upgrade: completed by operator; `dpkg --audit` reported no incomplete package configurations.
- Failed systemd units: none at the recorded check.
- UFW and Fail2ban: active.
- SSH: policy hardened, daemon intentionally disabled pending client key and tested access.
- Docker: membership retained at operator request; root-equivalent access is documented.
- Snapshot: not created, by operator choice.
- System config backup: script exists and is syntax-checked; privileged execution remains pending.
- GitHub: public repository at https://github.com/shehzadres/Linux-Security-Hardening-Lab.
