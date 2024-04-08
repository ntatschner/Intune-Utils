# Importing the Logging function
try {
    Import-Module -Name "$PSScriptRoot\Write-DeploymentLog.ps1" -ErrorAction Stop
}
Catch {
    Write-Host "Failed to import the logging function with error: $_"
    exit 1
}

# Importing the install configuration json file
$InstallConfig = Get-Content -Path "$PSScriptRoot\config.installer.json" | ConvertFrom-Json

# Global Variables
$ConfigBase = if ($InstallConfig.target -eq "user") { $env:APPDATA } else { ${env:ProgramFiles(x86)} }
$APFBase = "APF"
$InvalidChars = [System.IO.Path]::GetInvalidFileNameChars()
$Extention = $InstallConfig.filename -split "\." | Select-Object -Last 1
$LogName = $InstallConfig.filename.Replace($Extention, "log")
$InvalidChars | % { $LogName = $LogName -replace [regex]::Escape($_), "" }
$LoggingPath = Join-Path -Path (Join-Path -Path $ConfigBase -ChildPath "\$APFBase\UserLogs\") -ChildPath $LogName
$StartTime = Get-Date

Write-DeploymentLog -Message "Inside Post-Install script" -MessageType "Info" -LogPath $LoggingPath

 # --------------------------------------------------------------------------------------------
 # Place your custom code below,
 # ensuring to exit appropiatly with exit 0 for success and exit 1 for failure.
 # I've incuded some boilerplate above, including logging and the config file import.
 # --------------------------------------------------------------------------------------------