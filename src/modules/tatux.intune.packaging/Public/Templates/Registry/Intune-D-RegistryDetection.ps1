# Intune detection script to check if the application is installed using the version info in the config.installer.json file

# App name and version as per config.installer.json
$AppName = "##NAME_TEMPLATE"
$Version = "##VERSION_TEMPLATE"
$APFBase = "APF"

# Paths to check for the version info file
$PathsToCheck = @("${env:ProgramFiles(x86)}\$APFBase\AppConfigs\$($AppName)_config.installer.json")
$PathsToCheck += Get-ChildItem -Path "c:\Users\*\AppData\Roaming\$APFBase\AppConfigs\$($AppName)_config.installer.json" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty FullName

foreach ($Path in $PathsToCheck) {
    if (Test-Path -Path $Path) {
        $VersionInfo = Get-Content -Path $Path | ConvertFrom-Json
        if ($VersionInfo.version -eq $Version) {
            Write-Output "The version file exists and the version is correct"
            
            
            exit 0
        }
        else {
            Write-Output "The version file exists but the version is incorrect"
            exit 1
        }
    }
}

# If the script hasn't exited by this point, the version file does not exist
Write-Output "The version file does not exist"
exit 1