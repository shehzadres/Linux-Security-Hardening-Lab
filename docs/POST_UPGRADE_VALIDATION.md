# Post-Upgrade Validation

Date: 2026-11-20

## Result

The Kali rolling upgrade has been completed by the lab operator. Post-upgrade checks were run against the guest VM.

| Check | Result |
|---|---|
| Kernel | Linux 6.18.12+kali-amd64 |
| System state | running |
| Reboot-required marker | absent at validation time |
| dpkg --audit | no incomplete package configurations reported |
| Failed systemd units | none |
| UFW | active |
| Fail2ban | active |
| SSH service | disabled and inactive by design |
| Apache service | disabled and inactive by design |
| Security baseline | 8 passed, 0 warnings, 0 failures |
| Shell syntax | all 5 project shell/test scripts passed bash -n |

## Limitations

- An unprivileged `apt-get check` attempt was denied access to the dpkg frontend lock. It did not run and is not counted as a successful package-consistency check.
- `dpkg -l` showed one `rc` entry for `libgvc6`, meaning the package is removed while residual configuration files remain. No action was taken.
- No VMware snapshot was created, per the operator's instruction.
- No automatic reboot was initiated. The system did not report a reboot-required marker during this validation.
- SSH remains disabled until a passphrase-protected client key is provisioned, key-only access is tested, and the firewall rule is deliberately added.
- The root-only system configuration backup script has not been run because authenticated root access was not available through the restricted remote session.

## Security posture

The baseline remains intact after the upgrade. UFW and Fail2ban are active. SSH is intentionally unavailable rather than exposing an unverified remote login path. Apache remains disabled because it is not required for this lab.

This validation is a point-in-time lab check, not a complete security assessment.
