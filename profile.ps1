# Set Default location - edit this for your machine
Set-Location C:\Users\user\OneDrive

function prompt {
  $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
  $principal = [Security.Principal.WindowsPrincipal] $identity
  $adminRole = [Security.Principal.WindowsBuiltInRole]::Administrator

  $(if (Test-Path variable:/PSDebugContext) { '[DBG]: ' }
    elseif ($principal.IsInRole($adminRole)) { "[ADMIN]: " }
    else { '' }
  ) + 'PS ' + $(Get-Location) +
  $(if ($NestedPromptLevel -ge 1) { '>>' }) + '> '
}

## For Vi-style navigation in Powershell cli
#Set-PSReadLineOption -EditMode Vi
#
## Cursor change in response to vi mode change in EditMode Vi
#function OnViModeChange {
#  if ($args[0] -eq 'Command') {
#    # Set the cursor to a blinking block.
#    Write-Host -NoNewLine "`e[1 q"
#  }
#  else {
#    # Set the cursor to a blinking line.
#    Write-Host -NoNewLine "`e[5 q"
#  }
#}
#Set-PSReadLineOption -ViModeIndicator Script -ViModeChangeHandler $Function:OnViModeChange
#
## To Esc with <Ctrl+[> in EditMode Vi
#Set-PSReadLineKeyHandler -Chord 'Ctrl+Oem4' -Function ViCommandMode

# For Commandline prediction
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineOption -PredictionViewStyle ListView

# PSReadline History shared across 'signed in to Microsoft' devices, autoloads in each PowerShell session
# set the folder containing the history file to "Always keep on this device" on all machines.
Import-Module PSReadLine
Set-PSReadLineOption -HistorySavePath "C:\Users\user\OneDrive\PS-History\ConsoleHost_history.txt"

# Quote matching
Set-PSReadLineKeyHandler -Chord '"', "'" `
  -BriefDescription SmartInsertQuote `
  -LongDescription "Insert paired quotes if not already on a quote" `
  -ScriptBlock {
  param($key, $arg)

  $line = $null
  $cursor = $null
  [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

  if ($line.Length -gt $cursor -and $line[$cursor] -eq $key.KeyChar) {
    # Just move the cursor
    [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor + 1)
  }
  else {
    # Insert matching quotes, move cursor to be in between the quotes
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert("$($key.KeyChar)" * 2)
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
    [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor - 1)
  }
}

# For MenuComplete
# Set-PSReadlineKeyHandler -Chord 'Ctrl+Spacebar' -Function MenuComplete

# For linux-style sudo functionality
Import-Module "gsudoModule"
# PowerShell prompt indication that the current process has Administrative priviledges
Set-Alias Prompt gsudoPrompt

#Terminal Prompt customization with Oh My Posh
# oh-my-posh init pwsh | Invoke-Expression
#oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/jandedobbeleer.omp.json" | Invoke-Expression
