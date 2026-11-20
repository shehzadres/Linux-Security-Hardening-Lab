# Linux Security Hardening Lab

An evidence-led Linux administration and defensive hardening project built on Kali Linux in VMware Workstation. It documents the lab environment, security decisions, implementation, repeatable checks, operational limitations, and post-upgrade validation. This is a reproducible learning and portfolio project, not a production security certification.

**Public repository:** https://github.com/shehzadres/Linux-Security-Hardening-Lab
**Default branch:** `main`
**Platform:** Kali GNU/Linux Rolling, x86_64, systemd, APT, VMware Workstation

## Project at a glance

| Area | Implemented state | Verification and boundary |
|---|---|---|
| Service reduction | Apache stopped and disabled | TCP/80 no longer listening |
| Host firewall | UFW active; deny incoming, allow outgoing, deny routed traffic | One Windows-host-to-guest TCP path tested; outbound DNS/HTTPS tested separately |
| SSH | Public-key-only policy configured; root/password/keyboard-interactive login disabled | Syntax/effective policy checked; daemon intentionally disabled pending protected client key and successful login test |
| Brute-force controls | Fail2ban active with SSHD jail loaded | Service and jail state checked; live attack behavior not tested because SSH is disabled |
| Privileged automation | Root-owned fixed-action wrapper and narrow sudoers rule | Allowed and rejected actions tested; general sudo remains password-protected |
| Database exposure | MariaDB bound to loopback | Listener inventory reviewed |
| Recovery | Sample archive/restore test; root-only system backup utility | Sample content and mode 0600 verified; privileged system backup utility not yet run |
| Repeatability | Audit and baseline scripts | Latest baseline: 8 passed, 0 warnings, 0 failures |
| Package maintenance | Kali Rolling upgrade completed | Post-upgrade package audit and service checks recorded |

## Environment

The lab uses Kali GNU/Linux Rolling 2026.1 in VMware Workstation, with systemd and APT. Post-upgrade validation recorded kernel `6.18.12+kali-amd64`; kernel and package versions can change as Kali Rolling advances. The normal working account is `kali`, not root.

Kali is a Debian-based penetration-testing distribution. This repository documents the actual Kali lab, not a generic production Debian/Ubuntu server.

## Repository map

```text
.
├── README.md
├── configs/                  # Reviewed SSH, Fail2ban and preserved APT examples
├── docs/
│   ├── ADMIN_AUTOMATION.md
│   ├── APT_REPOSITORIES.md
│   ├── ARCHITECTURE.md
│   ├── CONTROL_MATRIX.md
│   ├── FINAL_REVIEW.md
│   ├── IMPLEMENTATION_LOG.md
│   ├── LAB_SETUP.md
│   ├── POST_UPGRADE_VALIDATION.md
│   ├── PROJECT_PLAN.md
│   ├── RECOVERY_AND_BACKUP.md
│   ├── SESSION_SUMMARY.md
│   └── findings.md
├── evidence/
│   └── PORTFOLIO_EVIDENCE.md # Sanitized public evidence summary
├── scripts/
│   ├── backup_restore_demo.sh
│   ├── lab-admin.sh
│   ├── system_audit.sh
│   └── system_config_backup.sh
└── tests/
    └── check_security_baseline.sh
```

Raw command outputs and screenshots are excluded from public Git by default. The local working copy may contain additional evidence; sanitize and review every new artifact before committing it.

## Quick start

Run from the repository root on a compatible Kali/Debian-style Linux system. Read each script before running it on another machine.

```bash
# Syntax-check all project shell scripts without changing system state
for f in scripts/*.sh tests/*.sh; do bash -n "$f" || exit 1; done

# Read-only system inventory
./scripts/system_audit.sh

# Eight-check lab baseline
./tests/check_security_baseline.sh

# Safe sample archive/restore demonstration
./scripts/backup_restore_demo.sh
```

The baseline is a focused set of eight lab assertions, not a comprehensive vulnerability scanner. Some privileged assertions depend on the deployed wrapper at `/usr/local/sbin/lab-admin`; without it, the test falls back to reduced checks and may report warnings.

### System configuration backup

`scripts/system_config_backup.sh` requires authenticated root privileges and writes a root-only archive under `/var/backups/linux-security-lab/`:

```bash
sudo ./scripts/system_config_backup.sh
```

