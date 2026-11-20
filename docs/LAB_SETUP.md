# Lab Setup and Operating Notes

## Verified environment

- Kali GNU/Linux Rolling 2026.1
- Kernel: 6.18.12+kali-amd64
- Architecture: x86_64
- VMware Workstation virtual machine
- User: kali (UID 1000; sudo group)
- systemd running
- Network interface: eth0

Kali is Debian-based. Use APT and systemd commands where applicable.

## Access model

Normal project work is performed as the unprivileged kali account. A root-owned wrapper at /usr/local/sbin/lab-admin is callable through a narrow sudoers rule. It accepts only fixed action names; general sudo remains password-protected.

The project copy of scripts/lab-admin.sh is kept byte-for-byte aligned with the deployed root-owned wrapper. Verify this before changing the wrapper:

    sha256sum scripts/lab-admin.sh /usr/local/sbin/lab-admin

Do not add wildcard execution, arbitrary paths, arbitrary package arguments, or a general root shell to the wrapper.

## Safe verification

Run from the project root:

    ./scripts/system_audit.sh
    ./tests/check_security_baseline.sh
    ./scripts/backup_restore_demo.sh

The baseline script is an educational check, not a complete security assessment.

## VMware recovery

Before changing SSH, firewall policy, packages, users, or services:

1. Confirm adequate free space on the Windows volume holding the VM.
2. Create a VMware snapshot and verify it appears in the VM snapshot list.
3. Keep the VMware console available during remote-access changes.
4. Preserve a separate backup of configuration files.
5. Restore only reviewed files and validate each service before restarting it.

At the latest review, the VM volume had approximately 3.1 GB free and no snapshots. A snapshot was deliberately not attempted because the available space does not provide safe headroom for a large rolling upgrade.

## Network and SSH safety

- Do not expose SSH to the public internet.
- Keep the firewall default-deny policy.
- SSH remains disabled until a passphrase-protected client key is provisioned and a successful key-only login is verified.
- Do not enable SSH or add an inbound firewall rule merely to make a test pass.
- Docker-published ports may interact with firewall rules independently of UFW.

## Evidence handling

Raw audit outputs can contain usernames, hostnames, private addresses, service details, and package inventory. They remain in the local evidence/command-outputs/ directory and are excluded from Git by default. Publish only reviewed, sanitized evidence.
