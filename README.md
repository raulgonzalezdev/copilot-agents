# RecordGo Custom Agents Pack

Este paquete contiene tus agentes personalizados para Copilot:

- `agents/*.agent.md`
- `instructions/*.instructions.md`
- `prompts/*.prompt.md`

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

1. Clona tu repo personal.
2. Copia estas carpetas al workspace destino (`.vscode/agents`, `.vscode/instructions`, `.vscode/prompts`) o al perfil global de VS Code.
3. Asegura estas settings en el proyecto:

```json
{
  "chat.agentFilesLocations": [".vscode/agents"],
  "chat.instructionsFilesLocations": [".vscode/instructions"],
  "chat.promptFilesLocations": [".vscode/prompts"]
}
```

## Nota de seguridad

- No guardar contraseñas/tokens en estos archivos.
- Revisa antes de publicar que no haya datos sensibles.
