# VSTHost updates (8&Pico)

Software for VSTHost units and the **VSTHost Control** app, published by 8&Pico.

- **Releases** hold, per version:
  - `vsthost-update-<YYYYMMDD.HHMM>.vsu`: the unit software update.
  - `VSTHost-Control-<version>-Windows-Setup.exe` and `VSTHost-Control-<version>-macOS.pkg`: the app installers.
- **`latest.json`** names the newest unit update and app version. VSTHost Control reads it to offer updates (SETUP → Unit software).

A unit installs only updates **signed with 8&Pico's key** (Ed25519) and only versions newer than its own. A file changed by anyone else is refused by the unit, so these files can be public.

## Updating a unit

1. In VSTHost Control 1.2.0 or later, go to **SETUP → Unit software**.
2. Press **Update the unit**. The unit's audio stops for about a minute.

A unit installed from a pen older than 2026-11-12 has no updater yet and needs one first update by hand: ask 8&Pico.

## Source code offers

`source/` has the changes made to free software that the updates ship in binary form:

- `source/wine10-wineusb/`: the patch to Wine 10's `wineusb` (LGPL-2.1-or-later). It adds the vendor-endpoint request that iLok USB keys need.
