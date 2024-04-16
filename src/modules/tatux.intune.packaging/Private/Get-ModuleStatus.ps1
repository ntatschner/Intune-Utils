function Get-ModuleStatus {
    param (
        [switch]$ShowMessage
    )
    try {
        # Get the current version of the installed module and check against the latest version in PSGallery, then notify the user as a warning message that an update is availible.
        $ModuleDiscovery = Split-Path -Path $(Split-Path -Path $PSScriptRoot -Parent) -Leaf
        [version]$CurrentlyLoadedModuleVersion = (Get-Module -Name $ModuleDiscovery).Version

        $LatestModuleVersion = (Find-Module -Name $ModuleDiscovery).Version

        if ($CurrentlyLoadedModuleVersion -lt $LatestModuleVersion) {
            if ($ShowMessage) {
                Write-Host -ForegroundColor Yellow "An update is available for the module '$ModuleDiscovery'. Installed version: $CurrentlyLoadedModuleVersion, Latest version: $LatestModuleVersion.`nPlease run 'Update-Module $ModuleDiscovery' to update the module."
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