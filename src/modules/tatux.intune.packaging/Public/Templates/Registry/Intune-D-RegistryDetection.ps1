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

        $ConfigBase = if ($VersionInfo.target -eq "user") { $env:APPDATA } else { ${env:ProgramFiles(x86)} }
        $APFFullBase = Join-Path -Path $ConfigBase -ChildPath $APFBase
        $StorageFolderBase = "PersistentStorage"
        $StorageFolderName = $(if ([string]::IsNullOrEmpty($ConfigBase.name)) {"registry"} {"$($ConfigBase.name)"})
        $StorageFolderFullPath = Join-Path -Path $APFFullBase -ChildPath "$StorageFolderBase\$StorageFolderName"
        $RegistryCSVFilePath = "$StorageFolderFullPath\$($InstallConfig.name)_Registry.csv"

        if ($VersionInfo.version -eq $Version) {
            Write-Output "The version file exists and the version is correct"
            Write-Output "Now checking if deployment was successful depending on results in the registry CSV."
            $Props = @{
                KeyName = $AppName
                Result = ""
                Error = ""
            }
            $OutputResults = @()
            $OverAllResult = $true

            if (Test-Path -Path $RegistryCSVFilePath) {
                $RegistryCSV = Import-Csv -Path $RegistryCSVFilePath
                $RegistryCSV | ForEach-Object {
                    if ($_.Result -ne "Success") {
                        $obj = New-Object -TypeName PSObject -Property $Props
                        $obj.Result = $_.Result
                        $obj.KeyName = "$($_.RegistryPath)\$($_.KeyName)\$($_.ValueName)"
                        $obj.Error = $_.Error
                        $OutputResults += $obj
                        $OverAllResult = $false
                    }
                }
                if ($OverAllResult) {
                    Write-Output "The deployment was successful"
                    exit 0
                } else {
                    Write-Output "The deployment was not successful"
                    Write-Output $OutputResults
                    exit 1
                }
            } else {
                Write-Output "The registry CSV file does not exist"
                exit 1
            }
            
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