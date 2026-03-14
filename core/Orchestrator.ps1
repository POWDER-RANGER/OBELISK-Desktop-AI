<#
.SYNOPSIS
    OBELISK Orchestrator - Routes natural language to UI automation actions
#>

function Invoke-OrchestratorAction {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Input,
        [Parameter(Mandatory)][hashtable]$Session,
        [Parameter(Mandatory)][PSCustomObject]$Config
    )

    # Build context-aware prompt for the LLM
    $systemPrompt = @"
You are OBELISK, a Windows desktop automation AI. Parse the user's natural language command and respond with a JSON action plan.

Available actions:
- launch_app: { "app": "appname" }
- close_app: { "app": "appname" }
- type_text: { "text": "content to type" }
- click_element: { "target": "button/element name" }
- read_screen: {}
- list_windows: {}
- focus_window: { "title": "window title" }
- custom_script: { "description": "what to do" }

Respond ONLY with valid JSON in this format:
{ "action": "action_name", "params": {}, "explanation": "brief description" }
"@

    $messages = @(
        @{ role = 'system'; content = $systemPrompt }
    )
    
    # Add recent history for context
    if ($Session.History.Count -gt 0) {
        $recentHistory = $Session.History | Select-Object -Last 5
        $historyContext = "Recent commands: " + ($recentHistory -join " | ")
        $messages += @{ role = 'user'; content = $historyContext }
        $messages += @{ role = 'assistant'; content = 'Understood, I have context from recent commands.' }
    }
    
    $messages += @{ role = 'user'; content = $Input }

    # Get LLM action plan
    $response = Invoke-OllamaChat -Messages $messages -Config $Config
    
    # Parse JSON response
    try {
        $actionPlan = $response | ConvertFrom-Json
    } catch {
        # Fallback: treat as direct text response
        return @{ Output = $response; Action = 'text_response' }
    }

    Write-Verbose "Action: $($actionPlan.action) | $($actionPlan.explanation)"

    # Execute action
    $output = switch ($actionPlan.action) {
        'launch_app'    { Start-ApplicationByName -AppName $actionPlan.params.app -Config $Config }
        'close_app'     { Stop-ApplicationByName -AppName $actionPlan.params.app }
        'type_text'     { Send-TextInput -Text $actionPlan.params.text -Config $Config }
        'click_element' { Invoke-UIElementClick -Target $actionPlan.params.target -Config $Config }
        'read_screen'   { Get-ScreenDescription -Config $Config }
        'list_windows'  { Get-OpenWindows | ForEach-Object { "  - $_" } | Out-String }
        'focus_window'  { Set-WindowFocus -Title $actionPlan.params.title }
        default         { "Action '$($actionPlan.action)' noted: $($actionPlan.explanation)" }
    }

    return @{
        Output  = if ($output) { $output } else { "✓ $($actionPlan.explanation)" }
        Action  = $actionPlan.action
        Plan    = $actionPlan
    }
}
