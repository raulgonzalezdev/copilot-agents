param(
    [Parameter(Mandatory = $true)]
    [string]$BundlePath,
    [string]$WorkspacePath,
    [ValidateSet('workspace', 'global', 'both')]
    [string]$InstallScope = 'both',
    [switch]$ApplyCodexAgents,
    [switch]$ApplyCodexSkills,
    [switch]$RestoreCodexConfig
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Ensure-Directory([string]$Path) {
    if (-not (Test-Path -LiteralPath $Path)) {
        New-Item -ItemType Directory -Path $Path | Out-Null
    }
}

function Copy-ChildrenIfExists([string]$SourceDir, [string]$TargetDir) {
    if (-not (Test-Path -LiteralPath $SourceDir)) {
        return $false
    }

    Ensure-Directory $TargetDir
    Copy-Item -LiteralPath (Join-Path $SourceDir '*') -Destination $TargetDir -Recurse -Force
    return $true
}

function Copy-FileIfExists([string]$Source, [string]$Target) {
    if (-not (Test-Path -LiteralPath $Source)) {
    return $false
}

function Get-JsonObjectOrEmpty([string]$Path) {
    if (-not (Test-Path -LiteralPath $Path)) {
        return [pscustomobject]@{}
    }

    $raw = Get-Content -LiteralPath $Path -Raw
    if ([string]::IsNullOrWhiteSpace($raw)) {
        return [pscustomobject]@{}
    }

    try {
        return $raw | ConvertFrom-Json
    }
    catch {
        return [pscustomobject]@{}
    }
}

function Merge-SettingsFragment([string]$FragmentPath, [string]$TargetSettingsPath) {
    if (-not (Test-Path -LiteralPath $FragmentPath)) {
        return $false
    }

    $fragmentRaw = Get-Content -LiteralPath $FragmentPath -Raw
    if ([string]::IsNullOrWhiteSpace($fragmentRaw)) {
        return $false
    }

    try {
        $fragment = $fragmentRaw | ConvertFrom-Json
    }
    catch {
        return $false
    }

    $target = Get-JsonObjectOrEmpty $TargetSettingsPath
    foreach ($prop in $fragment.PSObject.Properties) {
        $target | Add-Member -NotePropertyName $prop.Name -NotePropertyValue $prop.Value -Force
    }

    Ensure-Directory (Split-Path -Parent $TargetSettingsPath)
    $target | ConvertTo-Json -Depth 100 | Set-Content -Encoding UTF8 $TargetSettingsPath
    return $true
}

    Ensure-Directory (Split-Path -Parent $Target)
    Copy-Item -LiteralPath $Source -Destination $Target -Force
    return $true
}

if (-not (Test-Path -LiteralPath $BundlePath)) {
    throw "BundlePath no existe: $BundlePath"
}

$codeUser = Join-Path $env:APPDATA 'Code\User'
$globalPrompts = Join-Path $codeUser 'prompts'
$globalSettings = Join-Path $codeUser 'settings.json'

$codexHome = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { Join-Path $env:USERPROFILE '.codex' }
$codexConfig = Join-Path $codexHome 'config.toml'
$codexSkills = Join-Path $codexHome 'skills'
$codexAgents = Join-Path $codexHome 'agents'

if ($InstallScope -in @('workspace', 'both')) {
    if ([string]::IsNullOrWhiteSpace($WorkspacePath)) {
        throw 'Debes indicar -WorkspacePath cuando InstallScope sea workspace o both.'
    }

    if (-not (Test-Path -LiteralPath $WorkspacePath)) {
        throw "WorkspacePath no existe: $WorkspacePath"
    }

    $wsVscode = Join-Path $WorkspacePath '.vscode'
    Ensure-Directory $wsVscode

    Copy-ChildrenIfExists `
        -SourceDir (Join-Path $BundlePath 'workspace\.vscode\agents') `
        -TargetDir (Join-Path $wsVscode 'agents') | Out-Null

    Copy-ChildrenIfExists `
        -SourceDir (Join-Path $BundlePath 'workspace\.vscode\instructions') `
        -TargetDir (Join-Path $wsVscode 'instructions') | Out-Null

    Copy-ChildrenIfExists `
        -SourceDir (Join-Path $BundlePath 'workspace\.vscode\prompts') `
        -TargetDir (Join-Path $wsVscode 'prompts') | Out-Null

    Merge-SettingsFragment `
        -FragmentPath (Join-Path $BundlePath 'workspace\.vscode\settings.fragment.json') `
        -TargetSettingsPath (Join-Path $wsVscode 'settings.json') | Out-Null

    Write-Host "Workspace restaurado: $wsVscode"
}

if ($InstallScope -in @('global', 'both')) {
    Ensure-Directory $codeUser

    Copy-ChildrenIfExists `
        -SourceDir (Join-Path $BundlePath 'vscode\user\prompts') `
        -TargetDir $globalPrompts | Out-Null

    Merge-SettingsFragment `
        -FragmentPath (Join-Path $BundlePath 'vscode\user\settings.fragment.json') `
        -TargetSettingsPath $globalSettings | Out-Null

    Write-Host "VS Code global restaurado: $codeUser"
}

if ($ApplyCodexSkills) {
    Ensure-Directory $codexSkills
    Copy-ChildrenIfExists `
        -SourceDir (Join-Path $BundlePath 'codex\skills') `
        -TargetDir $codexSkills | Out-Null

    Write-Host "Skills Codex restauradas en: $codexSkills"
}

if ($ApplyCodexAgents) {
    Ensure-Directory $codexAgents
    Copy-ChildrenIfExists `
        -SourceDir (Join-Path $BundlePath 'codex\agents') `
        -TargetDir $codexAgents | Out-Null

    Write-Host "Codex agent roles restaurados en: $codexAgents"
}

if ($RestoreCodexConfig) {
    Ensure-Directory $codexHome
    Copy-FileIfExists `
        -Source (Join-Path $BundlePath 'codex\config.toml') `
        -Target $codexConfig | Out-Null

    Write-Host "config.toml restaurado en: $codexConfig"
}

Write-Host ''
Write-Host 'Import completado.'
Write-Host 'Reinicia VS Code/Codex para cargar cambios.'
