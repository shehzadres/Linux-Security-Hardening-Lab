# Security Findings and Remediation Status

Date: 2026-11-20
Environment: Kali GNU/Linux Rolling 2026.1 on VMware Workstation

## 01. Apache HTTP service exposed on all interfaces

**Initial observation**
- Apache was enabled and running.
- It listened on wildcard TCP port 80.
- Requests to loopback and the VM's own interface returned HTTP 200.

**Remediation**
Stopped and disabled Apache after confirming it was not required by another project.

**Verification**
- systemd reports disabled/inactive.
- No TCP listener on port 80.

**Status: Remediated and verified.**

## 02. Host firewall baseline

UFW is active with default incoming deny and default outgoing allow policies. A temporary guest TCP listener was unreachable from the Windows host during the inbound test; the listener was stopped and the port verified closed. Outbound DNS and HTTPS were also verified.

**Status: Applied and tested for the documented paths.**

**Limitation:** Docker may install packet-filter rules that affect published container ports independently of UFW. No containers were running during the review.

## 03. Fail2ban protection

Fail2ban is enabled and active. Its configuration test succeeds and the SSHD jail is loaded. There were zero current bans during inspection.

**Status: Applied and verified.**

**Limitation:** SSH is disabled, so the SSHD jail is configured but has no active SSH service to protect at present.

## 04. SSH access policy and service state

**Effective policy**
- PermitRootLogin: no.
- PubkeyAuthentication: yes.
- AuthenticationMethods: publickey.
- PasswordAuthentication: no.
- KbdInteractiveAuthentication: no.
- AllowUsers: kali.
- MaxAuthTries: 3.
- X11 and TCP forwarding disabled.

The privileged sshd syntax check and effective-configuration query passed. The SSH service remains disabled/inactive.

**Status: Policy configured; daemon intentionally not enabled.**

**Next action:** Provision a passphrase-protected client public key, verify key-based login from the private lab network, review a narrow firewall allowance, and only then consider enabling SSH. Keep VMware console recovery available.

## 05. Docker group membership

The kali account remains in the docker group at the user's request. On a rootful Docker installation, access to the Docker socket is effectively root-equivalent because a user can launch privileged containers and mount host resources.

**Status: Accepted and documented security limitation.**

No membership change was made. Consider rootless Docker or group removal only after reviewing workflow impact.

## 06. APT repository and package maintenance

The additional kali-last-snapshot source was disabled and preserved as a disabled backup. APT metadata refresh succeeded with kali-rolling as the only active source.

The non-root dist-upgrade simulation reported 2,242 upgrades, 180 new packages, 14 removals, and 7 not upgraded. Several removed libraries have replacement ABI packages in the same simulation, including the GVM, multimedia, ONNX, Falco, and PRRTE libraries. The simulation also transitions NetworkManager desktop integration packages.

**Status: Repository configuration cleaned; package plan reviewed; no upgrade performed.**

A VMware snapshot is required before a real rolling upgrade. The VM volume had approximately 3.1 GB free and no existing snapshots at the latest check, so snapshot creation was deferred.

## 07. Configuration backup and recovery

The sample backup/restore test passed, preserving content and mode 0600. A separate root-only configuration backup utility and recovery guide were added. The system configuration archive has not yet been created because the current restricted admin wrapper does not expose that operation and general sudo requires local authentication.

**Status: Procedure and utility prepared; privileged execution pending.**

## 08. fstab validation

The known template header line was already commented. The approved wrapper action reloaded systemd and ran findmnt verification. Result: zero parse errors, zero errors, and one warning identifying /swap as a regular-file swap source. swapon confirmed that /swap is an active swapfile with no current use.

**Status: No malformed header remains; swapfile warning understood.**

## Overall verification

Latest baseline result: **8 passed, 0 warnings, 0 failures.**

This is an educational host baseline, not a complete penetration test or security certification. Upstream network controls, the Windows host, and the VMware hypervisor have not been comprehensively assessed.
