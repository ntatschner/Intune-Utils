function New-Win32ReturnCode {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$ReturnCode,
        [Parameter(Mandatory = $true)]
        [ValidateSet('success', 'failed', 'softReboot', 'hardReboot', 'retry')]
        [string]$ReturnMessage
    )
    process {
        $hashTable = @{
            "returnCode" = $ReturnCode
            "type" = $ReturnMessage
        }
        return $hashTable
    }
}