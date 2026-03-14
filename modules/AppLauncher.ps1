<#
.SYNOPSIS
    Application launch and process management for OBELISK
#>

$script:AppAliases = @{
    'notepad'     = 'notepad.exe'
    'calculator'  = 'calc.exe'
    'calc'        = 'calc.exe'
    'chrome'      = 'chrome.exe'
    'firefox'     = 'firefox.exe'
    'edge'        = 'msedge.exe'
    'explorer'    = 'explorer.exe'
    'cmd'         = 'cmd.exe'
    'powershell'  = 'powershell.exe'
    'terminal'    = 'wt.exe'
    'paint'       = 'mspaint.exe'
    'wordpad'     = 'wordpad.exe'
    'task manager'= 'taskmgr.exe'
    'taskmgr'     = 'taskmgr.exe'
    'regedit'     = 'regedit.exe'
    'vs code'     = 'code.exe'
    'vscode'      = 'code.exe'
}

function Start-ApplicationByName {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$AppName,
        [PSCustomObject]$Config
    )

    $exe = $script:AppAliases[$AppName.ToLower()]
    if (-not $exe) { $exe = $AppName }
    
    try {
        $proc = Start-Process $exe -PassThru
        Start-Sleep -Milliseconds 800  # Wait for window
        return "Launched: $AppName (PID: $($proc.Id))"
    } catch {
        throw "Failed to launch '$AppName': $_"
    }
}

function Stop-ApplicationByName {
    [CmdletBinding()]
    param([Parameter(Mandatory)][string]$AppName)

    $exe = $script:AppAliases[$AppName.ToLower()]
    $procName = if ($exe) { [System.IO.Path]::GetFileNameWithoutExtension($exe) } else { $AppName }
    
    $procs = Get-Process -Name $procName -ErrorAction SilentlyContinue
    if (-not $procs) { return "No process found matching: $AppName" }
    
    $procs | Stop-Process -Force
    return "Closed: $AppName ($($procs.Count) process(es) terminated)"
}
