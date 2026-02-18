# RecordGo + DatqBox Custom Agents Pack

Este repositorio contiene tus agentes personalizados para Copilot y su instalación portable:

- `agents/*.agent.md`
- `instructions/*.instructions.md`
- `prompts/*.prompt.md`
- `scripts/install-on-windows.ps1` (instalador automático)
- `INSTALL.md` (guía detallada)

## Agentes DatqBox incluidos

- `datqbox-super-planner.agent.md`
- `datqbox-super-developer.agent.md`
- `datqbox-super-qa.agent.md`
- `datqbox-sqlserver.agent.md`

Prompts background incluidos:

- `datqbox-bg-plan.prompt.md`
- `datqbox-bg-implement.prompt.md`
- `datqbox-bg-test.prompt.md`
- `datqbox-bg-sql.prompt.md`

## Publicarlo en tu GitHub personal

1. Crea un repositorio nuevo en tu cuenta personal (ejemplo: `recordgo-copilot-agents`).
2. En terminal, dentro de esta carpeta, ejecuta:

```powershell
Set-Location "c:\expertone\RecordGoErpProxy\agent-pack-for-github"
git init
git add .
git commit -m "feat: add RecordGo custom agents pack"
git branch -M main
git remote add origin https://github.com/raulgonzalezdev/recordgo-copilot-agents.git
git push -u origin main
```

## Usarlo en otro equipo

Sigue la guía completa en `INSTALL.md`.

Incluye export/import portable:

- `scripts/export-agent-config.ps1` / `scripts/export-agent-config.sh`
- `scripts/import-agent-config.ps1` / `scripts/import-agent-config.sh`
- `scripts/diagnose-agent-config.ps1` / `scripts/diagnose-agent-config.sh`

## OpenClaw (guía dedicada)

Si vas a usar OpenClaw y te perdiste en el onboarding, sigue esta guía paso a paso:

- `OPENCLAW.md`

Chequeo rápido automático:

```powershell
Set-Location "<ruta>\\copilot-agents"
.\scripts\openclaw-check.ps1
```

Instalación rápida (workspace + global + settings):

```powershell
Set-Location "<ruta>\copilot-agents"
.\scripts\install-on-windows.ps1 -WorkspacePath "C:\ruta\tu\proyecto" -InstallScope both -ConfigureSettings
```

## Nota de seguridad

- No guardar contraseñas/tokens en estos archivos.
- Revisa antes de publicar que no haya datos sensibles.
