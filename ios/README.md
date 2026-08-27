# BYM Refitted — iOS build (personal / sideload)

Package BYM Refitted as an iOS app that plays against the **official multiplayer
server** (`https://server.bymrefitted.com`), so it works anywhere with no Mac
acting as a server. Signing uses a **free Apple ID** (re-sign every 7 days).

> ⚠️ **Status: scaffolding, not yet a working build.** The files here (descriptor,
> icons, build script, `asconfig.ios.json`) were prepared without the AIR SDK or a
> device on hand, so nothing below has been run end-to-end. Two things still need
> real work: installing the toolchain (yours) and the touch/scaling wrapper (Phase B).

---

## How it fits together

| Piece | File | Status |
|---|---|---|
| iOS AIR descriptor | `ios/bym-refitted-ios.xml` | ✅ done, validated by adt (namespace 51.3) |
| iOS icons (placeholder) | `ios/icons/*` | ⚠️ upscaled from the 72px Android icon — replace with real 1024px art |
| Prod-pointed compile config | `asconfig.ios.json` | ✅ done — compiles vs prod, `optimize:false` (see note) |
| Build + package script | `ios/build-ios.sh` | ✅ done — packaging validated end-to-end up to Apple signing |
| Touch + fullscreen scaling | `GAME.as` (runtime `Capabilities.version` check) | ✅ done — iOS uses `SHOW_ALL`, desktop/web unchanged |
| Apple signing | your free Apple ID | ⛔ **only remaining step** — needs a free provisioning profile |

**Verified with AIR SDK 51.3.3 on this Mac:** the game compiles against the prod
server in ~9s → `bin/bymr-ios.swf` (3.4 MB), and `adt -target ipa-test-interpreter`
accepts the descriptor + swf + icons, stopping only at *"Provisioning profile not
specified."* — i.e. everything works except the Apple signature.

**`optimize:false` note:** the compiler's bytecode optimizer hangs (100% CPU) on the
large `GAME` class. `optimize:false` compiles cleanly; the swf is slightly larger and,
since we package in interpreter mode, there's no real runtime cost.

Why the game SWF is packaged *inside* the app (unlike Android): iOS forbids executing
ActionScript loaded at runtime, so the Android "download the game SWF" loader can't be
reused. `asconfig.ios.json` compiles the whole game into `bin/bymr-ios.swf`, which adt
AOT/interpreter-packages into the `.ipa`.

---

## The known blocker: touch & scaling (Phase B)

[GAME.as](../client/scripts/GAME.as#L170) sets `stage.scaleMode = NO_SCALE` and lays the
UI out from `stageWidth/stageHeight`. On a phone at retina resolution the 760×670 UI would
render tiny in a corner. AIR already maps single-finger taps to mouse clicks, so *clicking*
mostly works for free — but the view must be scaled/letterboxed to fit the screen.

Planned fix (guarded so the desktop/web build is untouched):
```as3
CONFIG::MOBILE {
    // after ADDED_TO_STAGE: scale the game to fit stage bounds, keep aspect,
    // re-apply on Event.RESIZE / orientation change.
}
```
`asconfig.ios.json` already defines `CONFIG::MOBILE = true`; the code block is not written
yet because it needs iterating on a real device (scale factor, letterboxing, hit targets).

---

## One-time setup (your Mac)

1. **Harman AIR SDK** — free, requires a Harman account: https://airsdk.harman.com/download
   ```bash
   export AIR_SDK_HOME=/path/to/AIRSDK
   ```
2. **asconfigc** (compiles the SWF via the SDK):
   ```bash
   npm i -g asconfigc
   ```
3. **Free dev cert + provisioning profile** (only to satisfy adt's packaging):
   - Easiest: open **Xcode → Settings → Accounts**, add your Apple ID (free), create a
     throwaway project with bundle id `com.bymrefitted`, let Xcode auto-generate a
     "Personal Team" development cert + provisioning profile.
   - Export the cert from **Keychain Access** as a `.p12`.
   - Find the generated `.mobileprovision` under
     `~/Library/MobileDevice/Provisioning Profiles/`.
   - Alternatively, **Sideloadly** can generate/refresh these from your Apple ID for you.

## Build

```bash
export AIR_SDK_HOME=/path/to/AIRSDK
export IOS_P12=/path/to/dev-cert.p12
export IOS_P12_PASS=yourpassword
export IOS_PROVISION="$HOME/Library/MobileDevice/Provisioning Profiles/xxxx.mobileprovision"
./ios/build-ios.sh
# -> ios/BYM-Refitted.ipa
```

## Install on your iPhone (free Apple ID)

Use **Sideloadly** (https://sideloadly.io) or **AltStore** (https://altstore.io):
1. Connect the iPhone, sign in with your Apple ID inside the tool.
2. Drop `ios/BYM-Refitted.ipa` in, install.
3. On the phone: **Settings → General → VPN & Device Management** → trust your Apple ID.
4. **Every 7 days** the free signature expires — re-run Sideloadly/AltStore to refresh
   (AltStore can auto-refresh over Wi-Fi if AltServer runs on this Mac on the same network).

> EU note: under the DMA, marketplaces like **AltStore PAL** can refresh apps over the
> internet without a computer — worth checking if you want to drop the weekly Mac step.

---

## Honest risk list

- **Scaling/touch (Phase B)** — the real UX work; needs on-device iteration.
- **AOT compile of the full game** — big Flash games sometimes hit adt AOT errors; the
  `ipa-test-interpreter` target sidesteps AOT and is fine for personal sideloading.
- **`ExternalInterface` calls** in the game are browser/JS-bridge only; on AIR they're
  inert (`ExternalInterface.available == false`) — verify none are load-bearing.
- **Icons** are placeholders — swap in real 1024px art before you care how it looks.
