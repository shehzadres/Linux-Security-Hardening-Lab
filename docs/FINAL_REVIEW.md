# Final Project Review

Date: 2026-11-20

## Release summary

The Linux Security Hardening Lab is published as a public GitHub repository. The Kali Rolling upgrade was completed by the operator and the documented post-upgrade checks passed. The repository includes setup notes, reviewed configuration examples, operational scripts, a repeatable baseline test, findings, a control matrix, recovery guidance, and sanitized evidence.

Repository: https://github.com/shehzadres/Linux-Security-Hardening-Lab
Default branch: `main`

## Completed and verified

- Kali environment and normal non-root account documented.
- Initial service, network, package, user, and privilege inventory completed.
- Apache disabled after operator confirmation; TCP/80 listener removed.
- UFW active with default-deny incoming, allow-outgoing, and routed-deny policy.
- Inbound filtering tested from Windows host against one temporary guest TCP listener; listener removed after the test.
- Outbound DNS and HTTPS tested successfully.
- Fail2ban active with SSHD jail loaded.
- SSH key-only policy configured; syntax and effective policy validated. SSH daemon remains disabled pending a passphrase-protected client key and successful login test.
- MariaDB loopback binding reviewed.
- Root-owned restricted administrative wrapper deployed; project source matches deployed wrapper; general sudo remains protected.
- Docker group membership retained at operator request and documented as root-equivalent.
- fstab reviewed; validation reported no parse errors or errors and one expected warning for the active swapfile source.
- Sample backup/restore demonstration passed, including content equality and mode 0600 preservation.
- Security baseline passed: 8 passed, 0 warnings, 0 failures.
- APT snapshot source disabled and preserved; Kali Rolling metadata refresh succeeded.
- Operator completed the Kali Rolling upgrade; post-upgrade package audit and service checks recorded.
- README, operational docs, control matrix, sanitized evidence, and public repository prepared.

## Remaining completion gates

| Gate | State | Required next action |
|---|---|---|
| SSH client key and login test | Pending | Provision a passphrase-protected client key, install only its public key, test key-only login from the private lab network |
| Enable SSH | Intentionally deferred | Only after successful key-only login, console recovery check, and narrow firewall rule review |
| System configuration backup run | Pending | Run `sudo ./scripts/system_config_backup.sh` from an authenticated local console and verify archive/checksum |
| Full package consistency check | Not verified | Run `sudo apt-get check` from an authenticated administrative session |
| VMware snapshot | Not created by operator choice | Create a verified recovery point before future high-risk maintenance if storage permits |

## Important security limitations

- Rootful Docker group membership is effectively root-equivalent.
- SSHD policy is configured, but SSH service is not running and key-only access has not been tested.
- Fail2ban's SSHD jail is loaded, but live SSH ban behavior was not tested because SSH is disabled.
- `apt-get check` did not complete in the remote unprivileged session because it could not obtain the dpkg frontend lock.
- A residual `rc` package record for `libgvc6` was observed; no purge was performed.
- No VMware snapshot was created before the completed rolling upgrade, reducing rollback options.
- The Windows host, VMware hypervisor, upstream network, application security, and all possible attack paths have not received a complete assessment.

## Completion assessment

**Portfolio release: published.** The lab's core defensive controls, repeatable checks, documentation, and post-upgrade validation are recorded. Outstanding items are operational hardening and privileged verification gates, not reasons to misrepresent the current state. This is an educational lab implementation, not production security certification.
