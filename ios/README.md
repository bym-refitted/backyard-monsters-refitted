# BYM Refitted on iOS — installation guide

Native (Adobe AIR) port of the client, playing against the **official
server** (`https://server.bymrefitted.com`). It works, and has been tested
on a real device.

**It's not on the App Store and won't be**: this is an unofficial
preservation project of a game Kixeye owns the rights to (see the digital
preservation section in the repo's main README) — publishing it on a
commercial store isn't viable or the goal here. It installs by
*sideloading* (loading it yourself from your Mac onto your own iPhone),
which is 100% legal and something every iOS developer does daily for their
own apps — but there are two limits worth knowing before you start:

- **You need a Mac** with Xcode, at least for Step 1 (registering your
  account and your iPhone). That's the most tedious part of all this — a
  bit fiddly the first time, but only 6 clicks — and everything after
  (compiling, installing) is a single terminal command, no need to reopen
  Xcode.
- **With a free Apple account, the app stops working every 7 days** until
  you re-sign it (2-3 minutes, repeating Step 1.6 + Step 2). That's an
  Apple limitation for accounts without the paid subscription ($99/year),
  not something specific to this project.

If you've already been through this once, jump straight to
**[PROVISION_RENEWAL.md](PROVISION_RENEWAL.md)** for the weekly renewal.

---

## Quick summary

1. **Install the requirements** below (Xcode, AIR SDK, asconfigc) — once.
2. **Step 1**: register your Apple ID + iPhone in Xcode — once (6 clicks).
3. **Step 2**: copy the signing profile into the project — one command.
4. **Step 3**: run `./ios/iterate.sh` (or just double-click
   **`ios/Install BYM Refitted.command`** in Finder — no terminal needed) —
   compiles, installs and launches the game on your iPhone.
5. **First launch only**: trust the developer in *Settings → General → VPN
   & Device Management* (end of Step 3).
6. **Every 7 days**: repeat Step 1's "renew" (2 min) + Step 2 + `iterate.sh`.
   See **[PROVISION_RENEWAL.md](PROVISION_RENEWAL.md)**.

That's the whole flow. Details for each step below.

---

## Requirements

- A Mac with **Xcode** installed (free, from the macOS App Store)
- Any **Apple ID** (no need to pay for anything)
- Your **iPhone** + a USB cable (only for the first pairing)
- Harman's **AIR SDK**: <https://airsdk.harman.com/download> (free, requires a Harman account)
- **asconfigc**: `npm i -g asconfigc`

---

## Step 1 — Register your Apple ID and iPhone in Xcode

This is the only step that requires Xcode open. It's what lets Apple know
your iPhone exists so it'll let you generate a free signing certificate.
**The first time** is 6 steps (5-10 min); **renewing every 7 days**
(see below) is just 2, reusing the project you already created.

### The first time (once, ever, per Mac)

1. **Xcode → Settings → Accounts** → click `+` → add your Apple ID (any
   one, personal is fine).
2. Create any project from scratch: **File → New → Project → App**
   (SwiftUI, any name). This is just a "hook" to get Xcode talking to
   Apple — it has nothing to do with the game itself. **Don't delete it** —
   you'll need it every week to renew the signature (see below).
3. Select the project's target → **Signing & Capabilities** tab:
   - **Bundle Identifier**: type exactly `com.bymrefitted`
   - **Automatically manage signing**: checked
   - **Team**: your personal account (Personal Team)
4. Connect the iPhone via **USB cable**, unlock it, and if "Trust This
   Computer?" pops up, tap **Trust**. (This cable is only needed this first
   time — after this Xcode recognizes the iPhone over Wi-Fi.)
5. At the top next to the ▶ button, where it says **"My Mac"**, switch it
   to your iPhone.
6. Press **▶ Run**. This compiles the empty project and installs it on the
   iPhone — it's that real install which is what makes Apple actually
   register your device and generate the signing profile. You'll see the
   app open on the iPhone; you can close it, you won't need it again.
   - If it fails with something like *"Communication with Apple failed"*
     or *"no devices"*, just repeat this step 6 once more — Xcode
     sometimes needs two tries.

Once done, Xcode has saved a signing certificate (in the Keychain) and a
provisioning profile (in `~/Library/Developer/Xcode/UserData/Provisioning
Profiles/`) on your Mac. From there, move on to Step 2.

### Every 7 days, when it expires (2 minutes, no cable needed)

The free certificate expires weekly and the app stops opening with
`"This provisioning profile has expired"`. To renew it:

1. Open Xcode and open the **same project** you created the first time
   (steps 1-3 above are **not** repeated — your Apple ID and Signing
   config are already saved).
2. With the iPhone nearby (same Wi-Fi network, you no longer need the
   cable) select it as the destination next to the ▶ button and press
   **▶ Run** (this is just step 5-6 from above, nothing more).

That regenerates the profile. Continue with **Step 2** below (copying it)
and re-run `iterate.sh`. Full checklist in
**[PROVISION_RENEWAL.md](PROVISION_RENEWAL.md)**.

---

## Step 2 — Copy the signing profile into the project

```bash
NEWPROF=$(ls -t ~/Library/Developer/Xcode/UserData/Provisioning\ Profiles/*.mobileprovision | head -1)
cp "$NEWPROF" ios/BYMRefitted.mobileprovision
```

