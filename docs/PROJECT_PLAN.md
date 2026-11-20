# Project Plan and Milestone Status

## Stage 1: Baseline and inventory
- [x] Verify Kali distribution, kernel, architecture, storage, memory, network, and systemd.
- [x] Capture initial system, service, package, and network inventory.
- [x] Review sudoers permissions and Docker-group implications.

## Stage 2: Linux administration
- [x] Review users, groups, sudoers privileges, and Docker-group implications.
- [ ] Practice a dedicated least-privilege lab account.
- [x] Review installed packages, APT sources, systemd services, and system logs.
- [x] Review the pending package-removal list and replacement packages.

## Stage 3: SSH hardening
- [x] Confirm OpenSSH server package and host keys are present.
- [x] Configure public-key-only authentication, disable root/password/keyboard-interactive login, limit attempts, and disable forwarding.
- [x] Validate SSH daemon configuration and effective policy through the restricted admin wrapper.
- [ ] Provision a passphrase-protected client key.
- [ ] Verify key-only login from the Windows host over the private lab network.
- [ ] Add a narrowly scoped firewall rule and enable SSH only after the key test and console recovery check.
- [ ] Create a VMware snapshot before remote-access changes.

## Stage 4: Host protection
- [x] Disable Apache after confirming it was not needed.
- [x] Verify TCP port 80 is no longer listening.
- [x] Apply UFW default-deny incoming and allow-outgoing policy.
- [x] Test inbound filtering from the Windows host against a temporary guest listener.
- [x] Test outbound DNS and HTTPS.
- [x] Enable and validate the Fail2ban SSHD jail.
- [x] Review Docker firewall interaction; no containers are running.

## Stage 5: Logs and recovery
- [x] Inspect authentication and system logs.
- [x] Run sample backup/restore and verify content and file mode.
- [x] Write a root-only system configuration backup utility.
- [x] Document configuration recovery and restore principles.
- [ ] Run the system configuration backup utility from an authenticated root console.

## Stage 6: Package maintenance
- [x] Preserve exact copies and checksums of original APT source files.
- [x] Disable the additional kali-last-snapshot source and preserve it for rollback.
- [x] Refresh APT metadata and confirm kali-rolling is the only active source.
- [x] Run and save a non-destructive dist-upgrade simulation.
- [x] Review all 14 proposed removals and identify replacement packages where applicable.
- [ ] Create a VMware snapshot; currently blocked by insufficient host-volume free space.
- [ ] Obtain separate approval and run a real rolling upgrade.
- [ ] Verify package health and reboot state after any upgrade.

## Stage 7: Evidence and release
- [x] Capture before/after command outputs locally.
- [x] Run final baseline and shell syntax checks.
- [x] Prepare sanitized portfolio evidence.
- [x] Exclude raw host-specific command outputs and local backups from Git.
- [x] Update README and operational documentation.
- [ ] Initialize/validate the local Git repository and configure its remote.
- [ ] Publish the reviewed project to GitHub.

## Current maintenance gates

- Baseline: 8 passed, 0 warnings, 0 failures.
- VMware volume: approximately 3.1 GB free at the last check; snapshot deferred.
- SSH: key-only policy validated; daemon intentionally disabled pending a protected client key and successful connection test.
- APT: rolling-only source active; simulation reports 2,242 upgrades, 180 new packages, 14 removals, and 7 not upgraded. No package changes were performed.
- Docker: membership retained at the user's request; root-equivalent access is documented.
