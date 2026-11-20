# Restricted Administrative Automation

## Purpose

Provide a narrow, non-interactive administrative interface for repeatable lab operations without transmitting the user's password or granting a general root shell.

## Installed components

- Root-owned executable: /usr/local/sbin/lab-admin
- Sudoers rule: /etc/sudoers.d/linux-lab-admin
- Project source: scripts/lab-admin.sh
- Action log: /var/log/linux-security-lab-admin.log

The executable is root-owned with mode 0755. The sudoers drop-in is root-owned with mode 0440. The deployed wrapper and project source have matching SHA-256 checksums.

## Deployed approved actions

Invoke with sudo -n /usr/local/sbin/lab-admin ACTION.

| Action | Effect |
|---|---|
| audit | Read-only system, service, listener, firewall, and SSH summary |
| apache-disable | Stop and disable Apache |
| security-tools-install | Refresh APT metadata and install UFW and Fail2ban |
| firewall-status | Display UFW status |
| firewall-baseline | Apply deny-incoming/allow-outgoing policy and enable UFW |
| fail2ban-enable | Install reviewed SSH jail configuration, validate, and enable Fail2ban |
| ssh-harden-configure | Install the reviewed SSH drop-in and validate the daemon configuration without starting SSH |
| fstab-repair-header | Back up and repair the known malformed template header if present, then reload systemd and validate mounts |
| ssh-status | Display SSH service and port 22 listener state |

The wrapper accepts exactly one action name. It does not accept arbitrary shell commands, paths, package names, service names, or user-supplied command arguments. Unrecognized actions are rejected. Every accepted action is logged.

## Security boundary and limitation

The sudoers rule permits passwordless execution of this one root-owned wrapper, not a general root shell. General sudo -n id remains denied because it requires authentication.

The kali account remains in the docker group at the user's request. Access to a rootful Docker daemon is effectively root-equivalent because a Docker-group user can create privileged containers and mount host filesystems. The restricted sudo rule is therefore not a complete privilege boundary while Docker socket access remains available.

No Docker membership change has been made. Revisit rootless Docker or group removal only after reviewing workflow impact and obtaining approval.

## Verified behavior

- Approved audit and firewall status actions succeeded.
- An unapproved shell action was rejected.
- General sudo remains password-protected.
- Apache was disabled through the wrapper.
- UFW baseline was applied through the wrapper.
- Fail2ban was enabled and its SSHD jail verified.
- SSH hardening configuration passed privileged syntax validation; SSH remains disabled.
- The fstab repair action confirmed the malformed template line was already commented and reloaded systemd. Mount verification reported zero parse errors and zero errors, with one warning for the active swapfile source.
- Project source and deployed wrapper SHA-256 checksums match.

## Operational rule

Add new capabilities only as fixed, reviewed actions. Do not add wildcard command execution, arbitrary file writes, generic package arguments, arbitrary service names, or a passwordless shell. Validate shell syntax and compare the project source with the deployed executable after any approved update.
