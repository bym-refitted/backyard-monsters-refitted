# BYM Refitted en iOS — guía de instalación

Puerto nativo (Adobe AIR) del cliente, jugando contra el **servidor oficial**
(`https://server.bymrefitted.com`). Funciona, está probado en dispositivo real.

**No está en la App Store** y no lo estará: este es un proyecto de
preservación no oficial de un juego con derechos de Kixeye (ver la sección
de preservación digital en el README principal del repo) — publicarlo en
una tienda comercial no es viable ni es el objetivo. Se instala por
*sideload* (cargarlo tú mismo desde tu Mac a tu propio iPhone), que es 100%
legal y lo hace cualquier desarrollador de iOS a diario para sus propias
apps — pero tiene dos límites que hay que conocer antes de empezar:

- **Necesitas un Mac** con Xcode, al menos para el Paso 1 (registrar tu
  cuenta y tu iPhone). Es la parte más pesada de todo esto — un poco lioso
  la primera vez, pero solo son 6 clics — y luego el resto (compilar,
  instalar) es un solo comando de terminal, sin volver a abrir Xcode.
- **Con una cuenta Apple gratuita, la app deja de funcionar cada 7 días**
  hasta que la vuelves a firmar (2-3 minutos, repitiendo Paso 1.6 + Paso 2).
  Es una limitación de Apple para cuentas sin la suscripción de pago
  (99$/año), no de este proyecto.

Si ya pasaste por esto una vez, ve directo a **[PROVISION_RENEWAL.md](PROVISION_RENEWAL.md)**
para la renovación semanal.

---

## Requisitos

- Un Mac con **Xcode** instalado (gratis, desde la App Store de macOS)
- Un **Apple ID** cualquiera (no hace falta pagar nada)
- Tu **iPhone** + cable USB (solo para el primer emparejamiento)
- El **AIR SDK** de Harman: <https://airsdk.harman.com/download> (gratis, requiere cuenta Harman)
- **asconfigc**: `npm i -g asconfigc`

---

## Paso 1 — Registrar tu Apple ID y tu iPhone en Xcode

Este es el único paso que requiere Xcode abierto. Sirve para que Apple sepa
que tu iPhone existe y te deje generar un certificado de firma gratuito.
**La primera vez** son 6 pasos (5-10 min); **para renovar cada 7 días**
(ver más abajo) son solo 2, con el mismo proyecto ya creado.

### La primera vez (una sola vez en la vida de tu Mac)

1. **Xcode → Settings → Accounts** → pulsa `+` → añade tu Apple ID (el que
   sea, personal está bien).
2. Crea un proyecto cualquiera desde cero: **File → New → Project → App**
   (SwiftUI, cualquier nombre). Esto es solo un "gancho" para que Xcode hable
   con Apple — no tiene nada que ver con el juego. **No lo borres** — lo
   necesitarás cada semana para renovar la firma (ver abajo).
3. Selecciona el target del proyecto → pestaña **Signing & Capabilities**:
   - **Bundle Identifier**: escribe exactamente `com.bymrefitted`
   - **Automatically manage signing**: activado
   - **Team**: tu cuenta personal (Personal Team)
4. Conecta el iPhone por **cable USB**, desbloquéalo y, si aparece
   "¿Confiar en este ordenador?", pulsa **Confiar**. (Este cable solo hace
   falta esta primera vez — luego Xcode ya reconoce el iPhone por WiFi).
5. Arriba junto al botón ▶, donde dice **"My Mac"**, cámbialo por tu iPhone.
6. Pulsa **▶ Run**. Esto compila el proyecto vacío y lo instala en el
   iPhone — es justo esa instalación real la que hace que Apple registre tu
   dispositivo y genere el perfil de firma. Verás la app abrirse en el
   iPhone; puedes cerrarla, ya no la necesitas.
   - Si da un error tipo *"Communication with Apple failed"* o *"no
     devices"*, simplemente repite este paso 6 una vez más — a veces Xcode
     necesita dos intentos.

Al terminar, Xcode ya tiene guardados en tu Mac un certificado de firma (en
el Keychain) y un perfil de provisioning (en `~/Library/Developer/Xcode/
UserData/Provisioning Profiles/`). Con eso sigues al Paso 2.

### Cada 7 días, cuando caduque (2 minutos, ya no hace falta el cable)

El certificado gratuito caduca cada semana y la app deja de abrir con
`"This provisioning profile has expired"`. Para renovarlo:

1. Abre Xcode y abre el **mismo proyecto** que creaste la primera vez (pasos
   1-3 de arriba **no** se repiten — el Apple ID y la configuración de
   Signing ya están guardados).
2. Con el iPhone cerca (misma red WiFi, ya no necesitas el cable) selecciónalo
   como destino junto al botón ▶ y pulsa **▶ Run** (esto es el paso 5-6 de
   arriba, nada más).

