<#
.SYNOPSIS
    Windows UIAutomation wrapper module for OBELISK
.NOTES
    Requires .NET System.Windows.Automation (built into Windows)
#>

Add-Type -AssemblyName UIAutomationClient
Add-Type -AssemblyName UIAutomationTypes

function Find-UIElement {
    [CmdletBinding()]
    param(
        [string]$Name,
        [string]$AutomationId,
        [string]$ClassName,
        [System.Windows.Automation.AutomationElement]$Root = [System.Windows.Automation.AutomationElement]::RootElement,
        [int]$TimeoutSeconds = 5
    )

    $conditions = [System.Collections.Generic.List[System.Windows.Automation.Condition]]::new()
    
    if ($Name)         { $conditions.Add([System.Windows.Automation.PropertyCondition]::new([System.Windows.Automation.AutomationElement]::NameProperty, $Name)) }
    if ($AutomationId) { $conditions.Add([System.Windows.Automation.PropertyCondition]::new([System.Windows.Automation.AutomationElement]::AutomationIdProperty, $AutomationId)) }
    if ($ClassName)    { $conditions.Add([System.Windows.Automation.PropertyCondition]::new([System.Windows.Automation.AutomationElement]::ClassNameProperty, $ClassName)) }

    if ($conditions.Count -eq 0) { throw "Must specify at least one search criteria" }
    
    $condition = if ($conditions.Count -eq 1) { $conditions[0] }
                 else { [System.Windows.Automation.AndCondition]::new($conditions.ToArray()) }

    $deadline = (Get-Date).AddSeconds($TimeoutSeconds)
    while ((Get-Date) -lt $deadline) {
        $element = $Root.FindFirst([System.Windows.Automation.TreeScope]::Descendants, $condition)
        if ($element) { return $element }
        Start-Sleep -Milliseconds 200
    }
    
    throw "UIElement not found: Name='$Name' AutomationId='$AutomationId' ClassName='$ClassName'"
}

function Invoke-UIElementClick {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Target,
        [PSCustomObject]$Config
    )

    $element = Find-UIElement -Name $Target
    $invokePattern = $element.GetCurrentPattern([System.Windows.Automation.InvokePattern]::Pattern)
    
    if ($invokePattern) {
        $invokePattern.Invoke()
    } else {
        # Fallback: click via bounding rect center
        $rect = $element.Current.BoundingRectangle
        $centerX = [int]($rect.X + $rect.Width / 2)
        $centerY = [int]($rect.Y + $rect.Height / 2)
        Add-Type -AssemblyName System.Windows.Forms
        [System.Windows.Forms.Cursor]::Position = [System.Drawing.Point]::new($centerX, $centerY)
        Start-Sleep -Milliseconds 100
        $signature = '[DllImport("user32.dll")] public static extern void mouse_event(int dwFlags, int dx, int dy, int cButtons, int dwExtraInfo);'
        $type = Add-Type -MemberDefinition $signature -Name 'Win32MouseEvent' -Namespace Win32 -PassThru
        $type::mouse_event(0x0002, 0, 0, 0, 0)  # MOUSEEVENTF_LEFTDOWN
        $type::mouse_event(0x0004, 0, 0, 0, 0)  # MOUSEEVENTF_LEFTUP
    }
    
    if ($Config -and $Config.ui_automation.action_delay_ms) {
        Start-Sleep -Milliseconds $Config.ui_automation.action_delay_ms
    }
    
    return "Clicked: $Target"
}

function Set-UIValue {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][System.Windows.Automation.AutomationElement]$Element,
        [Parameter(Mandatory)][string]$Value
    )

    $valuePattern = $Element.GetCurrentPattern([System.Windows.Automation.ValuePattern]::Pattern)
    if ($valuePattern) {
        $valuePattern.SetValue($Value)
    } else {
        throw "Element does not support ValuePattern"
    }
}

function Get-UITree {
    [CmdletBinding()]
    param(
        [string]$WindowTitle,
        [int]$MaxDepth = 3
    )

    $root = if ($WindowTitle) {
        Find-UIElement -Name $WindowTitle
    } else {
        [System.Windows.Automation.AutomationElement]::RootElement
    }

    function Get-Children($element, $depth) {
        if ($depth -ge $MaxDepth) { return }
        $walker = [System.Windows.Automation.TreeWalker]::ControlViewWalker
        $child = $walker.GetFirstChild($element)
        while ($child) {
            $indent = '  ' * $depth
            Write-Output "$indent[$($child.Current.ControlType.ProgrammaticName)] '$($child.Current.Name)'"
            Get-Children $child ($depth + 1)
            $child = $walker.GetNextSibling($child)
        }
    }

    Get-Children $root 0
}

function Get-OpenWindows {
    return Get-Process | Where-Object { $_.MainWindowTitle } | Select-Object -ExpandProperty MainWindowTitle
}

function Set-WindowFocus {
    param([Parameter(Mandatory)][string]$Title)
    $proc = Get-Process | Where-Object { $_.MainWindowTitle -like "*$Title*" } | Select-Object -First 1
    if (-not $proc) { throw "Window not found: $Title" }
    
    $sig = '[DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr hWnd);'
    $type = Add-Type -MemberDefinition $sig -Name 'ForegroundWindow' -Namespace Win32 -PassThru
    $null = $type::SetForegroundWindow($proc.MainWindowHandle)
    return "Focused: $($proc.MainWindowTitle)"
}
