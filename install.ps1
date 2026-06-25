# switch-llm installer para Windows
$ErrorActionPreference = "Stop"

$ProvidersDir = "$env:USERPROFILE\.claude\providers"
$OpenRouterDir = "$ProvidersDir\openrouter-models"
$BinDir = "$env:USERPROFILE\.local\bin"

Write-Host ""
Write-Host "  instalando switch-llm..." -ForegroundColor Cyan
Write-Host ""

# Cria diretorios
New-Item -ItemType Directory -Force -Path $ProvidersDir | Out-Null
New-Item -ItemType Directory -Force -Path $OpenRouterDir | Out-Null
New-Item -ItemType Directory -Force -Path $BinDir | Out-Null

# Copia o script
Copy-Item -Force "provider" "$BinDir\provider"

# Cria wrapper .cmd para rodar com python
$wrapper = "@echo off`npython `"%USERPROFILE%\.local\bin\provider`" %*"
Set-Content -Path "$BinDir\provider.cmd" -Value $wrapper

# Copia providers
Get-ChildItem "providers\*.json" | ForEach-Object {
    $dest = "$ProvidersDir\$($_.Name)"
    if (-Not (Test-Path $dest)) {
        Copy-Item $_.FullName $dest
        Write-Host "  + $($_.Name)" -ForegroundColor Green
    } else {
        Write-Host "  ~ $($_.Name) (ja existe, mantido)" -ForegroundColor Yellow
    }
}

# Copia modelos OpenRouter
Get-ChildItem "providers\openrouter-models\*.json" | ForEach-Object {
    $dest = "$OpenRouterDir\$($_.Name)"
    if (-Not (Test-Path $dest)) {
        Copy-Item $_.FullName $dest
        Write-Host "  + openrouter-models\$($_.Name)" -ForegroundColor Green
    }
}

# Adiciona ao PATH do usuario
$currentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
if ($currentPath -notlike "*$BinDir*") {
    [Environment]::SetEnvironmentVariable("PATH", "$BinDir;$currentPath", "User")
    Write-Host "  + PATH configurado" -ForegroundColor Green
}

Write-Host ""
Write-Host "  Instalacao concluida!" -ForegroundColor Green
Write-Host ""
Write-Host "  Proximos passos:"
Write-Host "  1. Abra um novo terminal"
Write-Host "  2. Digite: provider"
Write-Host "  3. Edite cada provider para adicionar sua API key"
Write-Host ""
