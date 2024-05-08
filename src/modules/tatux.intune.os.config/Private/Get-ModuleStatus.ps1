function Get-ModuleStatus {
    param (
        [switch]$ShowMessage,

        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory)]
        [string]$ModuleName,

        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory)]
        [string]$ModulePath
    )
    try {
        # Get the current version of the installed module and check against the latest version in PSGallery, then notify the user as a warning message that an update is availible.
        $PSD1File = Join-Path -Path $ModulePath -ChildPath "$ModuleName.psd1"
        if ($ShowMessage) {
            $CurrentlyLoadedModuleVersion = (Import-PowerShellDataFile -Path $PSD1File).ModuleVersion
            $LatestModuleVersion = (Find-Module -Name $ModuleName).Version
            if ($CurrentlyLoadedModuleVersion -lt $LatestModuleVersion) {
                Write-Host -ForegroundColor Yellow "An update is available for the module '$ModuleName'. Installed version: $CurrentlyLoadedModuleVersion, Latest version: $LatestModuleVersion.`nPlease run 'Update-Module $ModuleName' to update the module."
            }
            return
        }
        else {
            return
        }
    }
    catch {
        return
    }
}