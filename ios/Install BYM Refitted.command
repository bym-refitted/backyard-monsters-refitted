#!/usr/bin/env bash
#
# Double-click this file in Finder to build, install and launch the game on
# your iPhone — no need to type anything in a terminal. The first time it
# asks (via native macOS dialogs) for your AIR SDK path, iPhone and signing
# certificate, tries to auto-detect them, and remembers your answers for
# next time. Requires Step 1 (Xcode registration, see README.md) to already
# be done at least once.
#
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$HERE/.." && pwd)"
CONFIG="$HERE/.bymr-config.sh"

ask() {
  osascript -e "text returned of (display dialog \"$1\" default answer \"$2\" with title \"BYM Refitted — setup\")" 2>/dev/null
}

[ -f "$CONFIG" ] && source "$CONFIG"

if [ -z "${AIR_SDK_HOME:-}" ] || [ ! -x "$AIR_SDK_HOME/bin/adt" ]; then
  GUESS=$(ls -d "$HOME"/AIRSDK/AIRSDK_* 2>/dev/null | sort -V | tail -1)
  AIR_SDK_HOME="$(ask "Path to your AIR SDK folder (unzipped from airsdk.harman.com):" "${GUESS:-$HOME/AIRSDK/AIRSDK_50.2.5}")"
  [ -n "$AIR_SDK_HOME" ] || { echo "Cancelled."; exit 1; }
fi

if [ -z "${BYMR_DEVICE_ID:-}" ]; then
  DEVLIST=$(xcrun devicectl list devices 2>/dev/null | awk 'NR>2 && NF>=3 {print $(NF-1)}')
  if [ "$(echo "$DEVLIST" | grep -c .)" = 1 ]; then
    BYMR_DEVICE_ID="$DEVLIST"
  else
    BYMR_DEVICE_ID="$(ask "Your iPhone's name or UUID:" "")"
  fi
  [ -n "$BYMR_DEVICE_ID" ] || { echo "Cancelled."; exit 1; }
fi

if [ -z "${BYMR_SIGNING_CERT:-}" ]; then
  CERTLIST=$(security find-identity -v -p codesigning 2>/dev/null | grep -oE '"Apple Development:[^"]+"' | tr -d '"')
  if [ "$(echo "$CERTLIST" | grep -c .)" = 1 ]; then
    BYMR_SIGNING_CERT="$CERTLIST"
  else
    BYMR_SIGNING_CERT="$(ask "Your signing certificate (Xcode → Signing & Capabilities → Signing Certificate):" "Apple Development: you@example.com (XXXXXXXXXX)")"
  fi
  [ -n "$BYMR_SIGNING_CERT" ] || { echo "Cancelled."; exit 1; }
fi

cat > "$CONFIG" <<EOF
AIR_SDK_HOME="$AIR_SDK_HOME"
BYMR_DEVICE_ID="$BYMR_DEVICE_ID"
BYMR_SIGNING_CERT="$BYMR_SIGNING_CERT"
EOF

export AIR_SDK_HOME BYMR_DEVICE_ID BYMR_SIGNING_CERT

echo "▶ Building, installing and launching BYM Refitted…"
echo

"$ROOT/ios/iterate.sh"
STATUS=$?

echo
if [ "$STATUS" = 0 ]; then
  osascript -e 'display notification "Installed and launched on your iPhone" with title "BYM Refitted"' 2>/dev/null
else
  osascript -e 'display dialog "Something failed — check the window above for details." with title "BYM Refitted" buttons {"OK"} default button 1' 2>/dev/null
fi

echo
read -n 1 -s -r -p "Press any key to close this window..."
echo
