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
$CurrentConfig = Get-ModuleConfig -CommandPath $PSCommandPath

# Generate execution ID
$ExecutionID = [System.Guid]::NewGuid().ToString()

$TelmetryArgs = @{
    ModuleName = $CurrentConfig.ModuleName
    ModulePath = $CurrentConfig.ModulePath
    ModuleVersion = $MyInvocation.MyCommand.Module.Version
    ExecutionID = $ExecutionID
    CommandName = $MyInvocation.MyCommand.Name
    URI = 'https://telemetry.tatux.in/api/telemetry'
    ClearTimer = $true
    Stage = 'Module-Load'
}

if ($CurrentConfig.BasicTelemetry -eq 'True') {
    Invoke-TelemetryCollection -Minimal @TelmetryArgs
} else {
    Invoke-TelemetryCollection @TelmetryArgs
}

if ($CurrentConfig.UpdateWarning -eq 'True') {
    Get-ModuleStatus -ShowMessage -ModuleName $CurrentConfig.ModuleName -ModulePath $CurrentConfig.ModulePath
}