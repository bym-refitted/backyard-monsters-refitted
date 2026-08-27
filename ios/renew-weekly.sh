#!/usr/bin/env bash
# Renovar perfil semanal + compilar + instalar
# Uso: ./ios/renew-weekly.sh

set -euo pipefail

echo "▶ renew-weekly: copia perfil + compila + instala"
echo ""

# 1. Copiar perfil nuevo
echo "1️⃣  Buscando perfil nuevo en Xcode..."
NEWPROF=$(ls -t ~/Library/Developer/Xcode/UserData/Provisioning\ Profiles/*.mobileprovision 2>/dev/null | head -1)
if [ -z "$NEWPROF" ]; then
  echo "❌ No se encontró perfil de provisioning en Xcode."
  echo "   Abre Xcode > Settings > Accounts y regenera el perfil primero."
  echo "   Instrucciones en: ios/PROVISION_RENEWAL.md"
  exit 1
fi

PROFDATE=$(stat -f %Sm -t '%Y-%m-%d %H:%M' "$NEWPROF")
echo "   ✓ Encontrado: $PROFDATE"

echo ""
echo "2️⃣  Copiando a ios/BYMRefitted.mobileprovision..."
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cp "$NEWPROF" "$ROOT/ios/BYMRefitted.mobileprovision"
echo "   ✓ Copiado"

echo ""
echo "3️⃣  Compilando e instalando..."
cd "$ROOT"
./ios/iterate.sh

echo ""
echo "✅ ¡Listo! Si el iPhone muestra 'invalid code signature':"
echo "   → Ve a Settings › General › VPN & Device Management › Trust en 'Apple Development'"
