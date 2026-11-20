# Security Control Matrix

This matrix links the lab's main risks to implemented controls, verification evidence, and residual risk. Scope is limited to this Kali VM and the tests actually performed.

| Risk / attack surface | Control implemented | Verification performed | Residual risk / scope |
|---|---|---|---|
| Unneeded web service exposed | Apache stopped and disabled | Service state checked; TCP/80 listener absent | Other services and host-level exposure need separate review |
| Unsolicited inbound traffic | UFW active; default incoming deny; routed deny | Windows host attempted TCP connection to temporary guest listener; connection did not establish | Only that host-to-guest path and test port were verified |
| Required outbound connectivity | UFW default outgoing allow | DNS resolution and HTTPS request succeeded | Egress is not restricted to an allowlist |
| SSH brute-force attempts | Fail2ban active; SSHD jail configured | Service active and jail loaded | SSH daemon is disabled; live ban behavior was not tested |
| Weak SSH authentication | Root, password, keyboard-interactive and forwarding disabled; public-key-only policy | `sshd -t` and effective settings checked | No client key or login test; SSH service remains disabled |
| Excessive root privileges | Fixed-action root-owned wrapper; restricted sudoers drop-in | Allowed and rejected actions tested; ownership/mode inspected | Docker group membership remains root-equivalent; general sudo still requires authentication |
| Database network exposure | MariaDB bound to loopback | Listener inventory reviewed | Application authentication and patch posture not assessed |
| Configuration loss | Sample backup/restore; root-only system backup script | Sample content and mode 0600 verified; backup script syntax/non-root guard checked | Privileged system backup has not been executed; no VM snapshot exists |
| Package repository drift | Kali Rolling selected; extra snapshot source disabled and preserved | APT metadata refresh succeeded; source files checksummed | Rolling repository changes continuously |
| Package/service state after upgrade | Post-upgrade audit and service checks | `dpkg --audit` empty; no failed units; UFW/Fail2ban active; baseline passed | `apt-get check` blocked by dpkg lock permissions; no snapshot; one residual `rc` package |
| Sensitive evidence disclosure | Raw outputs and screenshots ignored by default; sanitized summary published | Tracked-file list and public docs reviewed | Every future file still needs manual review |

## Verification commands

```bash
for f in scripts/*.sh tests/*.sh; do bash -n "$f" || exit 1; done
./scripts/system_audit.sh
./tests/check_security_baseline.sh
./scripts/backup_restore_demo.sh
```

Privileged state checks may require the deployed wrapper or an authenticated administrator. Do not weaken permissions merely to make an audit script report a pass.

## Interpretation

A control is claimed as implemented only when its effective state or behavior was checked. A configuration file alone is not proof of an effective control. Tests are point-in-time observations with limited scope; they are not a substitute for a complete vulnerability assessment, penetration test, or ongoing monitoring.
