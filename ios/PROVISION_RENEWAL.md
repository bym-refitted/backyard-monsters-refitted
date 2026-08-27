# Renovar Perfil de Provisioning (Semanal)

**Por qué:** El perfil de desarrollo gratuito de Apple caduca cada **7 días**. Necesitas renovarlo cada semana para instalar la app en el iPhone.

> Este documento asume que ya hiciste la configuración inicial (Paso 1 de
> [README.md](README.md): añadir tu Apple ID, crear el proyecto "gancho" en
> Xcode con bundle id `com.bymrefitted`). Si es tu primera vez, ve allí
> primero — aquí solo está la renovación semanal, que es mucho más corta.

---

## 1. Renovar el perfil en Xcode (5 min)

```bash
# Abre Xcode
open /Applications/Xcode.app
```

En Xcode:
1. **Xcode › Settings › Accounts** → verifica que tu Apple ID está conectado
   - Si pide contraseña/2FA, méteala
2. **Abre el proyecto "gancho"** que creaste en el Paso 1 del README (cualquier nombre, bundle id `com.bymrefitted`) — no crees uno nuevo, reutiliza ese
3. En el panel izquierdo, selecciona el **target** de ese proyecto (el nombre que le pusiste)
4. Ve a **Signing & Capabilities**
5. Asegúrate de que:
   - ✅ **"Automatically manage signing"** está activado
   - **Team** = tu equipo personal (Personal Team)
6. Normalmente Xcode regenera el perfil solo (~10s). Si el Status sigue en
   rojo o dice *"Communication with Apple failed"* / *"no devices"*, eso solo
   se arregla haciendo una instalación real: conecta el iPhone, selecciónalo
   como destino junto al botón ▶ (en vez de "My Mac") y pulsa **Run**. Ese
   `Run` sobre el dispositivo es lo que de verdad fuerza a Apple a
   registrarlo y generar el perfil — el panel de Signing por sí solo a veces
   no basta.

---

## 2. Copiar el perfil nuevo a la carpeta de build (1 min)

```bash
#!/bin/bash
# Encuentra el perfil más nuevo
NEWPROF=$(ls -t ~/Library/Developer/Xcode/UserData/Provisioning\ Profiles/*.mobileprovision | head -1)

# Cópialo a la carpeta de build
cp "$NEWPROF" /path/to/backyard-monsters-refitted/ios/BYMRefitted.mobileprovision

# Verifica
ls -la /path/to/backyard-monsters-refitted/ios/BYMRefitted.mobileprovision
```

---

## 3. Compilar e instalar en el iPhone (5 min)

```bash
cd /path/to/backyard-monsters-refitted
./ios/iterate.sh
```

Si todo va bien:
- Verás `✓ instalado`
- La app se lanzará en el iPhone

Si falla con `"invalid code signature"`:
  → Ve al **paso 4** (confiar en el perfil en el iPhone)

---

## 4. Confiar en el perfil en el iPhone (1 min)

**Solo la primera vez que instalas un nuevo perfil:**

En el **iPhone**:
1. **Settings** → **General** → **VPN & Device Management**
2. Busca **"Apple Development: tu@email.com"**
3. Toca en él
4. Pulsa **"Trust"** y confirma

Después de confiar, la app se lanzará sin errores.

---

## Checklist semanal

- [ ] Lunes (o cuando caduque): renovar en Xcode (paso 1)
- [ ] Copiar perfil nuevo (paso 2)
- [ ] Compilar: `./ios/iterate.sh` (paso 3)
- [ ] Si pide trust, confiar en Settings del iPhone (paso 4)

---

## Troubleshooting

| Error | Solución |
|-------|----------|
| `"This provisioning profile has expired"` | El perfil caducó. Repite **paso 1-3** |
| `"invalid code signature"` o `"profile has not been explicitly trusted"` | Necesitas confiar en el perfil. Ve a **paso 4** |
| `"Unable to install on this device"` / `"The device is locked"` | El iPhone está bloqueado. Desbloquéalo y déjalo con pantalla encendida durante la instalación |
| `"Communication with Apple failed"` / `"Your team has no devices"` | Xcode aún no ha registrado el iPhone. No sirve el panel de Signing solo — haz un **Run** real sobre el dispositivo (ver paso 1.6) |
| `developer.apple.com/account/resources/devices` dice "only for developers enrolled in a program" | Esa web es solo para cuentas de pago; con cuenta gratuita el registro se hace vía Xcode (paso 1.6), no por esa web |
| Xcode no regenera el perfil tras varios intentos | Cierra Xcode del todo, vuelve a abrirlo, y repite el paso 1.6 (el Run real, no solo el panel) |

---

## Alternativa: Suscripción Apple Developer ($99/año)

Si quieres evitar esto cada semana, paga **$99/año** por una cuenta Apple Developer:
- Los perfiles duran **1 año** (no 7 días)
- Tienes más dispositivos y aplicaciones
- Acceso a beta releases

Pero con el flujo anterior, 5 minutos cada lunes = gratis.
