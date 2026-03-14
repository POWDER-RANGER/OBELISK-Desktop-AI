#Requires -Version 5.1
<#
.SYNOPSIS
    OBELISK-Desktop-AI - Natural language desktop automation via Ollama + UIAutomation
.DESCRIPTION
    Entry point REPL. Type natural language commands to automate Windows applications.
.EXAMPLE
    .\OBELISK.ps1
    .\OBELISK.ps1 -Model "mistral" -Verbose
#>
[CmdletBinding()]
param(
    [string]$Model = "",
    [string]$ConfigPath = "$PSScriptRoot\config\settings.json",
    [switch]$NoColor
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# Load modules
. "$PSScriptRoot\core\Orchestrator.ps1"
. "$PSScriptRoot\core\OllamaClient.ps1"
. "$PSScriptRoot\core\SessionManager.ps1"
. "$PSScriptRoot\modules\UIAutomation.ps1"
. "$PSScriptRoot\modules\AppLauncher.ps1"
. "$PSScriptRoot\modules\InputSimulator.ps1"
. "$PSScriptRoot\modules\ScreenReader.ps1"

# Load config
if (Test-Path $ConfigPath) {
    $script:Config = Get-Content $ConfigPath -Raw | ConvertFrom-Json
} else {
    Write-Warning "Config not found at $ConfigPath. Using defaults."
    $script:Config = [PSCustomObject]@{
        ollama = [PSCustomObject]@{ host = 'http://localhost:11434'; model = 'llama3'; temperature = 0.3 }
        ui_automation = [PSCustomObject]@{ action_delay_ms = 150; screenshot_on_error = $true; verbose_logging = $false }
        session = [PSCustomObject]@{ max_history = 50; persist_context = $true }
    }
}

# Override model if specified
if ($Model) { $script:Config.ollama.model = $Model }

function Write-ObeliskBanner {
    $banner = @"
  ___  ____  ____  _    _  ____  _  _ 
 / _ \| __ )| ___|| |  | |/ ___|| |/ /
| | | |  _ \|  _|  | |  | |\___ \| ' / 
| |_| | |_) | |___  | |__| | ___) | . \ 
 \___/|____/|_____|  \____/ |____/|_|\_\

  Desktop AI Orchestrator  |  Ollama + UIAutomation
  Model: $($script:Config.ollama.model)  |  Type 'help' for commands
"@
    Write-Host $banner -ForegroundColor Cyan
}

function Show-Help {
    Write-Host ""
    Write-Host "OBELISK Commands:" -ForegroundColor Yellow
    Write-Host "  help           - Show this help"
    Write-Host "  models         - List available Ollama models"
    Write-Host "  model <name>   - Switch active model"
    Write-Host "  history        - Show command history"
    Write-Host "  clear          - Clear session context"
    Write-Host "  exit / quit    - Exit OBELISK"
    Write-Host ""
    Write-Host "Natural language examples:"
    Write-Host "  'open notepad'"
    Write-Host "  'type hello world in the current window'"
    Write-Host "  'click the OK button'"
    Write-Host "  'what apps are currently open?'"
    Write-Host "  'close calculator'"
    Write-Host ""
}

# Startup
Write-ObeliskBanner

# Test Ollama connection
try {
    $null = Test-OllamaConnection -Config $script:Config
    Write-Host "[OK] Ollama connected at $($script:Config.ollama.host)" -ForegroundColor Green
} catch {
    Write-Warning "Ollama not reachable at $($script:Config.ollama.host). Start with: ollama serve"
}

$session = Initialize-Session -Config $script:Config

# Main REPL loop
while ($true) {
    Write-Host ""
    $input = Read-Host "OBELISK"
    
    if ([string]::IsNullOrWhiteSpace($input)) { continue }
    
    switch ($input.Trim().ToLower()) {
        'exit'  { Write-Host "Goodbye." -ForegroundColor Cyan; break }
        'quit'  { Write-Host "Goodbye." -ForegroundColor Cyan; break }
        'help'  { Show-Help; continue }
        'clear' { $session = Initialize-Session -Config $script:Config; Write-Host "Session cleared." -ForegroundColor Yellow; continue }
        'history' {
            $session.History | ForEach-Object { Write-Host "  > $_" -ForegroundColor DarkGray }
            continue
        }
        'models' {
            try {
                $models = Get-OllamaModels -Config $script:Config
                $models | ForEach-Object { Write-Host "  - $($_.name)" -ForegroundColor White }
            } catch { Write-Warning "Could not retrieve models: $_" }
            continue
        }
        default {
            if ($input -match '^model\s+(\S+)$') {
                $script:Config.ollama.model = $Matches[1]
                Write-Host "Model switched to: $($script:Config.ollama.model)" -ForegroundColor Green
                continue
            }
            # Route to orchestrator
            try {
                $result = Invoke-OrchestratorAction -Input $input -Session $session -Config $script:Config
                Add-SessionHistory -Session $session -Entry $input
                if ($result.Output) {
                    Write-Host $result.Output -ForegroundColor White
                }
            } catch {
                Write-Host "[ERROR] $_" -ForegroundColor Red
                if ($script:Config.ui_automation.screenshot_on_error) {
                    Write-Host "Tip: Check that the target application is open and in focus." -ForegroundColor DarkYellow
                }
            }
        }
    }
    
    if ($input.Trim().ToLower() -in @('exit','quit')) { break }
}
