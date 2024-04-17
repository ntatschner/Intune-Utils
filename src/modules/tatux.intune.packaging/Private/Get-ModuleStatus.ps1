function Get-ModuleStatus {
    param (
        [switch]$ShowMessage
    )
    try {
        # Get the current version of the installed module and check against the latest version in PSGallery, then notify the user as a warning message that an update is availible.
        $ModuleBasePath = $(Split-Path -Path $PSScriptRoot -Parent)
        Write-Output $ModuleBasePath
        $ModuleName = Get-ChildItem -Path $ModuleBasePath\*.psd1 | Select-Object -ExpandProperty BaseName
        Write-Output $ModuleName
        [version]$CurrentlyLoadedModuleVersion = (Get-Module -Name $ModuleName).Version

        $LatestModuleVersion = (Find-Module -Name $ModuleName).Version

        if ($CurrentlyLoadedModuleVersion -lt $LatestModuleVersion) {
            if ($ShowMessage) {
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