---

## Step 3 — Compile, package, install and launch

### Easiest: double-click, no terminal

Just double-click **[`ios/Install BYM Refitted.command`](Install%20BYM%20Refitted.command)**
**in the macOS Finder app** (not inside Xcode, VS Code or any other editor —
those open it as a text file instead of running it; use the actual Finder
window). The first time, it'll pop up a couple of native macOS dialogs
asking for your AIR SDK path, your iPhone and your signing certificate
(it tries to auto-detect them first) — answer once and it remembers them
for every run after that. A terminal window opens just to show progress,
but you never have to type a command in it.

If macOS blocks it the first time ("cannot be opened because it is from
an unidentified developer"), right-click the file → **Open** → **Open**
again to confirm once.

### Or: from the terminal

You need two things about your setup:

- **Your iPhone's identifier** (its name works too):
  ```bash
  xcrun devicectl list devices
  ```
- **The exact name of your signing certificate**, as shown in
  Xcode → Signing & Capabilities → *Signing Certificate*, in the format
  `Apple Development: you@example.com (XXXXXXXXXX)`.

With those two:

```bash
export AIR_SDK_HOME=~/AIRSDK/AIRSDK_50.2.5        # wherever you unpacked the AIR SDK
export BYMR_DEVICE_ID="MyPhone"                    # your iPhone's name or UUID
export BYMR_SIGNING_CERT="Apple Development: you@example.com (XXXXXXXXXX)"
./ios/iterate.sh
```

The script compiles the SWF (~10-30s), packages the `.ipa`, installs it on
the connected iPhone, and launches it automatically. You'll see progress
for each step in the terminal; if something fails, the script tells you
exactly which of the 4 steps it was.

> Save those three `export` lines in your shell profile (`~/.zshrc`) so you
> don't have to repeat them every time.

**The first time you install**, the app won't open on its own — iOS blocks
apps from unverified developers until you trust it manually:

1. On the **iPhone**: **Settings → General → VPN & Device Management**
2. Under "Developer App", tap **"Apple Development: you@example.com"**
3. Tap **"Trust ..."** and confirm

After that, the app opens normally (and stays trusted until the profile
expires in 7 days).

---

## Every 7 days: renewing the signature

See the **"Every 7 days, when it expires"** section inside Step 1 (above):
it's just 2 minutes, without repeating the initial setup. Full checklist in
**[PROVISION_RENEWAL.md](PROVISION_RENEWAL.md)**.

---

## Can I just share a pre-built `.ipa` instead of everyone compiling?

Yes, but it only pays off for a very small, fixed group (2-3 people), not
for "the community" at large: with a free account, the signing profile
only installs on devices whose UDID is baked into it, so every new person
has to send you their UDID before you can add it and rebuild. And since the
profile expires every 7 days **for everyone at once**, whoever signs it has
to rebuild and resend the `.ipa` to the whole group every week, without
exception — if they can't one week, it stops working for everyone until
they do.

With a paid account ($99/year) the limit goes up to 100 devices and the
profile lasts a year, but it's still one person signing and distributing
for everyone.

**For an individual user, the self-service flow in this document is the
better option by a wide margin**: it doesn't depend on anyone else being
available, there's nothing to coordinate, and once Step 1 is done the
weekly renewal is 2 minutes on your own. The shared-`.ipa` route only makes
sense if you're already a small, fixed group willing to depend on one
person every week — for playing solo, there's no reason to deal with that.

---

## Troubleshooting

These are real errors we ran into while testing this — not hypothetical.

| Error | Cause | Fix |
|---|---|---|
| `The device is locked` | The iPhone is locked | Unlock it and keep the screen on during install |
| App installs but won't open (no error, just doesn't launch) | iOS doesn't trust the developer yet | Settings → General → VPN & Device Management → trust the "Apple Development" profile (see end of Step 3) |
| `Communication with Apple failed` / `Your team has no devices` | Xcode hasn't registered your iPhone with Apple yet | Repeat all of Step 1 (the `Run` from Xcode onto the iPhone is what actually registers the device — the Signing & Capabilities panel alone isn't enough) |
| `developer.apple.com/account/resources/devices` says "only for developers enrolled in a program" | That page is paid-accounts only | You don't need it with a free account — registration happens via Xcode (Step 1), not that page |
| `This provisioning profile has expired` | More than 7 days since the last `Run` in Xcode | Repeat Step 1.6 + Step 2 (see above or PROVISION_RENEWAL.md) |
| The compiler hangs / the SWF comes out smaller than usual | The AIR compiler occasionally gets stuck | `iterate.sh` already retries automatically up to 5 times — no action needed |
| `New Update Available!` when connecting to the official server | Your branch is behind — `apiVersionSuffix` in `client/scripts/GLOBAL.as` doesn't match the version the official server currently expects | Pull the latest `main` and rebuild. If you're on your own branch, check that `apiVersionSuffix` matches the value in the community's current `main` |

---

## Testing against a different server (optional, for development)

By default it always points to the official server. If you want to compile
against your own local or private server during development:

```bash
BYMR_LOCAL=1 BYMR_SERVER_URL="https://your-server.example.com/" ./ios/iterate.sh
```

Without those variables, `iterate.sh` always compiles against the official
server.
