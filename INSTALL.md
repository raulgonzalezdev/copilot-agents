# Instalación de agentes en otros equipos (Windows + VS Code)

Esta guía instala el pack de agentes de forma repetible en:

- Workspace local (`.vscode/agents`, `.vscode/instructions`, `.vscode/prompts`)
- Perfil global de VS Code (`%APPDATA%/Code/User/prompts`)

## 1) Clonar repo

```powershell
Set-Location "C:\ruta\donde\quieres"
git clone https://github.com/raulgonzalezdev/copilot-agents.git
Set-Location .\copilot-agents
```

## 2) Instalación automática (recomendada)

### Instalar en workspace + global

```powershell
.\scripts\install-on-windows.ps1 -WorkspacePath "C:\ruta\tu\proyecto" -InstallScope both -ConfigureSettings
```

### Solo workspace

```powershell
.\scripts\install-on-windows.ps1 -WorkspacePath "C:\ruta\tu\proyecto" -InstallScope workspace -ConfigureSettings
```

### Solo global

```powershell
.\scripts\install-on-windows.ps1 -InstallScope global -ConfigureSettings
```

## 2.1) Exportar configuración actual (portable)

Esto te crea un bundle con:

- VS Code global (`prompts`, `settings.json`)
- Workspace (`.vscode/agents`, `.vscode/instructions`, `.vscode/prompts`, `.vscode/settings.json`)
- Codex (`~/.codex/config.toml`, `~/.codex/agents` y `~/.codex/skills` sin `.system`)

PowerShell:

```powershell
.\scripts\export-agent-config.ps1 -WorkspacePath "C:\ruta\tu\proyecto" -CreateZip
```

Bash:

```bash
./scripts/export-agent-config.sh --workspace "/ruta/tu/proyecto" --tar
```

## 2.2) Importar en otro equipo

PowerShell:

```powershell
.\scripts\import-agent-config.ps1 `
  -BundlePath "C:\ruta\bundle\agent-config-YYYYMMDD-HHmmss" `
  -WorkspacePath "C:\ruta\tu\proyecto" `
  -InstallScope both `
  -ApplyCodexAgents `
  -ApplyCodexSkills `
  -RestoreCodexConfig
```

Bash:

```bash
./scripts/import-agent-config.sh \
  --bundle "/ruta/bundle/agent-config-YYYYMMDD-HHmmss" \
  --workspace "/ruta/tu/proyecto" \
  --scope both \
  --apply-codex-agents \
  --apply-codex-skills \
  --restore-codex-config
```

## 3) Verificación rápida

- Recargar VS Code: `Developer: Reload Window`
- Confirmar que aparecen archivos `datqbox-*.agent.md` y `datqbox-bg-*.prompt.md`
- Probar en chat:
  - `@DatqBox Super Planner`
  - `@DatqBox Super Developer`
  - `@DatqBox Super QA`
  - `@DatqBox SQL Server Specialist`

## 4) Configuración esperada de settings

El script puede agregar estas entradas automáticamente:

```json
{
  "github.copilot.chat.codeGeneration.useInstructionFiles": true,
  "chat.agentFilesLocations": [".vscode/prompts", ".vscode/agents", "%APPDATA%/Code/User/prompts"],
  "chat.instructionsFilesLocations": [".vscode/prompts", ".vscode/instructions", "%APPDATA%/Code/User/prompts"],
  "chat.promptFilesLocations": [".vscode/prompts", "%APPDATA%/Code/User/prompts"]
}
```

## 5) Seguridad

- No incluir secretos en `.agent.md`, `.prompt.md` o `.instructions.md`.
- No publicar `.env` ni credenciales en este repositorio.
- Validar cambios con `git status` antes de hacer commit.

## 6) OpenClaw (opcional, recomendado)

Si vas a operar agentes 24/7 o por chat, usa también la guía:

- `OPENCLAW.md`

Chequeo rápido:

```powershell
Set-Location "<ruta>\copilot-agents"
.\scripts\openclaw-check.ps1
```

Notas clave para Windows:

- El comando oficial recomendado es `install.ps1`.
- Si `openclaw gateway install` da `Access denied`, abre PowerShell como Administrador.
- Evita `openclaw gateway run --force` en Windows si falta `lsof`; usa `openclaw gateway run`.

## 7) ¿Dónde se guarda cada cosa?

- Modelo/esfuerzo Codex: `~/.codex/config.toml`
- Skills Codex instaladas: `~/.codex/skills/<skill-name>/`
- Agentes/prompts VS Code global: `%APPDATA%/Code/User/prompts`
- Agentes/prompts de proyecto: `<workspace>/.vscode/*`

Si en `config.toml` solo ves `model` y `model_reasoning_effort`, es normal: los skills no se guardan allí, se guardan como carpetas en `~/.codex/skills`.

## 8) Activar el super agente

En Codex/Chat, invoca explícitamente:

```text
$datqbox-super-orchestrator
```

Ejemplo:

```text
$datqbox-super-orchestrator Planifica e implementa la migración del módulo bancos con validación SQL y QA.
```

## 9) Diagnóstico rápido (qué está instalado y dónde)

PowerShell:

```powershell
.\scripts\diagnose-agent-config.ps1 -WorkspacePath "C:\ruta\tu\proyecto"
```

Bash:

```bash
./scripts/diagnose-agent-config.sh "/ruta/tu/proyecto"
```
