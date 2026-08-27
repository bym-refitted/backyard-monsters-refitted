#!/usr/bin/env bash
#
# Build the com.bym.notif AIR Native Extension (iOS local notifications).
#
#   1. Compile native/BymNotif.m -> libbymnotif.a (arm64, iphoneos SDK).
#   2. Compile the AS3 wrapper -> bymnotif.swc (acompc / AIR config).
#   3. Package -> build/com.bym.notif.ane (adt -target ane).
#
# The .ane rarely changes, so iterate.sh only rebuilds it when missing. Run this by hand after
# editing native/BymNotif.m to force a rebuild. Needs Xcode command-line tools + the Harman AIR SDK.
#
set -euo pipefail

AIR_SDK_HOME="${AIR_SDK_HOME:?set AIR_SDK_HOME to your AIR SDK install, e.g. ~/AIRSDK/AIRSDK_50.2.5}"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ADT="$AIR_SDK_HOME/bin/adt"
ACOMPC="$AIR_SDK_HOME/bin/acompc"
BUILD="$HERE/build"

[ -x "$ADT" ] || { echo "❌ adt not found at $ADT (set AIR_SDK_HOME)"; exit 1; }
[ -f "$AIR_SDK_HOME/include/FlashRuntimeExtensions.h" ] || { echo "❌ FRE header missing in AIR SDK"; exit 1; }

rm -rf "$BUILD"; mkdir -p "$BUILD"

echo "▶ 1/3 compiling native lib (arm64)…"
SDKPATH="$(xcrun --sdk iphoneos --show-sdk-path)"
#  -DFR_SDK_COCOA_TOUCH picks the iOS branch of FlashRuntimeExtensions.h (avoids the macOS
#  NSWindow* typedef, which isn't available in the iPhoneOS SDK).
#  arm64-only is fine: adt accepts a non-universal lib because platform.xml sets <sdkVersion> (12.0).
clang -c -arch arm64 -isysroot "$SDKPATH" \
      -I"$AIR_SDK_HOME/include" \
      -DFR_SDK_COCOA_TOUCH \
      -fobjc-arc -miphoneos-version-min=12.0 -O2 \
      -o "$BUILD/BymNotif.o" "$HERE/native/BymNotif.m"
ar rcs "$BUILD/libbymnotif.a" "$BUILD/BymNotif.o"
echo "  ✓ libbymnotif.a ($(lipo -archs "$BUILD/libbymnotif.a"))"

echo "▶ 2/3 compiling AS3 wrapper -> swc…"
( cd "$HERE" && "$ACOMPC" \
    -source-path=as3 \
    -include-classes com.bym.notif.Notifications \
    -output="$BUILD/bymnotif.swc" >/tmp/bymnotif-swc.log 2>&1 ) \
  || { echo "❌ acompc failed:"; tail -20 /tmp/bymnotif-swc.log; exit 1; }
echo "  ✓ bymnotif.swc"

echo "▶ 3/3 packaging .ane…"
( cd "$BUILD" && unzip -o bymnotif.swc library.swf >/dev/null )
( cd "$BUILD" && "$ADT" -package -target ane com.bym.notif.ane "$HERE/extension.xml" \
    -swc bymnotif.swc \
    -platform iPhone-ARM -platformoptions "$HERE/platform.xml" library.swf libbymnotif.a \
    -platform default library.swf )

echo "✅ ANE built: $BUILD/com.bym.notif.ane"
