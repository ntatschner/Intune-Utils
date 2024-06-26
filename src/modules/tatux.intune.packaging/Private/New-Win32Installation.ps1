function New-Win32Installation {
    [OutputType([Hashtable])]
    param(
        [Parameter(Mandatory = $true)]
        [string]$installCommandLine,
        
        [Parameter(Mandatory = $true)]
        [string]$uninstallCommandLine,

        [bool]$allowAvailableUninstall = $false
    )

    $InstallationHashTable = @{
        installCommandLine = $installCommandLine
        uninstallCommandLine = $uninstallCommandLine
        allowAvailableUninstall = $allowAvailableUninstall
    }

    return $InstallationHashTable
}