Eso ya genera el perfil nuevo. Sigue con el **Paso 2** de abajo (copiarlo) y
vuelve a lanzar `iterate.sh`. Checklist completo en
**[PROVISION_RENEWAL.md](PROVISION_RENEWAL.md)**.

---

## Paso 2 — Copiar el perfil de firma al proyecto

```bash
NEWPROF=$(ls -t ~/Library/Developer/Xcode/UserData/Provisioning\ Profiles/*.mobileprovision | head -1)
cp "$NEWPROF" ios/BYMRefitted.mobileprovision
```

---

## Paso 3 — Compilar, empaquetar, instalar y lanzar (un solo comando)

Necesitas dos datos tuyos:

- **El identificador de tu iPhone** (o su nombre, vale igual):
  ```bash
  xcrun devicectl list devices
  ```
- **El nombre exacto de tu certificado de firma**, tal como aparece en
  Xcode → Signing & Capabilities → *Signing Certificate*, con el formato
  `Apple Development: tu@email.com (XXXXXXXXXX)`.

Con esos dos datos:

```bash
export AIR_SDK_HOME=~/AIRSDK/AIRSDK_50.2.5        # donde descomprimiste el AIR SDK
export BYMR_DEVICE_ID="Ivancillo"                  # nombre o UUID de tu iPhone
export BYMR_SIGNING_CERT="Apple Development: tu@email.com (XXXXXXXXXX)"
./ios/iterate.sh
```

El script compila el SWF (~10-30s), empaqueta el `.ipa`, lo instala en el
iPhone conectado y lo lanza automáticamente. Verás el progreso paso a paso en
la terminal; si algo falla, el propio script te dice cuál de los 4 pasos fue.

> Guarda esas tres variables `export` en tu perfil de shell (`~/.zshrc`) para
> no tener que repetirlas cada vez.

---

## Cada 7 días: renovar la firma

Ver la sección **"Cada 7 días, cuando caduque"** dentro del Paso 1 (arriba):
son solo 2 minutos, sin repetir la configuración inicial. Checklist completo
en **[PROVISION_RENEWAL.md](PROVISION_RENEWAL.md)**.

---

## ¿Puedo repartir un `.ipa` ya compilado en vez de que cada uno compile?

Sí, pero solo compensa para un grupo muy pequeño (2-3 personas), no para "la
comunidad": con cuenta gratis el perfil de firma solo instala en los
dispositivos cuyo UDID esté metido en él, así que cada persona nueva tiene
que darte su UDID para que lo añadas y recompiles. Y como el perfil caduca
cada 7 días **para todos a la vez**, quien lo firma tiene que recompilar y
reenviar el `.ipa` a todo el grupo cada semana, sin excepción — si un lunes
no puede, deja de funcionar para todos hasta que lo haga.

Con cuenta de pago (99$/año) el límite sube a 100 dispositivos y el perfil
dura 1 año, pero sigue siendo una sola persona firmando y repartiendo para
todos.

**Para un usuario individual, el self-service de este documento es la mejor
opción, sin comparación**: no depende de que nadie más esté disponible, no
hay que coordinar reenvíos, y una vez hecho el Paso 1 la renovación semanal
son 2 minutos contigo mismo. La vía del `.ipa` compartido solo tiene sentido
si ya sois un grupo pequeño y fijo dispuesto a depender de una sola persona
cada semana — para jugar tú solo, no hay motivo para complicarse con eso.

---

## Solución de problemas

Estos son errores reales con los que nos topamos probando esto — no son
hipotéticos.

| Error | Causa | Solución |
|---|---|---|
| `The device is locked` | El iPhone está bloqueado | Desbloquéalo y déjalo con la pantalla encendida durante la instalación |
| `Communication with Apple failed` / `Your team has no devices` | Xcode no ha registrado tu iPhone en Apple todavía | Repite el Paso 1 completo (el `Run` desde Xcode sobre el iPhone es lo que realmente registra el dispositivo — el panel de Signing & Capabilities por sí solo no basta) |
| `developer.apple.com/account/resources/devices` da "only for developers enrolled in a program" | Esa web es solo para cuentas de pago | No la necesitas con cuenta gratuita — el registro se hace vía Xcode (Paso 1), no por esa web |
| `This provisioning profile has expired` | Han pasado más de 7 días desde el último `Run` en Xcode | Repite Paso 1.6 + Paso 2 (ver arriba o PROVISION_RENEWAL.md) |
| El compilador se cuelga / SWF sale más pequeño de lo normal | El compilador AIR se atasca a veces | `iterate.sh` ya reintenta solo hasta 5 veces — no hace falta hacer nada |

---

## Probar contra otro servidor (opcional, para desarrollo)

Por defecto apunta siempre al servidor oficial. Si quieres compilar contra tu
propio servidor local o uno privado durante desarrollo:

```bash
BYMR_LOCAL=1 BYMR_SERVER_URL="https://tu-servidor.example.com/" ./ios/iterate.sh
```

Sin esas variables, `iterate.sh` compila siempre contra el servidor oficial.
