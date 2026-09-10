# Security Policy

## Test Locally
Before doing any security research, set up your own
local instance. bymrefitted.com is a live server with
real players — testing against it degrades the game
for everyone and is not authorised.

Setup instructions are in the README. A full video
walkthrough is available here:
https://youtu.be/d7obn2h3GTI

Nearly every class of issue in this policy — auth
bypass, injection, rate limit
logic, etc — reproduces perfectly on a local instance.
Report it from there.

The narrow exception is findings that only exist in
production infrastructure: origin IP exposure that
bypasses Cloudflare, edge or proxy misconfiguration,
and TLS issues. For these, use the minimum requests
needed to confirm the issue — typically fewer than
ten — and stop. If confirming impact appears to
require sustained traffic, stop and report what you
have; we will reproduce it ourselves.

## Supported Versions
Only the currently deployed server and launcher builds
on `main` receive security fixes.

## Reporting a Vulnerability
Please do not open a public issue.

Use GitHub's private reporting:
Security tab → Report a vulnerability.
Alternatively, contact us on Discord.

Include reproduction steps, affected endpoint or client
build, and impact. We aim to acknowledge within 72 hours.

## In Scope
- bymrefitted.com and the game/API server
- The Tauri launcher
- The Flash client where a flaw affects other players
  or server integrity (auth bypass, account takeover,
  injection, RCE)
- Flaws in rate limiting, abuse controls, or proxy
  configuration: bypasses of per-IP or per-account
  limits, origin IP exposure that circumvents our edge
  protections, and endpoints where a single cheap
  request triggers disproportionate server work

## Out of Scope
- Volumetric attacks. Do not send floods of traffic,
  run stress tests, or attempt to exhaust bandwidth,
  CPU, or connections against production.
- Client-side cheats affecting only your own account
- Reports from automated scanners without a working PoC
- Social engineering of players or staff

## Safe Harbour
We will not pursue action against researchers who
follow this policy: test on a local instance, keep any
production checks within the limits above, don't access
other players' data, don't degrade service, and don't
destroy data. Act in good faith and report promptly.

If you plan to do any testing against production, tell
us first — a quick message on Discord or via private
vulnerability reporting is enough. We monitor for
attacks and will treat unannounced traffic as hostile
and block it. A heads-up saves us both the confusion.

Forgetting to notify us does not by itself void safe
harbour, provided you otherwise acted in good faith
and within this policy.
