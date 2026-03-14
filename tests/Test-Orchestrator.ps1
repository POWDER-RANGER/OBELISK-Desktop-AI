#Requires -Version 5.1
<# Test suite for Orchestrator module #>

. "$PSScriptRoot\..\core\OllamaClient.ps1"
. "$PSScriptRoot\..\core\SessionManager.ps1"
. "$PSScriptRoot\..\core\Orchestrator.ps1"
. "$PSScriptRoot\..\modules\UIAutomation.ps1"
. "$PSScriptRoot\..\modules\AppLauncher.ps1"
. "$PSScriptRoot\..\modules\InputSimulator.ps1"
. "$PSScriptRoot\..\modules\ScreenReader.ps1"

$config = Get-Content "$PSScriptRoot\..\config\settings.json" -Raw | ConvertFrom-Json
$session = Initialize-Session -Config $config

Write-Host "Testing Orchestrator..." -ForegroundColor Cyan

# Test 1: Session initialization
try {
    if ($session.History -is [System.Collections.Generic.List[string]]) {
        Write-Host "[PASS] Initialize-Session" -ForegroundColor Green
    }
} catch {
    Write-Host "[FAIL] Initialize-Session: $_" -ForegroundColor Red
}

# Test 2: Session history
try {
    Add-SessionHistory -Session $session -Entry 'test command'
    if ($session.History.Count -eq 1) {
        Write-Host "[PASS] Add-SessionHistory" -ForegroundColor Green
    }
} catch {
    Write-Host "[FAIL] Add-SessionHistory: $_" -ForegroundColor Red
}

Write-Host "Orchestrator tests complete." -ForegroundColor Cyan
