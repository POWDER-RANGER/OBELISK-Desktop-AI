<#
.SYNOPSIS
    Screen capture and description module for OBELISK
#>

Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms

function Get-Screenshot {
    [CmdletBinding()]
    param(
        [string]$OutputPath = "$env:TEMP\obelisk_screen_$(Get-Date -Format 'yyyyMMdd_HHmmss').png"
    )

    $screen = [System.Windows.Forms.SystemInformation]::VirtualScreen
    $bitmap = [System.Drawing.Bitmap]::new($screen.Width, $screen.Height)
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphics.CopyFromScreen($screen.Location, [System.Drawing.Point]::Empty, $screen.Size)
    $bitmap.Save($OutputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $graphics.Dispose()
    $bitmap.Dispose()
    
    return $OutputPath
}

function Get-ScreenDescription {
    [CmdletBinding()]
    param([PSCustomObject]$Config)

    # List open windows as a text-based screen description
    $windows = Get-OpenWindows
    $activeProcs = Get-Process | Where-Object { $_.MainWindowTitle } | 
                   Select-Object Name, @{N='Window';E={$_.MainWindowTitle}}, CPU, @{N='RAM_MB';E={[Math]::Round($_.WorkingSet64/1MB,1)}}
    
    $description = "Open Windows:`n"
    $description += ($windows | ForEach-Object { "  - $_" }) -join "`n"
    $description += "`n`nActive Processes:`n"
    $description += ($activeProcs | Format-Table -AutoSize | Out-String)
    
    return $description
}
