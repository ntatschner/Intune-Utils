# Intune detection script to check if the application is installed using the version info in the config.installer.json file

# App name and version as per config.installer.json
$AppName = ""
$Version = ""
$APFBase = "APF"

# Paths to check for the version info file
$PathsToCheck = @("${env:ProgramFiles(x86)}\$APFBase\AppConfigs\$($AppName)_config.installer.json")
$PathsToCheck += Get-ChildItem -Path "c:\Users\*\AppData\Roaming\$APFBase\AppConfigs\$($AppName)_config.installer.json" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty FullName

foreach ($Path in $PathsToCheck) {
    if (Test-Path -Path $Path) {
        $VersionInfo = Get-Content -Path $Path | ConvertFrom-Json
        if ($VersionInfo.version -eq $Version) {
            switch ($VersionInfo.target) {
                "user" {
                    if ($Path -like "c:\Users\*") {
                        Write-Output "The application is installed for the current user and matches the required version on file $Path"
                        exit 0
                    }
                }
                "system" {
                    if ($Path -like "${env:ProgramFiles(x86)}\*") {
                        Write-Output "The application is installed for all users and matches the required version on file $Path"
                        exit 0
                    } elseif ($Path -like "${env:ProgramFiles}\*") {
                        Write-Output "The application is installed for all users and matches the required version on file $Path"
                        exit 0
                    }
                }
                default {
                    Write-Output "Unknown target in the version info file $Path"
                    exit 1
                }
            }
        } else {
            # Test if installed version is greater than required version
            $InstalledVersion = $VersionInfo.version
            $RequiredVersion = $Version
            if ([version]$InstalledVersion -gt [version]$RequiredVersion) {
                Write-Output "The application is installed and the installed version is greater than the required version on file $Path"
                exit 0
            } else {
                Write-Output "The version info does not match the required version on file $Path"
                exit 1
            }
        }
    }
}

# If the script hasn't exited by this point, the version file does not exist
Write-Output "The version file does not exist"
exit 1