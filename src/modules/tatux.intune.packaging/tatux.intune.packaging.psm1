#region get public and private function definition files.
$Public  = @(
    Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -Exclude "*.Tests.ps1" -ErrorAction SilentlyContinue
)
$Private = @(
    Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -Exclude "*.Tests.ps1" -ErrorAction SilentlyContinue
)
#endregion

#region source the files
foreach ($Function in @($Public + $Private)) {
    $FunctionPath = $Function.fullname
    try {
	. $FunctionPath # dot source function
    } catch {
	Write-Error -Message "Failed to import function at $($FunctionPath): $_"
    }
}
#endregion

#region read in or create an initial config file and variable
#. "$PSScriptRoot\Config.ps1" # uncomment to source config parsing logic
#endregion

#region set variables visible to the module and its functions only
$Date = Get-Date -UFormat "%Y.%m.%d"
$Time = Get-Date -UFormat "%H:%M:%S"
. "$PSScriptRoot\Colors.ps1"
#endregion

#region export Public functions ($Public.BaseName) for WIP modules
Export-ModuleMember -Function $Public.Basename
#endregion

# Module Config setup and import
$CurrentConfig = Get-ModuleConfig
if ($CurrentConfig.UpdateWarning -eq 'True') {
    Get-ModuleStatus -ShowMessage -ModuleName $CurrentConfig.ModuleName -ModulePath $CurrentConfig.ModulePath
}