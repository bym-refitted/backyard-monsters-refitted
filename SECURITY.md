# Security Policy

## Supported Versions
Only the currently deployed server and launcher builds
on `main` receive security fixes.

<br>

## Reporting a Vulnerability
Please do not open a public issue.

Use GitHub's private reporting:
Security tab → Report a vulnerability.
Alternatively, contact us on Discord.

Include reproduction steps, affected endpoint or client
build, and impact. We aim to acknowledge within 72 hours.

<br>

## In Scope
- bymrefitted.com and the game/API server
- The Tauri launcher
- The Flash client where a flaw affects other players
  or server integrity (auth bypass, account takeover, injection, RCE)

<br>

## Out of Scope
- Client-side cheats affecting only your own account
- Denial of service / volumetric attacks
- Reports from automated scanners without a working PoC
- Social engineering of players or staff

<br>

## Volume Testing
Flaws in rate limiting, abuse controls, or proxy
configuration ARE in scope, including bypasses of
per-IP or per-account limits, origin IP exposure that
circumvents our edge protections, and endpoints where
a single cheap request triggers disproportionate
server work.

Demonstrate these with the minimum requests needed -
typically fewer than ten. If proving impact seems to
require sustained traffic, stop and report what you
have; we'll reproduce it ourselves.

<br>

## Safe Harbour
Testing against your own account is fine. Don't access
other players' data, degrade service, or destroy data.
Act in good faith and we won't pursue action.
