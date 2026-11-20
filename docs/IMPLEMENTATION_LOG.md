# Implementation Log

Only record actions that were actually performed. Raw outputs remain under evidence/command-outputs/ and are excluded from public Git by default.

| Date | Activity | Result |
|---|---|---|
| 2026-11-20 | Created project scaffold on Windows and Kali VM | Completed |
| 2026-11-20 | Audited OS, kernel, storage, memory, network, services, packages, users, and privilege boundaries | Completed; initial evidence saved |
| 2026-11-20 | Validated audit, baseline, backup/restore, and admin-wrapper shell syntax | Passed |
| 2026-11-20 | Ran initial baseline | 2 passed, 5 warnings, 0 failures |
| 2026-11-20 | Ran sample backup/restore demonstration | Passed; content and mode 0600 preserved |
| 2026-11-20 | Identified Apache wildcard listener on TCP port 80 | Finding documented |
| 2026-11-20 | Installed restricted root-owned administrative wrapper and sudoers rule | Completed; permissions and authorization tested |
| 2026-11-20 | Disabled Apache after user confirmation | Completed; port 80 listener removed |
| 2026-11-20 | Applied UFW deny-incoming/allow-outgoing policy | Completed; UFW active |
| 2026-11-20 | Tested Windows-host-to-Kali inbound TCP filtering with temporary guest listener | Connection blocked; temporary listener removed |
| 2026-11-20 | Tested outbound DNS and HTTPS | DNS resolved; HTTPS returned HTTP/2 200 |
| 2026-11-20 | Enabled Fail2ban and validated SSHD jail | Passed; one jail loaded |
| 2026-11-20 | Configured SSH key-only policy and validated effective settings | Passed; service intentionally remains disabled |
| 2026-11-20 | Re-ran security baseline | 8 passed, 0 warnings, 0 failures |
| 2026-11-20 | Reviewed APT branches and preserved original source files | Checksummed before-state copies retained |
| 2026-11-20 | Disabled kali-last-snapshot source and refreshed APT metadata | Completed; kali-rolling only |
| 2026-11-20 | Simulated dist-upgrade and reviewed proposed package removals/replacements | 2,242 upgrades, 180 new, 14 removals, 7 held back; no transaction executed |
| 2026-11-20 | Reviewed fstab template header and ran approved repair/validation action | Header already commented; systemd reloaded; 0 parse errors, 0 errors, 1 swapfile warning |
| 2026-11-20 | Aligned project admin-wrapper source with deployed root-owned executable | SHA-256 checksums match |
| 2026-11-20 | Added root-only system configuration backup utility and recovery documentation | Script syntax checked; not executed due authenticated-root requirement |
| 2026-11-20 | Updated README, project plan, findings, APT notes, admin automation, and sanitized evidence | Completed |
| 2026-11-20 | Checked VMware snapshot inventory and host storage | No snapshots; approximately 3.1 GB free, so snapshot deferred |

## Evidence standard

- Preserve actual command output locally.
- Redact private IP addresses, usernames, hostnames, keys, and tokens before publishing.
- Record failed attempts and limitations.
- Do not mark a control as hardened until its effective state and behavior have been verified.
- A simulation is not an executed package transaction.
