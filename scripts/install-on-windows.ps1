param(
    [string]$WorkspacePath,
    [ValidateSet('workspace','global','both')]
    [string]$InstallScope = 'both',
    [switch]$ConfigureSettings
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Split-Path -Parent $scriptRoot

$agentsSrc = Join-Path $repoRoot 'agents'
$instructionsSrc = Join-Path $repoRoot 'instructions'
$promptsSrc = Join-Path $repoRoot 'prompts'

$codeUser = Join-Path $env:APPDATA 'Code\User'
$globalPrompts = Join-Path $codeUser 'prompts'

function Ensure-Directory([string]$Path) {
    if (-not (Test-Path $Path)) {
        New-Item -ItemType Directory -Path $Path | Out-Null
    }
}

function Copy-PackToWorkspace([string]$WsPath) {
    $vscode = Join-Path $WsPath '.vscode'
    $wsAgents = Join-Path $vscode 'agents'
    $wsInstructions = Join-Path $vscode 'instructions'
    $wsPrompts = Join-Path $vscode 'prompts'

    Ensure-Directory $wsAgents
    Ensure-Directory $wsInstructions
    Ensure-Directory $wsPrompts

    Copy-Item (Join-Path $agentsSrc '*.agent.md') $wsAgents -Force
    Copy-Item (Join-Path $instructionsSrc '*.instructions.md') $wsInstructions -Force
    Copy-Item (Join-Path $promptsSrc '*.prompt.md') $wsPrompts -Force

    Write-Host "Workspace instalado en: $vscode"
}

function Copy-PackToGlobal {
    Ensure-Directory $globalPrompts

    Copy-Item (Join-Path $agentsSrc '*.agent.md') $globalPrompts -Force
    Copy-Item (Join-Path $instructionsSrc '*.instructions.md') $globalPrompts -Force
    Copy-Item (Join-Path $promptsSrc '*.prompt.md') $globalPrompts -Force

    Write-Host "Global instalado en: $globalPrompts"
}

function Get-JsonOrEmptyObject([string]$Path) {
    if (-not (Test-Path $Path)) {
        return [pscustomobject]@{}
    }

    $raw = Get-Content $Path -Raw
    if ([string]::IsNullOrWhiteSpace($raw)) {
        return [pscustomobject]@{}
    }

    try {
        return $raw | ConvertFrom-Json
    }
    catch {
        throw "No se pudo parsear JSON en: $Path. Revisa formato y vuelve a ejecutar."
    }
}

function Set-JsonProperty([object]$Object, [string]$Name, [object]$Value) {
    $Object | Add-Member -NotePropertyName $Name -NotePropertyValue $Value -Force
}

function Update-WorkspaceSettings([string]$WsPath) {
    $settingsPath = Join-Path $WsPath '.vscode\settings.json'
    Ensure-Directory (Split-Path -Parent $settingsPath)

    $json = Get-JsonOrEmptyObject $settingsPath

    Set-JsonProperty $json 'chat.agentFilesLocations' @('.vscode/prompts', '.vscode/agents')
    Set-JsonProperty $json 'chat.instructionsFilesLocations' @('.vscode/prompts', '.vscode/instructions')
    Set-JsonProperty $json 'chat.promptFilesLocations' @('.vscode/prompts')
    Set-JsonProperty $json 'github.copilot.chat.codeGeneration.useInstructionFiles' $true

    $json | ConvertTo-Json -Depth 100 | Set-Content -Encoding UTF8 $settingsPath
    Write-Host "Workspace settings actualizado: $settingsPath"
}

function Update-GlobalSettings {
    $settingsPath = Join-Path $codeUser 'settings.json'
    Ensure-Directory (Split-Path -Parent $settingsPath)

    $json = Get-JsonOrEmptyObject $settingsPath

    Set-JsonProperty $json 'github.copilot.chat.codeGeneration.useInstructionFiles' $true
    Set-JsonProperty $json 'chat.agentFilesLocations' @($globalPrompts, '.vscode/prompts', '.vscode/agents')
    Set-JsonProperty $json 'chat.instructionsFilesLocations' @($globalPrompts, '.vscode/prompts', '.vscode/instructions')
    Set-JsonProperty $json 'chat.promptFilesLocations' @($globalPrompts, '.vscode/prompts')

    $json | ConvertTo-Json -Depth 100 | Set-Content -Encoding UTF8 $settingsPath
    Write-Host "Global settings actualizado: $settingsPath"
}

if ($InstallScope -in @('workspace','both')) {
    if ([string]::IsNullOrWhiteSpace($WorkspacePath)) {
        throw 'Debes indicar -WorkspacePath cuando InstallScope sea workspace o both.'
    }

    if (-not (Test-Path $WorkspacePath)) {
        throw "WorkspacePath no existe: $WorkspacePath"
    }

    Copy-PackToWorkspace -WsPath $WorkspacePath
    if ($ConfigureSettings) {
        Update-WorkspaceSettings -WsPath $WorkspacePath
    }
}

if ($InstallScope -in @('global','both')) {
    Copy-PackToGlobal
    if ($ConfigureSettings) {
        Update-GlobalSettings
    }
}

Write-Host ''
Write-Host 'Instalación completada.'
Write-Host 'Siguiente paso: en VS Code ejecuta "Developer: Reload Window".'
