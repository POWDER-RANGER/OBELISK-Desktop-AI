<#
.SYNOPSIS
    Ollama REST API client for OBELISK
#>

function Invoke-OllamaChat {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][array]$Messages,
        [Parameter(Mandatory)][PSCustomObject]$Config
    )

    $body = @{
        model    = $Config.ollama.model
        messages = $Messages
        stream   = $false
        options  = @{ temperature = $Config.ollama.temperature }
    } | ConvertTo-Json -Depth 10

    try {
        $response = Invoke-RestMethod `
            -Uri "$($Config.ollama.host)/api/chat" `
            -Method Post `
            -Body $body `
            -ContentType 'application/json' `
            -TimeoutSec 60
        
        return $response.message.content
    } catch {
        throw "Ollama API error: $_"
    }
}

function Invoke-OllamaGenerate {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Prompt,
        [Parameter(Mandatory)][PSCustomObject]$Config
    )

    $body = @{
        model  = $Config.ollama.model
        prompt = $Prompt
        stream = $false
    } | ConvertTo-Json

    $response = Invoke-RestMethod `
        -Uri "$($Config.ollama.host)/api/generate" `
        -Method Post `
        -Body $body `
        -ContentType 'application/json' `
        -TimeoutSec 60
    
    return $response.response
}

function Get-OllamaModels {
    [CmdletBinding()]
    param([Parameter(Mandatory)][PSCustomObject]$Config)
    
    $response = Invoke-RestMethod `
        -Uri "$($Config.ollama.host)/api/tags" `
        -Method Get `
        -TimeoutSec 10
    
    return $response.models
}

function Test-OllamaConnection {
    [CmdletBinding()]
    param([Parameter(Mandatory)][PSCustomObject]$Config)
    
    try {
        $null = Invoke-RestMethod -Uri $Config.ollama.host -Method Get -TimeoutSec 5
        return $true
    } catch {
        throw "Cannot connect to Ollama at $($Config.ollama.host)"
    }
}