This is separate from the sample backup/restore demonstration. The privileged utility was syntax-checked but has not yet been executed in this lab. See [Recovery and Backup](docs/RECOVERY_AND_BACKUP.md).

## Security design

- **Reduce exposure:** Apache was not required and was disabled. MariaDB remains loopback-bound.
- **Default-deny ingress:** UFW denies unsolicited incoming and routed traffic while allowing outbound connectivity.
- **Do not expose unverified SSH:** The daemon policy is hardened, but SSH remains disabled until a passphrase-protected client key is provisioned, key-only access is tested, and a narrow firewall allowance is deliberately configured.
- **Constrain privileged automation:** The deployed wrapper exposes a fixed allowlist of reviewed operations, not a general root shell.
- **Document privilege trade-offs:** The `kali` account remains in the rootful Docker group by operator choice. Docker socket access is effectively root-equivalent and weakens the restricted-sudo boundary.
- **Separate evidence from secrets:** Raw outputs, screenshots, backups, keys, and runtime artifacts are excluded by default. Only sanitized evidence is committed.

See the [control matrix](docs/CONTROL_MATRIX.md) for risks, controls, verification, and residual limitations.

## Package maintenance and post-upgrade state

The additional `kali-last-snapshot` source was disabled and preserved; Kali Rolling is the active branch. The operator subsequently completed the rolling upgrade. Post-upgrade checks recorded no incomplete package configurations in `dpkg --audit`, no failed systemd units, active UFW and Fail2ban, and a passing baseline.

The unprivileged `apt-get check` attempt could not acquire the dpkg frontend lock and is **not** counted as a successful package consistency check. One `rc` package record (`libgvc6`) indicated residual configuration files after removal; no cleanup was performed. No VMware snapshot was created, per operator instruction. See [APT maintenance](docs/APT_REPOSITORIES.md) and [post-upgrade validation](docs/POST_UPGRADE_VALIDATION.md).

## Documentation guide

| Document | Purpose |
|---|---|
| [Lab setup](docs/LAB_SETUP.md) | Environment, access model, safe operating notes |
| [Architecture](docs/ARCHITECTURE.md) | Components, privileged action flow, trust boundaries |
| [Control matrix](docs/CONTROL_MATRIX.md) | Threats, controls, verification, residual risk |
| [Findings](docs/findings.md) | Findings, remediation decisions, current status |
| [Implementation log](docs/IMPLEMENTATION_LOG.md) | Chronological actions and outcomes |
| [Project plan](docs/PROJECT_PLAN.md) | Milestones and outstanding gates |
| [Admin automation](docs/ADMIN_AUTOMATION.md) | Restricted wrapper and privilege boundary |
| [APT repositories](docs/APT_REPOSITORIES.md) | Repository cleanup and upgrade record |
| [Recovery and backup](docs/RECOVERY_AND_BACKUP.md) | Backup scope and safe restore procedure |
| [Post-upgrade validation](docs/POST_UPGRADE_VALIDATION.md) | Checks run after the rolling upgrade |
| [Final review](docs/FINAL_REVIEW.md) | Release assessment and remaining work |
| [Portfolio evidence](evidence/PORTFOLIO_EVIDENCE.md) | Sanitized evidence summary |

## Current limitations

- Public GitHub repository is published on `main`.
- Latest recorded baseline passed 8/8 checks; this is a point-in-time lab result.
- SSH is intentionally disabled pending protected client-key provisioning and a successful key-only login test.
- The system configuration backup utility has not been run with authenticated root privileges.
- No VMware snapshot exists. The rolling upgrade was completed without one at the operator's direction, reducing rollback protection.
- Docker group membership remains root-equivalent by operator choice.
- `apt-get check` did not complete because the remote unprivileged session could not obtain the package-manager lock.
- This is an educational lab, not a complete security audit, penetration test, production hardening certification, or guarantee against compromise.

## Reproducibility and contribution notes

1. Read the relevant documentation and inspect scripts before running them.
2. Use a disposable VM or verified recovery point before system changes.
3. Do not enable remote access until authentication and recovery paths are tested.
4. Never commit private keys, tokens, unredacted host inventories, raw logs, or private backup archives.
5. Record actual outcomes, including failures. A simulation is not an executed change, and a configuration file is not proof of an effective control.

## License

No license is currently declared. All rights are reserved by default; do not assume the code is licensed for reuse.
