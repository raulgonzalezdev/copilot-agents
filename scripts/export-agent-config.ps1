param(
    [string]$WorkspacePath,
    [string]$OutputRoot,
    [switch]$CreateZip
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Ensure-Directory([string]$Path) {
    if (-not (Test-Path -LiteralPath $Path)) {
        New-Item -ItemType Directory -Path $Path | Out-Null
    }
}

function Copy-DirectoryIfExists([string]$Source, [string]$Target) {
    if (Test-Path -LiteralPath $Source) {
        Ensure-Directory (Split-Path -Parent $Target)
        Copy-Item -LiteralPath $Source -Destination $Target -Recurse -Force
        return $true
    }

    return $false
}

function Copy-FileIfExists([string]$Source, [string]$Target) {
    if (Test-Path -LiteralPath $Source) {
        Ensure-Directory (Split-Path -Parent $Target)
        Copy-Item -LiteralPath $Source -Destination $Target -Force
        return $true
    }

    return $false
}

function Export-SettingsFragment([string]$SourcePath, [string]$TargetPath, [string[]]$Keys) {
    if (-not (Test-Path -LiteralPath $SourcePath)) {
        return $false
    }

    $raw = Get-Content -LiteralPath $SourcePath -Raw
    if ([string]::IsNullOrWhiteSpace($raw)) {
        return $false
    }

    try {
        $json = $raw | ConvertFrom-Json
    }
    catch {
        return $false
    }

    $fragment = [ordered]@{}
    foreach ($key in $Keys) {
        $prop = $json.PSObject.Properties[$key]
        if ($null -ne $prop) {
            $fragment[$key] = $prop.Value
        }
    }

    if ($fragment.Count -eq 0) {
        return $false
    }

    Ensure-Directory (Split-Path -Parent $TargetPath)
    $fragment | ConvertTo-Json -Depth 100 | Set-Content -Encoding UTF8 $TargetPath
    return $true
}

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Split-Path -Parent $scriptRoot

if ([string]::IsNullOrWhiteSpace($OutputRoot)) {
    $OutputRoot = Join-Path $repoRoot 'exports'
}

$codeUser = Join-Path $env:APPDATA 'Code\User'
$globalPrompts = Join-Path $codeUser 'prompts'
$globalSettings = Join-Path $codeUser 'settings.json'

$codexHome = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { Join-Path $env:USERPROFILE '.codex' }
$codexConfig = Join-Path $codexHome 'config.toml'
$codexSkills = Join-Path $codexHome 'skills'
$codexAgents = Join-Path $codexHome 'agents'

$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$bundleDir = Join-Path $OutputRoot "agent-config-$stamp"
Ensure-Directory $bundleDir

$exported = [ordered]@{
    createdAt = (Get-Date).ToString('o')
    machine = $env:COMPUTERNAME
    user = $env:USERNAME
    workspacePath = $WorkspacePath
    exported = [ordered]@{
        globalPrompts = $false
        globalSettings = $false
        workspaceAgents = $false
        workspaceInstructions = $false
        workspacePrompts = $false
        workspaceSettings = $false
        codexConfig = $false
        codexAgents = $false
        codexSkills = @()
    }
}

$settingsKeys = @(
    'github.copilot.chat.codeGeneration.useInstructionFiles',
    'chat.agentFilesLocations',
    'chat.instructionsFilesLocations',
    'chat.promptFilesLocations',
    'github.copilot.chat.mcp.servers'
)

# VS Code global
$exported.exported.globalPrompts = Copy-DirectoryIfExists `
    -Source $globalPrompts `
    -Target (Join-Path $bundleDir 'vscode\user\prompts')

$exported.exported.globalSettings = Export-SettingsFragment `
    -Source $globalSettings `
    -Target (Join-Path $bundleDir 'vscode\user\settings.fragment.json') `
    -Keys $settingsKeys

# Workspace .vscode
if (-not [string]::IsNullOrWhiteSpace($WorkspacePath) -and (Test-Path -LiteralPath $WorkspacePath)) {
    $wsVscode = Join-Path $WorkspacePath '.vscode'
    $exported.exported.workspaceAgents = Copy-DirectoryIfExists `
        -Source (Join-Path $wsVscode 'agents') `
        -Target (Join-Path $bundleDir 'workspace\.vscode\agents')
    $exported.exported.workspaceInstructions = Copy-DirectoryIfExists `
        -Source (Join-Path $wsVscode 'instructions') `
        -Target (Join-Path $bundleDir 'workspace\.vscode\instructions')
    $exported.exported.workspacePrompts = Copy-DirectoryIfExists `
        -Source (Join-Path $wsVscode 'prompts') `
        -Target (Join-Path $bundleDir 'workspace\.vscode\prompts')
    $exported.exported.workspaceSettings = Export-SettingsFragment `
        -Source (Join-Path $wsVscode 'settings.json') `
        -Target (Join-Path $bundleDir 'workspace\.vscode\settings.fragment.json') `
        -Keys $settingsKeys
}

# Codex config
$exported.exported.codexConfig = Copy-FileIfExists `
    -Source $codexConfig `
    -Target (Join-Path $bundleDir 'codex\config.toml')

$exported.exported.codexAgents = Copy-DirectoryIfExists `
    -Source $codexAgents `
    -Target (Join-Path $bundleDir 'codex\agents')

# Codex skills (exclude .system)
if (Test-Path -LiteralPath $codexSkills) {
    $skillsTarget = Join-Path $bundleDir 'codex\skills'
    Ensure-Directory $skillsTarget

    Get-ChildItem -LiteralPath $codexSkills -Directory |
        Where-Object { $_.Name -ne '.system' } |
        ForEach-Object {
            Copy-Item -LiteralPath $_.FullName -Destination (Join-Path $skillsTarget $_.Name) -Recurse -Force
            $exported.exported.codexSkills += $_.Name
        }
}

$manifestPath = Join-Path $bundleDir 'manifest.json'
$exported | ConvertTo-Json -Depth 20 | Set-Content -Encoding UTF8 $manifestPath

if ($CreateZip) {
    $zipPath = "$bundleDir.zip"
    if (Test-Path -LiteralPath $zipPath) {
        Remove-Item -LiteralPath $zipPath -Force
    }

    Compress-Archive -Path (Join-Path $bundleDir '*') -DestinationPath $zipPath -Force
    Write-Host "Bundle ZIP: $zipPath"
}

Write-Host "Bundle folder: $bundleDir"
Write-Host 'Export completado.'
