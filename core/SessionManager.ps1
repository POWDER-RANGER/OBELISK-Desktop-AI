<#
.SYNOPSIS
    Session state management for OBELISK conversations
#>

function Initialize-Session {
    [CmdletBinding()]
    param([Parameter(Mandatory)][PSCustomObject]$Config)

    return @{
        Id          = [System.Guid]::NewGuid().ToString()
        StartedAt   = Get-Date
        History     = [System.Collections.Generic.List[string]]::new()
        MaxHistory  = $Config.session.max_history
        Context     = @{}
    }
}

function Add-SessionHistory {
    param(
        [Parameter(Mandatory)][hashtable]$Session,
        [Parameter(Mandatory)][string]$Entry
    )
    
    $Session.History.Add($Entry)
    
    # Trim to max history
    while ($Session.History.Count -gt $Session.MaxHistory) {
        $Session.History.RemoveAt(0)
    }
}

function Export-Session {
    param(
        [Parameter(Mandatory)][hashtable]$Session,
        [string]$Path = "$env:TEMP\obelisk_session_$($Session.Id).json"
    )
    
    $Session | ConvertTo-Json -Depth 5 | Set-Content $Path
    Write-Verbose "Session saved to $Path"
    return $Path
}
