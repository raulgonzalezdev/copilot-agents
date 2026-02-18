param(
    [string]$WorkspacePath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$codeUser = Join-Path $env:APPDATA 'Code\User'
$globalPrompts = Join-Path $codeUser 'prompts'
$globalSettings = Join-Path $codeUser 'settings.json'

$codexHome = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { Join-Path $env:USERPROFILE '.codex' }
$codexConfig = Join-Path $codexHome 'config.toml'
$codexSkills = Join-Path $codexHome 'skills'
$superSkill = Join-Path $codexSkills 'datqbox-super-orchestrator'

Write-Host '=== Codex ==='
Write-Host "CODEX_HOME: $codexHome"
Write-Host "config.toml: $(Test-Path -LiteralPath $codexConfig)"
if (Test-Path -LiteralPath $codexConfig) {
    Write-Host 'config.toml contenido:'
    Get-Content -LiteralPath $codexConfig | ForEach-Object { Write-Host "  $_" }
}

Write-Host ''
Write-Host "skills path: $(Test-Path -LiteralPath $codexSkills)"
if (Test-Path -LiteralPath $codexSkills) {
    $skills = Get-ChildItem -LiteralPath $codexSkills -Directory | Select-Object -ExpandProperty Name
    Write-Host "skills instaladas: $($skills.Count)"
    $skills | ForEach-Object { Write-Host "  - $_" }
}

Write-Host ''
Write-Host "super skill datqbox-super-orchestrator: $(Test-Path -LiteralPath $superSkill)"

Write-Host ''
Write-Host '=== VS Code Global ==='
Write-Host "prompts dir: $(Test-Path -LiteralPath $globalPrompts) -> $globalPrompts"
if (Test-Path -LiteralPath $globalPrompts) {
    $globalItems = Get-ChildItem -LiteralPath $globalPrompts -File -ErrorAction SilentlyContinue
    Write-Host "prompts/agentes globales: $($globalItems.Count)"
}
Write-Host "settings.json: $(Test-Path -LiteralPath $globalSettings) -> $globalSettings"

if (-not [string]::IsNullOrWhiteSpace($WorkspacePath) -and (Test-Path -LiteralPath $WorkspacePath)) {
    $wsVscode = Join-Path $WorkspacePath '.vscode'
    Write-Host ''
    Write-Host '=== Workspace ==='
    Write-Host "workspace: $WorkspacePath"
    Write-Host ".vscode: $(Test-Path -LiteralPath $wsVscode)"
    foreach ($folder in @('agents', 'instructions', 'prompts')) {
        $path = Join-Path $wsVscode $folder
        $exists = Test-Path -LiteralPath $path
        $count = if ($exists) { @(Get-ChildItem -LiteralPath $path -File -ErrorAction SilentlyContinue).Count } else { 0 }
        Write-Host "${folder}: $exists ($count archivos)"
    }
    $wsSettings = Join-Path $wsVscode 'settings.json'
    Write-Host "settings.json: $(Test-Path -LiteralPath $wsSettings)"
}

Write-Host ''
Write-Host 'Cómo activar super agente en chat: $datqbox-super-orchestrator'
