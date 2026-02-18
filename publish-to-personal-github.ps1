param(
  [string]$Repo = "recordgo-copilot-agents"
)

$target = "c:\expertone\RecordGoErpProxy\agent-pack-for-github"
Set-Location $target

if (-not (Test-Path ".git")) {
  git init
}

git add .
git commit -m "feat: add RecordGo custom agents pack" 2>$null
if ($LASTEXITCODE -ne 0) {
  Write-Host "No hay cambios para commitear o el commit ya existe. Continuando..."
}

git branch -M main

$remoteUrl = "https://github.com/raulgonzalezdev/$Repo.git"
$hasOrigin = git remote | Select-String -Pattern "^origin$"
if ($hasOrigin) {
  git remote set-url origin $remoteUrl
} else {
  git remote add origin $remoteUrl
}

git push -u origin main
Write-Host "Publicado en $remoteUrl"
