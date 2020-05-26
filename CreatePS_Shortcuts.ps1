[CmdletBinding()]
param (
    [Parameter(ValueFromRemainingArguments=$true)]
    $Path
)

'Paths'
$Path

$DesktopPath = [Environment]::GetFolderPath("Desktop")
$PSpath = "%SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe"

foreach($P in $Path){
    
    #Create Shortcut and add Arguments
    $name = (Get-Item $P).BaseName
    $SCPath = $DesktopPath+"\"+$name+".lnk"
    
    $WshShell = New-Object -comObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($SCPath)
    $Shortcut.Arguments = "-ExecutionPolicy Bypass -File {0} -WindowStyle Hidden" -f $P
    $Shortcut.TargetPath = $PSpath
    $Shortcut.Save()
    #Make file Run as Admin
    $bytes = [System.IO.File]::ReadAllBytes($SCPath)

    #Set byte 21 (0x15) bit 6 (0x20) ON (Use –bor to set RunAsAdministrator option and –bxor to unset)
    $bytes[0x15] = $bytes[0x15] -bor 0x20 
    [System.IO.File]::WriteAllBytes($SCPath, $bytes)
    }
    