function Get-ParameterValues {
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory)]
        [hashtable]$PSBoundParametersHash,
        [string[]]$Exclude
    )
    # Get all the PSBoundParameters and set the values as a hashtable
    $DefaultExclude = @('Verbose', 'Debug', 'ErrorAction', 'WarningAction', 'InformationAction', 'ErrorVariable', 'WarningVariable', 'InformationVariable', 'OutVariable', 'OutBuffer', 'PipelineVariable')
    if ($null -eq $Exclude) {
        $Exclude = $DefaultExclude
    } else {
        $Exclude += $DefaultExclude
    }
    $Parameters = New-Object System.Collections.Hashtable
    $PSBoundParametersHash.GetEnumerator() | ForEach-Object {
        # Only add the key and value to the hashtable if the value is not null and not the default parameters
        if ($null -ne $_.Value -and $Exclude -notcontains $_.Key) {
            $Key = $_.Key
            $Value = $_.Value
            $Parameters.Add($Key, $Value)
        }
    }
    $Parameters
}