# Configuration Backup and Recovery

## Scope

The project backup demonstration validates archive creation, extraction, content equality, and file-mode preservation using a sample configuration. It does not claim to be a full system backup.

The privileged system configuration backup utility is provided at scripts/system_config_backup.sh. It must be run from an authenticated root shell and creates a root-only archive under /var/backups/linux-security-lab/.

## Create a configuration backup

From the project root, using the local VMware console:

    sudo ./scripts/system_config_backup.sh

The archive includes the lab's relevant configuration state:
- /etc/fstab
- SSH daemon configuration and the lab hardening drop-in
- UFW configuration
- Fail2ban SSH jail configuration
- The lab sudoers drop-in
- Active and preserved APT source files

It deliberately excludes private SSH host keys, user private keys, passwords, and application data.

The script creates a mode-0600 archive and SHA-256 sidecar in a mode-0700 directory. It validates the archive listing and checksum before reporting success.

## Verify and stage a restore

Use the archive path printed by the backup script:

    sudo sha256sum -c /var/backups/linux-security-lab/ARCHIVE.tar.gz.sha256
    sudo install -d -o root -g root -m 0700 /var/backups/linux-security-lab/restore-review
    sudo tar -xzf /var/backups/linux-security-lab/ARCHIVE.tar.gz -C /var/backups/linux-security-lab/restore-review

Replace ARCHIVE.tar.gz with the actual archive filename. Review extracted files before restoring anything.

## Restore principles

1. Use the VMware console, not an unverified SSH session.
2. Restore only the specific file or directory needed.
3. Preserve root ownership and the original file mode.
4. Validate before restarting services:
   - SSH: sshd -t
   - Fail2ban: fail2ban-client -t
   - sudoers: visudo -cf /etc/sudoers.d/linux-lab-admin
   - Firewall: ufw status verbose
   - Mount table: findmnt --verify --tab-file /etc/fstab
5. Keep the previous configuration copy until the service is confirmed healthy.
6. If remote access or networking becomes unstable, use the VMware console and a verified recovery point where available.

Do not blindly extract the archive over /. Review and restore individual paths to avoid overwriting unrelated system changes.

## Current validation status

- Sample backup/restore demonstration: passed; file contents and mode 0600 matched.
- System configuration backup utility: created and syntax-checked; not executed because the current restricted wrapper does not expose a system-backup action and general sudo requires local authentication.
- VMware snapshot: not created before the completed rolling upgrade, at the operator's direction. Create a verified recovery point before future high-risk maintenance where practical.
