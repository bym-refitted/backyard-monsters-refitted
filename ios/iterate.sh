#!/usr/bin/env bash
# Dev iteration: compile SWF -> package .ipa -> install -> launch on the iPhone.
set -uo pipefail
ROOT="${BYMR_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
export AIR_SDK_HOME="${AIR_SDK_HOME:?set AIR_SDK_HOME to your AIR SDK install, e.g. ~/AIRSDK/AIRSDK_50.2.5}"
ADT="$AIR_SDK_HOME/bin/adt"
DEV="${BYMR_DEVICE_ID:?set BYMR_DEVICE_ID to the device UDID from: xcrun devicectl list devices}"
CERT="${BYMR_SIGNING_CERT:?set BYMR_SIGNING_CERT to your \"Apple Development: you@example.com (TEAMID)\" identity}"

cd "$ROOT" || exit 1

# Server target. Por defecto prod. `BYMR_LOCAL=1 ./ios/iterate.sh` compila contra el
# servidor local (bun dev en :3001) usando la IP LAN del Mac — localhost no sirve: lo
# resolvería el iPhone contra sí mismo. Override manual con BYMR_SERVER_URL.
PROJECT=asconfig.ios.json
if [ "${BYMR_LOCAL:-0}" = 1 ]; then
  SRV="${BYMR_SERVER_URL:-http://$(ipconfig getifaddr en0 || ipconfig getifaddr en1):3001/}"
  case "$SRV" in *:3001/|*/) ;; *) SRV="$SRV/";; esac
  sed -E "s#https://server\.bymrefitted\.com/#${SRV}#; s#https://cdn\.bymrefitted\.com/#${SRV}#" \
    asconfig.ios.json > asconfig.ios.gen.json
  PROJECT=asconfig.ios.gen.json
  echo "▶ modo LOCAL — servidor: $SRV"
fi

echo "▶ 1/4 compilando SWF… (con timeout+reintento; el compilador AIR se cuelga a veces)"
compiled=0
# A good build is ~3.65MB. A wedged compiler daemon silently emits a ~32KB-short TRUNCATED SWF
# that still prints "bytes written" but renders BLACK on device. Floor rejects it.
SWF_MIN_BYTES=3640000
for attempt in 1 2 3 4 5; do
  # NEVER reuse a compiler daemon left wedged by a prior/aborted run — kill it before every attempt.
  pkill -9 -f "flexcompiler=$AIR_SDK_HOME" 2>/dev/null
  rm -f bin/bymr-ios.swf
  # a good compile takes ~9s; kill at 40s and retry
  ( asconfigc --sdk "$AIR_SDK_HOME" --project "$PROJECT" >/tmp/it-compile.log 2>&1 ) &
  cpid=$!
  for t in $(seq 1 40); do sleep 1; kill -0 $cpid 2>/dev/null || break; done
  if kill -0 $cpid 2>/dev/null; then
    kill -9 $cpid 2>/dev/null
    pkill -9 -f "flexcompiler=$AIR_SDK_HOME" 2>/dev/null
    echo "  … intento $attempt colgado, reintento"
    continue
  fi
  if ! grep -qiE "bytes written" /tmp/it-compile.log; then
    echo "❌ compile con errores:"; grep -vE "^Loading" /tmp/it-compile.log | tail -10; exit 1
  fi
  swfbytes=$(stat -f%z bin/bymr-ios.swf 2>/dev/null || echo 0)
  if [ "$swfbytes" -lt "$SWF_MIN_BYTES" ]; then
    pkill -9 -f "flexcompiler=$AIR_SDK_HOME" 2>/dev/null
    echo "  … intento $attempt SWF TRUNCADO ($swfbytes < $SWF_MIN_BYTES → pantalla negra), daemon corrupto, reintento"
    continue
  fi
  compiled=1; break
done
[ "$compiled" = 1 ] || { echo "❌ compile falló/truncado 5 veces seguidas"; exit 1; }
echo "  ✓ $(grep -oE '[0-9]+ bytes written' /tmp/it-compile.log | head -1) — $(stat -f%z bin/bymr-ios.swf) bytes OK"

cd "$ROOT/ios" || exit 1
cp ../bin/bymr-ios.swf ./bymr-ios.swf

# Notifications ANE (com.bym.notif): build once (cached) and stage it for adt -extdir.
# Edited native/BymNotif.m? delete ios/ane/build to force a rebuild, or run ane/build-ane.sh.
if [ ! -f ane/build/com.bym.notif.ane ]; then
  echo "▶ construyendo ANE de notificaciones (una vez)…"
  bash ane/build-ane.sh || { echo "❌ build ANE falló"; exit 1; }
fi
mkdir -p ext && cp -f ane/build/com.bym.notif.ane ext/

echo "▶ 2/4 empaquetando .ipa (AOT ipa-test — ~1 min; NO usar interpreter: rompe símbolos/fuentes)…"
rm -f BYM-Refitted.ipa
"$ADT" -package -target ipa-test -storetype KeychainStore \
  -alias "$CERT" -provisioning-profile BYMRefitted.mobileprovision \
  BYM-Refitted.ipa bym-refitted-ios.xml -extdir ext bymr-ios.swf icons notif.caf >/tmp/it-pkg.log 2>&1
[ -f BYM-Refitted.ipa ] || { echo "❌ package falló:"; cat /tmp/it-pkg.log | tail -8; exit 1; }
echo "  ✓ $(ls -lh BYM-Refitted.ipa | awk '{print $5}')"

echo "▶ 3/4 instalando en el iPhone…"
xcrun devicectl device install app --device "$DEV" BYM-Refitted.ipa >/tmp/it-install.log 2>&1
grep -q "App installed" /tmp/it-install.log && echo "  ✓ instalado" || { echo "❌ install falló:"; tail -8 /tmp/it-install.log; exit 1; }

echo "▶ 4/4 lanzando… (mira tu iPhone)"
xcrun devicectl device process launch --terminate-existing --device "$DEV" com.bymrefitted 2>&1 | grep -iE "launched|error|reason" | head -5
echo "✅ listo — observa la pantalla del iPhone"
