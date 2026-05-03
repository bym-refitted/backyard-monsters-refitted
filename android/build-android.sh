#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────
#  BYM Refitted — Android build + USB deploy
#
#  Prerequisites:
#    1. Harman AIR SDK  https://airsdk.harman.com/download
#    2. adb on PATH  (Android SDK platform-tools)
#    3. USB Debugging enabled on your phone
#    4. Phone connected via USB  →  run: adb devices
#
#  Usage (from any directory):
#    ./android/build-android.sh               # compile + package + install (stable)
#    ./android/build-android.sh debug         # use asconfig.json / bymr-debug.swf
#    ./android/build-android.sh local         # use asconfig.local.json / bymr-local.swf
#    ./android/build-android.sh --install-only  # skip compile+package, just adb install
# ─────────────────────────────────────────────────────────────
set -e

# Always run from the project root regardless of where the script is called from
cd "$(dirname "$0")/.."

# ── Configuration ────────────────────────────────────────────
# Auto-detect AIR SDK from PATH (works if adt is already on your PATH)
AIR_SDK="$(cd "$(dirname "$(command -v adt)")/.." && pwd)"
KEYSTORE_PASS="12Kellys!"

KEYSTORE="android/bymr.keystore"
DESCRIPTOR="android/bym-refitted.xml"
OUTPUT_APK="android/apk/BYMRefitted.apk"
SWF_DEST="android/apk/bymr-android.swf"

# ── Argument parsing ─────────────────────────────────────────
CONFIG="stable"
INSTALL_ONLY=0

for arg in "$@"; do
    case $arg in
        debug|local|stable) CONFIG="$arg" ;;
        --install-only)     INSTALL_ONLY=1 ;;
    esac
done

case $CONFIG in
    stable) ASCONFIG="asconfig.stable.json"; SWF_OUT="bin/bymr-stable.swf" ;;
    debug)  ASCONFIG="asconfig.json";        SWF_OUT="bin/bymr-debug.swf"  ;;
    local)  ASCONFIG="asconfig.local.json";  SWF_OUT="bin/bymr-local.swf"  ;;
esac

ADT="$AIR_SDK/bin/adt"

# ── Sanity checks ────────────────────────────────────────────
if [ ! -f "$ADT" ] && [ ! -f "$ADT.bat" ]; then
    echo "ERROR: AIR SDK not found at '$AIR_SDK'. Set the AIR_SDK variable." >&2
    exit 1
fi
if [ ! -f "$KEYSTORE" ]; then
    echo "ERROR: Keystore not found: $KEYSTORE" >&2
    exit 1
fi

# On Windows (Git Bash) adt is a .bat file
[ -f "$ADT.bat" ] && ADT="$ADT.bat"

if [ $INSTALL_ONLY -eq 0 ]; then
    # ── Step 1: Compile AS3 → SWF ────────────────────────────
    echo ""
    echo "[1/3] Compiling $ASCONFIG → $SWF_OUT ..."

    if command -v asconfigc &>/dev/null; then
        asconfigc --project "$ASCONFIG" --sdk "$AIR_SDK"
    else
        "$AIR_SDK/bin/amxmlc" -load-config+="$ASCONFIG"
    fi

    # ── Step 2: Package SWF → APK ────────────────────────────
    echo ""
    echo "[2/3] Packaging APK → $OUTPUT_APK ..."

    mkdir -p "$(dirname "$SWF_DEST")"
    cp "$SWF_OUT" "$SWF_DEST"

    "$ADT" -package \
        -target apk-captive-runtime \
        -arch armv8 \
        -storetype pkcs12 \
        -keystore "$KEYSTORE" \
        -storepass "$KEYSTORE_PASS" \
        "$OUTPUT_APK" \
        "$DESCRIPTOR" \
        "$SWF_DEST" \
        android/icons/icon36.png \
        android/icons/icon48.png \
        android/icons/icon72.png
fi

# ── Step 3: Deploy via ADB ───────────────────────────────────
echo ""
echo "[3/3] Installing APK on device ..."

if ! command -v adb &>/dev/null; then
    echo "WARNING: adb not found on PATH. Install Android SDK platform-tools."
    echo "Manual install:  adb install -r \"$OUTPUT_APK\""
    exit 0
fi

if ! adb devices | grep -q "device$"; then
    echo "ERROR: No Android device detected. Enable USB Debugging and reconnect." >&2
    exit 1
fi

adb install -r "$OUTPUT_APK"
echo ""
echo "Done! App installed."
