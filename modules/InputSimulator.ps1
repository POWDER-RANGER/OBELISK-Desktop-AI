<#
.SYNOPSIS
    Keyboard and text input simulation for OBELISK
#>

Add-Type -AssemblyName System.Windows.Forms

function Send-TextInput {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Text,
        [PSCustomObject]$Config,
        [int]$DelayMs = 0
    )

    [System.Windows.Forms.SendKeys]::SendWait($Text)
    
    if ($DelayMs -gt 0) { Start-Sleep -Milliseconds $DelayMs }
    elseif ($Config -and $Config.ui_automation.action_delay_ms) {
        Start-Sleep -Milliseconds $Config.ui_automation.action_delay_ms
    }
    
    return "Typed: $($Text.Substring(0, [Math]::Min(50, $Text.Length)))$(if ($Text.Length -gt 50) {'...'})"
}

function Send-KeyPress {
    param(
        [Parameter(Mandatory)][string]$Key
    )
    [System.Windows.Forms.SendKeys]::SendWait($Key)
}

function Send-HotKey {
    param(
        [Parameter(Mandatory)][string]$Modifier,  # ctrl, alt, shift
        [Parameter(Mandatory)][string]$Key
    )
    
    $modMap = @{ 'ctrl' = '^'; 'alt' = '%'; 'shift' = '+' }
    $mod = $modMap[$Modifier.ToLower()]
    if (-not $mod) { throw "Unknown modifier: $Modifier" }
    
    [System.Windows.Forms.SendKeys]::SendWait("$mod$Key")
}
