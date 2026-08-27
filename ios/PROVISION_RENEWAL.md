# Renewing the Provisioning Profile (Weekly)

**Why:** Apple's free development profile expires every **7 days**. You need to renew it weekly to keep installing the app on your iPhone.

> This document assumes you already did the initial setup (Step 1 in
> [README.md](README.md): adding your Apple ID, creating the "hook" project
> in Xcode with bundle id `com.bymrefitted`). If this is your first time,
> go there first — this page only covers the weekly renewal, which is much
> shorter.

---

## 1. Renew the profile in Xcode (5 min)

```bash
# Open Xcode
open /Applications/Xcode.app
```

In Xcode:
1. **Xcode › Settings › Accounts** → verify your Apple ID is connected
   - If it asks for a password/2FA, enter it
2. **Open the "hook" project** you created in Step 1 of the README (any name, bundle id `com.bymrefitted`) — don't create a new one, reuse that one
3. In the left panel, select that project's **target** (whatever you named it)
4. Go to **Signing & Capabilities**
5. Make sure:
   - ✅ **"Automatically manage signing"** is checked
   - **Team** = your personal account (Personal Team)
6. Xcode usually regenerates the profile on its own (~10s). If the Status
   stays red or says *"Communication with Apple failed"* / *"no devices"*,
   the only fix is doing a real install: connect the iPhone, select it as
   the destination next to the ▶ button (instead of "My Mac") and press
   **Run**. That `Run` on the device is what actually forces Apple to
   register it and generate the profile — the Signing panel alone
   sometimes isn't enough.

---

## 2. Copy the new profile into the build folder (1 min)

```bash
#!/bin/bash
# Find the newest profile
NEWPROF=$(ls -t ~/Library/Developer/Xcode/UserData/Provisioning\ Profiles/*.mobileprovision | head -1)

# Copy it into the build folder
cp "$NEWPROF" /path/to/backyard-monsters-refitted/ios/BYMRefitted.mobileprovision

# Verify
ls -la /path/to/backyard-monsters-refitted/ios/BYMRefitted.mobileprovision
```

---

## 3. Compile and install on the iPhone (5 min)

```bash
cd /path/to/backyard-monsters-refitted
./ios/iterate.sh
```

If all goes well:
- You'll see `✓ installed`
- The app will launch on the iPhone

If it fails with `"invalid code signature"`:
  → Go to **step 4** (trusting the profile on the iPhone)

---

## 4. Trust the profile on the iPhone (1 min)

**Only the first time you install a new profile:**

On the **iPhone**:
1. **Settings** → **General** → **VPN & Device Management**
2. Find **"Apple Development: you@example.com"**
3. Tap it
4. Press **"Trust"** and confirm

After trusting it, the app will launch without errors.

---

## Weekly checklist

- [ ] Monday (or whenever it expires): renew in Xcode (step 1)
- [ ] Copy the new profile (step 2)
- [ ] Compile: `./ios/iterate.sh` (step 3)
- [ ] If it asks to trust, trust it in the iPhone's Settings (step 4)

---

## Troubleshooting

| Error | Fix |
|-------|----------|
| `"This provisioning profile has expired"` | The profile expired. Repeat **steps 1-3** |
| `"invalid code signature"` or `"profile has not been explicitly trusted"` | You need to trust the profile. Go to **step 4** |
| `"Unable to install on this device"` / `"The device is locked"` | The iPhone is locked. Unlock it and keep the screen on during install |
| `"Communication with Apple failed"` / `"Your team has no devices"` | Xcode hasn't registered the iPhone yet. The Signing panel alone won't do it — do a real **Run** onto the device (see step 1.6) |
| `developer.apple.com/account/resources/devices` says "only for developers enrolled in a program" | That page is paid-accounts only; with a free account, registration happens via Xcode (step 1.6), not that page |
| Xcode doesn't regenerate the profile after several tries | Fully quit Xcode, reopen it, and repeat step 1.6 (the real Run, not just the panel) |

---

## Alternative: Apple Developer subscription ($99/year)

If you want to avoid doing this every week, pay **$99/year** for an Apple Developer account:
- Profiles last **1 year** (not 7 days)
- You get more devices and apps
- Access to beta releases

But with the flow above, 5 minutes every Monday = free.
