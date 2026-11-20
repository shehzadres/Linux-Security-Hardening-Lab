# APT Repository Review and Upgrade Plan

Date: 2026-11-20

## Final repository state

The VM now uses the official Kali kali-rolling branch only.

- Active source: /etc/apt/sources.list
- Disabled source backup: /etc/apt/sources.list.d/kali-old.list.disabled
- The previous snapshot source file remains preserved for rollback.
- APT metadata refresh completed successfully against kali-rolling.

The original source files are preserved in configs/apt/ with recorded SHA-256 checksums.

## Upgrade simulation

A non-root, non-destructive apt-get -s dist-upgrade simulation reported:

- 2,242 upgraded
- 180 newly installed
- 14 removed
- 7 not upgraded

The 14 removals were reviewed against the full simulation. Several are ABI transitions with replacement packages in the same plan, including:

- libavfilter11 to libavfilter12
- libswscale9 to libswscale10
- libblosc2-7 to libblosc2-9
- libfalcosecurity0t64 to libfalcosecurity0.23
- libpyside6-py3-6.9 and libshiboken6-py3-6.9 to 6.11 packages
- libonnx1t64 to libonnx1l
- libgusb2 to libgusb2a
- libgvm22t64 to libgvm23
- libprrte3 to libprrte4

The simulation also removes the transitional network-manager-gnome package while upgrading network-manager, network-manager-applet, and nm-connection-editor. This should still be reviewed after the transaction, particularly for desktop network controls. python3-pkg-resources is removed while setuptools is upgraded.

The complete simulation is retained locally at evidence/command-outputs/apt-dist-upgrade-simulation.txt; raw command output is excluded from public Git by default.

## Decision

No real upgrade or autoremove has been performed. The transaction affects thousands of packages and must be treated as a planned maintenance window.

Before a real upgrade:

1. Ensure the Windows volume holding the VM has adequate free space.
2. Create and verify a VMware snapshot.
3. Review the complete simulation again against the current package index.
4. Confirm application and desktop compatibility.
5. Obtain explicit approval for the real package transaction.
6. After upgrading, verify package health, core services, network connectivity, and reboot requirements.

At the latest review, the VM volume had approximately 3.1 GB free and the VM had no snapshots. Snapshot creation was deferred because there is not enough safe storage headroom. No package changes were made by the simulation.
