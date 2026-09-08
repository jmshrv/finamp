# Android custom operating systems (GrapheneOS & LineageOS)

Broad overview for people installing or maintaining this Finamp fork on
**Android**. Stock Android and Google Play are enough for most users. Custom
OSes matter when you care about **privacy defaults**, **security hardening**,
or **keeping an older phone updated** after the manufacturer stops shipping
system updates.

This page is informational. Finamp’s Android sideload / OTA path works on stock
Android, GrapheneOS, LineageOS, and most other Android-compatible systems that
allow installing APKs from outside a store. See [SIDELOAD_OTA.md](SIDELOAD_OTA.md)
and [MOBILE_INSTALLERS.md](MOBILE_INSTALLERS.md).

Official project sites (always verify current device lists there):

| Project | Site |
|---------|------|
| GrapheneOS | [https://grapheneos.org/](https://grapheneos.org/) |
| LineageOS | [https://lineageos.org/](https://lineageos.org/) · [device wiki](https://wiki.lineageos.org/) |

---

## Shared concepts

### What “end of support” means

When Google, GrapheneOS, or LineageOS **stop supporting** a phone model:

- The device **does not brick**. Apps and hardware usually keep working.
- **Security and OS updates stop** (or become best-effort only).
- Proprietary pieces (modem / baseband, bootloader, some firmware) often stop
  getting updates when the **OEM** (e.g. Google for Pixels) ends support — even
  if a community ROM still patches open-source OS and kernel code.

So “unsupported” means **unmaintained stack**, not “the phone dies.”

### Verified boot and locking the bootloader

Serious custom OS installs on Pixels usually unlock the bootloader, flash the
OS, then **re-lock** when the project supports it (GrapheneOS requires this for
a complete install). Unlocking wipes user data. Follow each project’s official
install guide; third-party guides go stale quickly.

### Apps and Google services

| Approach | Typical effect |
|----------|----------------|
| Stock Pixel / OEM Android | Full Play Store and Google services |
| GrapheneOS | No Google bundled; optional **sandboxed Play** if you install it |
| LineageOS | No Google by default; many people add **MindTheGapps** or similar, or use F-Droid / sideload only |

Finamp can be installed via this fork’s APK / OTA without Play Store on any of
the above.

### Threat model (generic)

Custom OS choice should match how you use the phone:

- **Careful daily use** (trusted apps, no random APKs) — OS hardening helps, but
  habits matter more than brand of ROM.
- **High assurance** (strong sandboxing, exploit mitigations, locked verified
  boot, current firmware) — GrapheneOS on a **still-supported** device is the
  usual recommendation in that category.
- **Keep older hardware usable** with ongoing open-source patches — LineageOS
  (and similar community ROMs) often outlive OEM and GrapheneOS device lists;
  expect incomplete firmware patching after OEM end-of-life.

---

## GrapheneOS

### What it is

A **privacy- and security-focused** mobile OS based on the Android Open Source
Project (AOSP). Non-profit / open source. Emphasizes hardening (sandboxing,
exploit mitigations, extra permissions) while keeping Android app
compatibility. It does **not** ship Google Play services in the base image;
sandboxed Play is optional.

### Who it fits

People who want a hardened Android on **supported** hardware (historically
Google Pixels that meet GrapheneOS’s security and update requirements), and who
are willing to change phones when a model leaves the support list.

### Device support (how it works)

GrapheneOS maintains a **short** official device list and drops models when the
OEM stops providing full security updates for device-specific code (firmware,
drivers, and related components). Extended builds, if any, are a short
stopgap — not a promise of indefinite support. Always check the current list
on [grapheneos.org/faq](https://grapheneos.org/faq#device-support).

### SWOT — GrapheneOS

| | |
|--|--|
| **Strengths** | Strong security engineering; verified boot with relock; clear threat model; no Google in the base OS; optional sandboxed Play; automatic OS updates on supported devices. |
| **Weaknesses** | Narrow hardware support; support ends when OEM firmware support ends; some banking / NFC / OEM features need extra setup or do not work the same as stock; learning curve for permissions and profiles. |
| **Opportunities** | Best fit when privacy/security is a primary goal and buying or keeping a **supported** Pixel (or future partner OEM devices) is acceptable. |
| **Threats** | Device EOL forces a hardware decision; treating an unsupported install as “GrapheneOS-secure” overstates residual risk (especially frozen firmware). |

---

## LineageOS

### What it is

A large **community custom Android** project (successor lineage from earlier
custom ROM culture). Broader device support than GrapheneOS. Focus is a clean,
updatable AOSP-based OS — not GrapheneOS-level hardening as the primary
mission.

### Who it fits

People who want a modern Android experience on phones **after OEM updates
stop**, who prefer open-source builds, or who need a model GrapheneOS never
supported or already dropped.

### Device support (how it works)

Each device has a **maintainer** and a wiki page. Support length varies by
volunteer effort and hardware. After OEM end-of-life, LineageOS can still ship
OS and kernel patches while **proprietary firmware** stays frozen. Check
[wiki.lineageos.org](https://wiki.lineageos.org/) for your exact model
(codename).

### SWOT — LineageOS

| | |
|--|--|
| **Strengths** | Wide device coverage; often extends usable life of older phones; familiar Android UX; official builds and wiki; active community. |
| **Weaknesses** | Security posture is “good maintained AOSP,” not GrapheneOS-class hardening; quality varies by device/maintainer; Google apps are a separate choice (and a trust tradeoff); unlock/flash process still carries wipe and brick risk if done wrong. |
| **Opportunities** | Strong option when the goal is **longevity and control** of existing hardware, sideloaded apps (including Finamp), and freedom from OEM skins or store lock-in. |
| **Threats** | Maintainer dropout; incomplete patches after OEM firmware EOL; assuming “custom ROM = hardened” without reading the project’s actual goals. |

---

## Choosing between them (short)

| Goal | Lean toward |
|------|-------------|
| Maximum OS/firmware security on a current supported Pixel | **GrapheneOS** |
| Keep an older or unsupported-by-GrapheneOS phone updated in open source | **LineageOS** (or another community ROM with an active maintainer) |
| Least friction, full Play ecosystem | **Stock OEM Android** |
| Install Finamp without a store | Any of the above + [MOBILE_INSTALLERS.md](MOBILE_INSTALLERS.md) / [SIDELOAD_OTA.md](SIDELOAD_OTA.md) |

Related privacy-oriented or de-Googled projects (**/e/OS**, **iodéOS**, and
others) exist with their own device lists and tradeoffs; they are outside the
scope of this page. Prefer each project’s official docs over third-party
install blogs.

---

## Finamp on these systems

- Use this fork’s **Profile / sideload** Android builds; allow install from the
  appropriate source; complete in-app Updates setup if using OTA.
- GrapheneOS: grant **Network** (and any other) permissions Finamp needs; if
  you rely on Play-dependent features elsewhere on the phone, use sandboxed
  Play only in the profile(s) you choose.
- LineageOS: same APK/OTA flow as stock; ensure unknown-sources / installer
  permission for Finamp if using silent OTA.

No Finamp feature requires GrapheneOS or LineageOS specifically.
