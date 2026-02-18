# OpenClaw en Windows - Guía práctica (DatqBox)

Esta guía está pensada para no perderse durante onboarding y dejar OpenClaw operativo con seguridad.

## Estado actual detectado en este equipo

- OpenClaw: instalado (`2026.2.17`)
- Modelo: `openai-codex/gpt-5.3-codex` (OAuth activo)
- Gateway: funciona en modo manual (`ws://127.0.0.1:18789`)
- Servicio automático Windows: **no instalado** por permisos (`Access denied`)
- Canales chat: aún sin configurar (Telegram/WhatsApp/Discord/Slack)
- Skills: 4 listas, 46 con requisitos faltantes

## 1) Instalación recomendada en Windows

> En Windows, usar PowerShell oficial de OpenClaw (más estable que `install.sh` en bash).

```powershell
iwr -useb https://openclaw.ai/install.ps1 | iex
```

### ¿Y el comando con `install.sh`?

Si quieres usar el comando bash:

```bash
curl -fsSL https://openclaw.ai/install.sh | bash -s -- --install-method git
```

hazlo dentro de WSL/Linux. En Windows puro puede darte fricción adicional.

## 2) Arranque (modo manual)

```powershell
openclaw gateway run
```

Panel:

- `http://127.0.0.1:18789/`

Estado y salud:

```powershell
openclaw status
openclaw health
openclaw gateway status
```

## 3) Arranque automático como servicio (opcional)

En PowerShell **como Administrador**:

```powershell
openclaw gateway install
openclaw gateway start
openclaw gateway status
```

Si ves `schtasks ... Access denied`, te faltan permisos de admin.

## 4) Configuración inicial recomendada (orden sugerido)

1. Seguridad base:

```powershell
openclaw security audit --deep
openclaw security audit --fix
```

2. Diagnóstico general:

```powershell
openclaw doctor --deep
```

3. Revisar skills disponibles/faltantes:

```powershell
openclaw skills check
openclaw skills list
```

4. Configurar canal principal (ej. Telegram):

```powershell
openclaw channels login --channel telegram
openclaw channels list
openclaw channels status --deep
```

5. Configurar web search (si lo necesitas):

```powershell
openclaw configure --section web
```

## 5) Checklist de “listo para producción personal”

- [ ] `openclaw status` sin errores de gateway
- [ ] Al menos 1 canal conectado (Telegram/Discord/WhatsApp)
- [ ] `openclaw security audit --deep` revisado
- [ ] Skills críticas para tu flujo instaladas/configuradas
- [ ] Secrets en variables de entorno, nunca en repo

## 6) Skills recomendadas para tu caso (DatqBox)

Prioriza estas clases de skills:

- Desarrollo/código: `coding-agent`, `github`, `gh-issues`
- Productividad técnica: `session-logs`, `summarize`
- Integración de trabajo diario: `discord` o `telegram`

> No intentes activar todas de una vez. Hazlo por bloques y valida cada una.

## 7) Troubleshooting rápido

### `openclaw gateway run --force` falla en Windows

Puede fallar por `lsof not found`.

- Usa `openclaw gateway run` (sin `--force`).

### Gateway cerrado (`1006 abnormal closure`)

1. Ver logs:

```powershell
openclaw logs --follow
```

2. Ejecuta:

```powershell
openclaw doctor --deep
```

3. Reintenta iniciar gateway.

## 8) Buenas prácticas de seguridad

- No compartir token del dashboard ni URLs con `#token=...`.
- Mantener gateway en loopback (`127.0.0.1`) salvo necesidad real.
- Activar canales externos solo cuando entiendas pairing/allowlist.
- Nunca guardar API keys en este repositorio.

---

Si quieres, siguiente paso recomendado: configurar Telegram primero (es la integración más directa para empezar).
