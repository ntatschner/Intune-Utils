function Get-ModuleStatus {
    param (
        [switch]$ShowMessage
    )
    try {
        # Get the current version of the installed module and check against the latest version in PSGallery, then notify the user as a warning message that an update is availible.
        $ModuleDiscovery = $(Get-Command -Name Get-ModuleStatus -ShowCommandInfo).Module.Name
        [version]$CurrentlyLoadedModuleVersion = (Get-Module -Name $ModuleDiscovery).Version

        [version]$LatestModuleVersion = (Find-Module -Name $ModuleDiscovery).Version

        if ($CurrentlyLoadedModuleVersion -lt $LatestModuleVersion) {
            if ($ShowMessage) {
                Write-Warning "An update is available for the module '$ModuleDiscovery'. Installed version: $CurrentlyLoadedModuleVersion, Latest version: $LatestModuleVersion"
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