#Requires -Version 5.1
<# Test suite for UIAutomation module #>

. "$PSScriptRoot\..\modules\UIAutomation.ps1"

Write-Host "Testing UIAutomation module..." -ForegroundColor Cyan

# Test 1: Get open windows
try {
    $windows = Get-OpenWindows
    Write-Host "[PASS] Get-OpenWindows - Found $($windows.Count) window(s)" -ForegroundColor Green
} catch {
    Write-Host "[FAIL] Get-OpenWindows: $_" -ForegroundColor Red
}

# Test 2: Launch and find Notepad
try {
    $proc = Start-Process notepad.exe -PassThru
    Start-Sleep -Milliseconds 1000
    $el = Find-UIElement -Name 'Notepad' -TimeoutSeconds 5
    Write-Host "[PASS] Find-UIElement (Notepad found)" -ForegroundColor Green
    $proc | Stop-Process -Force
} catch {
    Write-Host "[FAIL] Find-UIElement: $_" -ForegroundColor Red
}

Write-Host "UIAutomation tests complete." -ForegroundColor Cyan
