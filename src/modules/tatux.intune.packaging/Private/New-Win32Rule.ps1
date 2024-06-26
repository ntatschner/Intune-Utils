function New-Win32Rule {
    [CmdletBinding()]
    [OutputType([Hashtable])]
    param (
        [Parameter(HelpMessage = 'The type of rule to create.')]
        [ValidateSet('requirement', 'detection')]
        [string]$RuleParentType,

        [ValidateSet('file', 'registry', 'script', 'msi')]
        [string]$RuleType,

        [Parameter(ParameterSetName = 'file', Mandatory, HelpMessage = 'The path to the file or folder.')]
        [Parameter(ParameterSetName = 'registry', Mandatory, HelpMessage = 'The registry key path.')]
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
        [ValidateScript({
                if (Test-Path -Path $_ -IsValid) {
                    $true
                }
                else {
                    throw "MSI path dosn't seem to be valid."
                }
            })]
        [string]$MSIPath,

        [Parameter(ParameterSetName = 'msi', HelpMessage = 'The product code to detect.')]
        [string]$ProductCode,

        [Parameter(ParameterSetName = 'msi', HelpMessage = 'The MSI operation type. If exists is selected then the operator and comparison value are not required.')]
        [ValidateSet('notConfigured', 'equal', 'notEqual', 'greaterThan', 'greaterThanOrEqual', 'lessThan', 'lessThanOrEqual')]
        [string]$ProductVersionOperator = 'notConfigured',

        [Parameter(ParameterSetName = 'msi', HelpMessage = 'The value to compare against.')]
        [string]$ProductVersion,

        [Parameter(ParameterSetName = 'msi', HelpMessage = 'Detect the MSI properties automatically.')]
        [bool]$AutoDetect = $true,

        [Parameter(ParameterSetName = 'file', Mandatory, HelpMessage = 'The file or folder name.')]
        [string]$FileOrFolderName,

        [Parameter(ParameterSetName = 'file', HelpMessage = 'Expand 32bit variables on a 64bit system?')]
        [Parameter(ParameterSetName = 'registry', HelpMessage = 'Expand 32bit variables on a 64bit system?')]
        [bool]$Check32BitOn64System = $true,

        [Parameter(ParameterSetName = 'file', HelpMessage = 'The path or file operation type. If exists is selected then the operator and comparison value are not required.')]
        [ValidateSet('notConfigured', 'exists', 'modifiedDate', 'createdDate', 'version', 'sizeInMB')]
        [string]$FileOperationType = 'exists',

        [Parameter(HelpMessage = 'The operator for comparison. Do not set for detection rules.')]
        [Parameter(ParameterSetName = 'file', HelpMessage = 'The operator for comparison.')]
        [Parameter(ParameterSetName = 'registry', HelpMessage = 'The operator for comparison.')]
        [Parameter(ParameterSetName = 'script', HelpMessage = 'The operator for comparison. ')]
        [ValidateSet('notConfigured', 'equal', 'notEqual', 'greaterThan', 'greaterThanOrEqual', 'lessThan', 'lessThanOrEqual')]
        [string]$Operator = 'notConfigured',

        [Parameter(ParameterSetName = 'file', HelpMessage = 'The value to compare against.')]
        [Parameter(ParameterSetName = 'registry', HelpMessage = 'The value to compare against.')]
        [string]$ComparisonValue,

        [Parameter(ParameterSetName = 'registry', Mandatory, HelpMessage = 'The registry value name to detect.')]
        [string]$ValueName,

        [Parameter(ParameterSetName = 'registry', Mandatory, HelpMessage = 'The registry operation type. If exists is selected then the operator and comparison value are not required.')]
        [ValidateSet('notConfigured', 'exists', 'doesNotExist', 'string', 'integer', 'version')]
        [string]$RegistryOperationType = 'exists',
        
        [Parameter(ParameterSetName = 'script', Mandatory, HelpMessage = 'The script display name. Default will be file name.')]
        [string]$DisplayName,

        [Parameter(ParameterSetName = 'script', HelpMessage = 'The enforces a script signature check.')]
        [bool]$EnforceSignatureCheck = $false,

        [Parameter(ParameterSetName = 'script', HelpMessage = 'Run script as 32bit on 64bit systems.')]
        [ValidateSet('$true', 'false')]
        [bool]$RunAs32Bit = $false,

        [Parameter(ParameterSetName = 'script', HelpMessage = 'The account type to run the requirements script as.')]
        [ValidateSet('system', 'user')]
        [string]$runAsAccount = 'system',

        [Parameter(ParameterSetName = 'script', Mandatory, HelpMessage = 'The script path.')]
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
            "msi"      = "#microsoft.graph.win32LobAppProductCodeRule"
        }
        $RuleHashtable = @{}
        $RuleHashtable.Add("@odata.type", $RuleODataTypeHashtable[$RuleType])
        foreach ($P in $PSBoundParameters.Keys) {
            $RuleHashtable.Add($P, $PSBoundParameters[$P])
        }
        # Add parameters that have have default assigned and have not been overridden for each RuleType
        switch ($RuleType) {
            'file' {
                if (-not $RuleHashtable.ContainsKey('path')) { $RuleHashtable.Add('path', $Path) }
                if (-not $RuleHashtable.ContainsKey('fileOrFolderName')) { $RuleHashtable.Add('fileOrFolderName', $FileOrFolderName) }
                if (-not $RuleHashtable.ContainsKey('fileOperationType')) { $RuleHashtable.Add('fileOperationType', $FileOperationType) }
                if (-not $RuleHashtable.ContainsKey('check32BitOn64System')) { $RuleHashtable.Add('check32BitOn64System', $Check32BitOn64System) }
            }
            'registry' {
                if (-not $RuleHashtable.ContainsKey('path')) { $RuleHashtable.Add('path', $Path) }
                if (-not $RuleHashtable.ContainsKey('valueName')) { $RuleHashtable.Add('valueName', $ValueName) }
                if (-not $RuleHashtable.ContainsKey('registryOperationType')) { $RuleHashtable.Add('registryOperationType', $RegistryOperationType) }
            }
            'script' {
                if (-not $RuleHashtable.ContainsKey('displayName')) { $RuleHashtable.Add('displayName', $DisplayName) }
                if (-not $RuleHashtable.ContainsKey('enforceSignatureCheck')) { $RuleHashtable.Add('enforceSignatureCheck', $EnforceSignatureCheck) }
                if (-not $RuleHashtable.ContainsKey('runAs32Bit')) { $RuleHashtable.Add('runAs32Bit', $RunAs32Bit) }
                if (-not $RuleHashtable.ContainsKey('runAsAccount')) { $RuleHashtable.Add('runAsAccount', $runAsAccount) }
                if (-not $RuleHashtable.ContainsKey('scriptContent')) { $RuleHashtable.Add('scriptContent', (Get-Content -Path $ScriptPath)) }
            }
            'msi' {
                if (-not $RuleHashtable.ContainsKey('msiPath')) { $RuleHashtable.Add('msiPath', $MSIPath) }
                if (-not $RuleHashtable.ContainsKey('productCode')) { $RuleHashtable.Add('productCode', $ProductCode) }
                if (-not $RuleHashtable.ContainsKey('productVersionOperator')) { $RuleHashtable.Add('productVersionOperator', $ProductVersionOperator) }
                if (-not $RuleHashtable.ContainsKey('productVersion')) { $RuleHashtable.Add('productVersion', $ProductVersion) }
            }
        }
        # Remove Fields not needed for output
        $RuleHashtable.RuleType = $RuleParentType
        $RuleHashtable.Remove('RuleParentType')
        $RuleHashtable.Remove('MSIPath')
        if (($RuleType -eq 'file' -or $RuleType -eq 'registry') -and ($FileOperationType -eq 'exists' -or $RegistryOperationType -eq 'exists')) {
            $RuleHashtable.Remove('Operator')
            $RuleHashtable.Remove('ComparisonValue')
        }
        if (($RuleType -eq 'msi' -and $AutoDetect -eq $true)) {
            $MSIInfo = Get-MSIProperties -Path $MSIPath
            $RuleHashtable.ProductCode = $MSIInfo.ProductCode
            $RuleHashtable.ProductVersion = $MSIInfo.ProductVersion
            $RuleHashtable.ProductVersionOperator = 'equal'
        }
        return $RuleHashtable 
    }
}