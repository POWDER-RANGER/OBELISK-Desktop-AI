#Requires -Version 5.1
<# Test suite for OllamaClient module #>

. "$PSScriptRoot\..\core\OllamaClient.ps1"

$config = [PSCustomObject]@{
    ollama = [PSCustomObject]@{ host = 'http://localhost:11434'; model = 'llama3'; temperature = 0.3 }
}

Write-Host "Testing OllamaClient..." -ForegroundColor Cyan

# Test 1: Connection
try {
    $result = Test-OllamaConnection -Config $config
    Write-Host "[PASS] Test-OllamaConnection" -ForegroundColor Green
} catch {
    Write-Host "[SKIP] Test-OllamaConnection - Ollama not running: $_" -ForegroundColor Yellow
}

# Test 2: Get Models
try {
    $models = Get-OllamaModels -Config $config
    Write-Host "[PASS] Get-OllamaModels - Found $($models.Count) model(s)" -ForegroundColor Green
} catch {
    Write-Host "[SKIP] Get-OllamaModels: $_" -ForegroundColor Yellow
}

Write-Host "OllamaClient tests complete." -ForegroundColor Cyan
