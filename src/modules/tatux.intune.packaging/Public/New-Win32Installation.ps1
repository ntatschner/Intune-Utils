function New-Win32Installation {
    [OutputType([Hashtable])]
    param(
        [Parameter(Mandatory = $true)]
        [string]$installCommandLine,
        
        [Parameter(Mandatory = $true)]
        [string]$uninstallCommandLine,

        [bool]$allowAvailableUninstall = $false
    )


}