# Final Project Review

Date: 2026-11-20

## Completed and verified

- Kali environment identified and documented accurately.
- Initial service and network exposure audited.
- Apache disabled after user confirmation; TCP port 80 no longer listens.
- UFW active with default-deny incoming and default-allow outgoing policy.
- Inbound filtering verified from the Windows host against a temporary guest listener; the listener was removed after the test.
- Outbound DNS and HTTPS connectivity verified.
- Fail2ban active with the SSHD jail loaded.
- SSH key-only policy configured and privileged daemon syntax validation passed. SSH remains disabled because a client key has not been provisioned and tested.
- MariaDB remains bound to loopback.
- Docker group membership retained at the user's request and documented as root-equivalent.
- Restricted admin wrapper deployed; project source now matches the deployed wrapper byte-for-byte.
- fstab template header already commented; systemd reload completed. Mount validation returned zero parse errors and zero errors, with one warning for the active swapfile source.
- Backup/restore demonstration passed.
- Security baseline: 8 passed, 0 warnings, 0 failures.
- APT snapshot source disabled and preserved; rolling-only metadata refresh passed.
- Upgrade simulation reviewed; no actual package changes performed.
- Documentation and sanitized portfolio evidence prepared.

## Remaining completion gates

| Gate | Current state | Why it remains |
|---|---|---|
| VMware snapshot | Blocked | Only about 3.1 GB free on the volume containing the VM; snapshot headroom is inadequate |
| SSH client key and login test | Pending | No client key pair exists on the Windows host; a protected key requires a user-chosen passphrase |
| Enable SSH | Intentionally deferred | Must follow successful key-only login and firewall review |
| Full system config backup run | Pending | Script requires authenticated root; current wrapper does not expose this action |
| Full Kali rolling upgrade | Deferred | 2,242-package simulation; requires snapshot and separate explicit approval |
| GitHub publication | Not performed | Project is being prepared locally; no remote repository was configured |

## Important security limitations

- Rootful Docker group membership is root-equivalent.
- The SSHD Fail2ban jail is configured, but SSH is not running.
- The host, upstream network, and VMware hypervisor have not received a complete security assessment.
- The package simulation is a planning artifact and may change as the rolling repository changes.

## Completion assessment

The defensive baseline and evidence collection are complete. The project is portfolio-ready as a lab implementation with clearly stated limitations. Operational SSH enablement, snapshot-backed package maintenance, and privileged system backup execution remain gated by storage or user-controlled authentication requirements.
