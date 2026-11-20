# APT Repository Review and Upgrade Record

Date: 2026-11-20
Distribution: Kali GNU/Linux Rolling

## Repository source cleanup

The lab was configured to use the official Kali Rolling branch as its active package source.

- Active source: `/etc/apt/sources.list`
- Disabled additional source: `/etc/apt/sources.list.d/kali-old.list.disabled`
- Preserved before-review copies: `configs/apt/sources.list.before-review` and `configs/apt/kali-old.list.before-review`
- APT metadata refresh against `kali-rolling`: completed successfully

The preserved files are historical before-state copies. Do not copy them back blindly; inspect current Kali repository guidance and the current machine's source configuration first.

## Upgrade planning and execution

An earlier simulation (`apt-get -s dist-upgrade`) reported 2,242 upgrades, 180 new packages, 14 removals, and 7 packages held back. The proposed removals were reviewed before the operator proceeded. This simulation is a historical planning record, not the final transaction manifest.

The VM operator subsequently confirmed that the Kali Rolling upgrade was completed. Available post-upgrade checks reported:

- `dpkg --audit`: no incomplete package configurations reported
- `systemctl --failed`: no failed units
- UFW: active
- Fail2ban: active
- SSH and Apache: disabled/inactive by design
- Security baseline: 8 passed, 0 warnings, 0 failures
- Reboot-required marker: absent at validation time

No exact final package transaction count is claimed because a complete transaction log was not captured in the public evidence set.

## Package-state caveats

- An unprivileged `apt-get check` attempt could not acquire the dpkg frontend lock. The command did not complete and is not counted as a passing package consistency check.
- `dpkg -l` showed an `rc` state for `libgvc6`, indicating the package was removed while residual configuration files remained. No purge or cleanup was performed.
- The absence of a reboot-required marker is a point-in-time check; it does not prove every update can take effect without a reboot.
- No autoremove or residual configuration purge is documented as having been run.

## Snapshot and rollback decision

No VMware snapshot was created. The operator explicitly chose to proceed without one. This reduces rollback options if a later package or configuration issue appears. Before future large rolling upgrades, create and verify an independent recovery point where practical and retain a separate copy of critical data.

## Recommended post-maintenance routine

Run from a local console or authenticated administrative session:

```bash
sudo apt-get check
sudo dpkg --audit
systemctl --failed --no-pager
systemctl is-system-running
systemctl status ufw fail2ban --no-pager
sudo ufw status verbose
sudo fail2ban-client status
```

Review any `rc` packages before deciding whether to purge them. Check current upgrade notes, review proposed removals, and verify network access and desktop integration after each major rolling transaction.
