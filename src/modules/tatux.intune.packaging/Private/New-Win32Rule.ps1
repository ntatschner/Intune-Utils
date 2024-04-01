# A function to create a new Win32Rule object for requirement or detection rules
function New-Win32Rule {
    [CmdletBinding()]
    param (
        [Parameter(HelpMessage = 'The type of rule to create.')]
        [ValidateSet('requirement', 'detection')]
        [string]$RuleParentType,

        [ValidateSet('file', 'registry', 'script', 'msi')]
        [string]$RuleType,

        [Parameter(ParameterSetName = 'file', Mandatory, HelpMessage = 'The path to the file or folder.')]
        [Parameter(ParameterSetName = 'registry', Mandatory, HelpMessage = 'The registry key path.')]
        [Parameter(ParameterSetName = 'requirement')]
        [Parameter(ParameterSetName = 'detection')]
        [ValidateScript({
                if (Test-Path -Path $_ -IsValid) {
                    $true
                }
                else {
                    throw "Path dosn't seem to be valid."
                }
            })]
        [string]$Path,
        
        [Parameter(ParameterSetName = 'msi', Mandatory, HelpMessage = 'The path to the MSI file.')]
        [Parameter(ParameterSetName = 'detection')]
        [ValidateScript({
                if (Test-Path -Path $_ -IsValid) {
                    $true
                }
                else {
                    throw "MSI path dosn't seem to be valid."
                }
            })]
        [string]$MSIPath,

        [Parameter(ParameterSetName = 'file', Mandatory, HelpMessage = 'The file or folder name.')]
        [Parameter(ParameterSetName = 'detection')]
        [Parameter(ParameterSetName = 'requirement')]
        [string]$FileOrFolderName,

        [Parameter(ParameterSetName = 'file', HelpMessage = 'Expand 32bit variables on a 64bit system?')]
        [Parameter(ParameterSetName = 'registry', Mandatory, HelpMessage = 'Expand 32bit variables on a 64bit system?')]
        [Parameter(ParameterSetName = 'requirement')]
        [Parameter(ParameterSetName = 'detection')]
        [bool]$Check32BitOn64System = $true,

        [Parameter(ParameterSetName = 'file', HelpMessage = 'The path or file operation type. If exists is selected then the operator and comparison value are not required.')]
        [Parameter(ParameterSetName = 'requirement')]
        [Parameter(ParameterSetName = 'detection')]
        [ValidateSet('notConfigured', 'exists', 'modifiedDate', 'createdDate', 'version', 'sizeInMB')]
        [string]$FileOperationType = 'exists',

        [Parameter(HelpMessage = 'The operator for comparison. Do not set for detection rules.')]
        [Parameter(ParameterSetName = 'file', HelpMessage = 'The operator for comparison.')]
        [Parameter(ParameterSetName = 'registry', HelpMessage = 'The operator for comparison.')]
        [Parameter(ParameterSetName = 'script', HelpMessage = 'The operator for comparison. ')]
        [Parameter(ParameterSetName = 'requirement')]
        [Parameter(ParameterSetName = 'detection')]
        [ValidateSet('notConfigured', 'equal', 'notEqual', 'greaterThan', 'greaterThanOrEqual', 'lessThan', 'lessThanOrEqual')]
        [string]$Operator = 'notConfigured',

        [Parameter(ParameterSetName = 'file', HelpMessage = 'The value to compare against.')]
        [Parameter(ParameterSetName = 'registry', HelpMessage = 'The value to compare against.')]
        [Parameter(ParameterSetName = 'requirement')]
        [Parameter(ParameterSetName = 'detection')]
        [string]$ComparisonValue,

        [Parameter(ParameterSetName = 'registry', Mandatory, HelpMessage = 'The registry value name to detect.')]
        [string]$ValueName,

        [Parameter(ParameterSetName = 'registry', Mandatory, HelpMessage = 'The registry operation type. If exists is selected then the operator and comparison value are not required.')]
        [Parameter(ParameterSetName = 'requirement')]
        [Parameter(ParameterSetName = 'detection')]
        [ValidateSet('notConfigured', 'exists', 'doesNotExist', 'string', 'integer', 'version')]
        [string]$RegistryOperationType = 'exists',
        
        [Parameter(ParameterSetName = 'script', Mandatory, HelpMessage = 'The script display name. Default will be file name.')]
        [string]$DisplayName,

        [Parameter(ParameterSetName = 'script', HelpMessage = 'The enforces a script signature check.')]
        [Parameter(ParameterSetName = 'requirement')]
        [Parameter(ParameterSetName = 'detection')]
        [bool]$EnforceSignatureCheck = $false,

        [Parameter(ParameterSetName = 'script', HelpMessage = 'Run script as 32bit on 64bit systems.')]
        [Parameter(ParameterSetName = 'requirement')]
        [Parameter(ParameterSetName = 'detection')]
        [bool]$RunAs32Bit = $false,

        [Parameter(ParameterSetName = 'script', HelpMessage = 'The account type to run the requirements script as.')]
        [Parameter(ParameterSetName = 'requirement')]
        [Parameter(ParameterSetName = 'detection')]
        [ValidateSet('system', 'user')]
        [string]$runAsAccount = 'system',

        [Parameter(ParameterSetName = 'script', Mandatory, HelpMessage = 'The script path.')]
        [Parameter(ParameterSetName = 'requirement')]
        [Parameter(ParameterSetName = 'detection')]
        [ValidateScript({
                if (Test-Path -Path $_) {
                    if ($(Get-Item -Path $_).Extension -ne '.ps1' ) {
                        throw "Script file must be a PowerShell script."
                    }
                    else {
                        $true
                    }
                }
                else {
                    throw "Path isnt valid."
                }
            })]
        [string]$ScriptPath
    )
    process {
        $RuleODataTypeHashtable = @{
            "file"     = "#microsoft.graph.win32LobAppFileSystemRule"
            "registry" = "#microsoft.graph.win32LobAppRegistryRule"
            "script"   = "#microsoft.graph.win32LobAppPowerShellScriptRule"
        }
        $RuleHashtable = @{}
        $RuleHashtable.Add("@odata.type", $RuleODataTypeHashtable[$RuleType])
        foreach ($P in $PSBoundParameters.Keys) {
            $RuleHashtable.Add($P, $PSBoundParameters[$P])
        }
        if (($RuleType -eq 'file' -or $RuleType -eq 'registry') -and ($FileOperationType -eq 'exists' -or $RegistryOperationType -eq 'exists')) {
            $RuleHashtable.Remove('Operator')
            $RuleHashtable.Remove('ComparisonValue')
        }

    }
}