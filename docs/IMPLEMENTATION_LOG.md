# Implementation Log

Only record actions that were actually performed. Raw outputs remain in the local working copy under `evidence/command-outputs/` and are excluded from public Git by default.

| Date | Activity | Result |
|---|---|---|
| 2026-11-20 | Created project scaffold on Windows and Kali VM | Completed |
| 2026-11-20 | Audited OS, kernel, storage, memory, network, services, packages, users, and privilege boundaries | Completed; initial evidence saved locally |
| 2026-11-20 | Validated audit, baseline, backup/restore, and admin-wrapper shell syntax | Passed |
| 2026-11-20 | Ran initial baseline | 2 passed, 5 warnings, 0 failures |
| 2026-11-20 | Ran sample backup/restore demonstration | Passed; content and mode 0600 preserved |
| 2026-11-20 | Identified Apache wildcard listener on TCP port 80 | Finding documented |
| 2026-11-20 | Installed restricted root-owned administrative wrapper and sudoers rule | Completed; permissions and authorization tested |
| 2026-11-20 | Disabled Apache after operator confirmation | Completed; port 80 listener removed |
| 2026-11-20 | Applied UFW deny-incoming/allow-outgoing policy | Completed; UFW active |
| 2026-11-20 | Tested Windows-host-to-Kali inbound TCP filtering with temporary guest listener | Connection blocked; temporary listener removed |
| 2026-11-20 | Tested outbound DNS and HTTPS | DNS resolved; HTTPS returned HTTP/2 200 |
| 2026-11-20 | Enabled Fail2ban and validated SSHD jail | Passed; one jail loaded |
| 2026-11-20 | Configured SSH key-only policy and validated effective settings | Passed; service intentionally remains disabled |
| 2026-11-20 | Re-ran security baseline | 8 passed, 0 warnings, 0 failures |
| 2026-11-20 | Reviewed APT branches and preserved original source files | Checksummed before-state copies retained |
| 2026-11-20 | Disabled kali-last-snapshot source and refreshed APT metadata | Completed; Kali Rolling only |
| 2026-11-20 | Simulated dist-upgrade and reviewed proposed package removals/replacements | Historical simulation: 2,242 upgrades, 180 new, 14 removals, 7 held back |
| 2026-11-20 | Reviewed fstab template header and ran approved validation action | Header already commented; systemd reloaded; 0 parse errors, 0 errors, 1 swapfile warning |
| 2026-11-20 | Aligned project admin-wrapper source with deployed root-owned executable | SHA-256 checksums matched |
| 2026-11-20 | Added root-only system configuration backup utility and recovery documentation | Script syntax checked; not executed due authenticated-root requirement |
| 2026-11-20 | Checked VMware snapshot inventory and host storage | No snapshot; operator chose to proceed without one |
| 2026-11-20 | Operator completed Kali Rolling upgrade | Confirmed by operator; no snapshot created |
| 2026-11-20 | Ran post-upgrade validation | dpkg audit empty; no failed units; UFW/Fail2ban active; baseline 8/8; no reboot-required marker |
| 2026-11-20 | Attempted unprivileged apt-get check | Could not acquire dpkg frontend lock; not counted as a pass |
| 2026-11-20 | Reviewed dpkg residual package state | libgvc6 showed rc; no purge performed |
| 2026-11-20 | Published repository to GitHub | Public repository created; main pushed and remote SHA verified against local HEAD |
| 2026-11-20 | Expanded public documentation and control matrix | README and operational docs reconciled with post-upgrade and publication state |

## Evidence standard

- Preserve actual command output locally, then redact private IP addresses, usernames, hostnames, keys, tokens, and other identifying data before publication.
- Record failed attempts and limitations; do not turn a blocked command into a successful check.
- Do not mark a control as hardened until its effective state and behavior have been verified.
- A simulation is not an executed package transaction. A configuration file is not proof of an effective control.
- Scope every network test to the source, destination, protocol, and port actually tested.
