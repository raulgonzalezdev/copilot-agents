Set-StrictMode -Version Latest
$ErrorActionPreference = 'Continue'

Write-Host '=== OpenClaw Quick Check ==='
Write-Host ''

$commands = @(
    'openclaw --version',
    'openclaw status',
    'openclaw health',
    'openclaw channels list',
    'openclaw channels status',
    'openclaw skills check',
    'openclaw security audit'
)

foreach ($command in $commands) {
    Write-Host "`n>>> $command" -ForegroundColor Cyan
    try {
        Invoke-Expression $command
    }
    catch {
        Write-Host "Error ejecutando: $command" -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor DarkRed
    }
}

Write-Host ''
Write-Host 'Sugerencia:' -ForegroundColor Yellow
Write-Host '1) Ejecuta openclaw doctor --deep'
Write-Host '2) Configura 1 canal (telegram/discord/whatsapp)'
Write-Host '3) Vuelve a correr este script para confirmar estado'
