# A function to create a new Win32Rule object for requirement or detection rules
function New-Win32Rule {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateSet('requirement', 'detection')]
        [string]$RuleParentType,

        [Parameter(Mandatory = $true)]
        [ValidateSet('file', 'registry', 'script')]
        [Parameter(ParameterSetName = 'file')]
        [Parameter(ParameterSetName = 'registry')]
        [Parameter(ParameterSetName = 'script')]
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

        [Parameter(Mandatory = $true)]
        [string]$RulePayload
    )
    process {
        $hashTable = @{
            "@odata.type" = "#microsoft.graph.win32LobAppFileSystemRule"
            "ruleType" = $RuleParentType
            "path" = "String"
            "fileOrFolderName" = "String"
            "check32BitOn64System" = $true
            "operationType" = "String"
            "operator" = "String"
            "comparisonValue" = "String"
        }
    }
}
```