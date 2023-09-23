# Set Default location - edit this for your machine
Set-Location C:\Users\user\

function prompt {
  $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
  $principal = [Security.Principal.WindowsPrincipal] $identity
  $adminRole = [Security.Principal.WindowsBuiltInRole]::Administrator

  $(if (Test-Path variable:/PSDebugContext) { '[DBG]: ' }
    elseif($principal.IsInRole($adminRole)) { "[ADMIN]: " }
    else { '' }
  ) + 'PS ' + $(Get-Location) +
    $(if ($NestedPromptLevel -ge 1) { '>>' }) + '> '
}
$PSReadLineOptions = @{
    EditMode = "Vi"
    HistoryNoDuplicates = $true
    HistorySearchCursorMovesToEnd = $true
    }
}
Set-PSReadLineOption @PSReadLineOptions
# For Vi-style navigation in Powershell cli
# Set-PSReadLineOption -EditMode Vi

# Cursor change in response to vi mode change in EditMode Vi
function OnViModeChange {
    if ($args[0] -eq 'Command') {
        # Set the cursor to a blinking block.
        Write-Host -NoNewLine "`e[1 q"
    } else {
        # Set the cursor to a blinking line.
        Write-Host -NoNewLine "`e[5 q"
    }
}
Set-PSReadLineOption -ViModeIndicator Script -ViModeChangeHandler $Function:OnViModeChange

# To Esc with <Ctrl+[> in EditMode Vi
Set-PSReadLineKeyHandler -Chord 'Ctrl+Oem4' -Function ViCommandMode 

# For Commandline prediction
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
