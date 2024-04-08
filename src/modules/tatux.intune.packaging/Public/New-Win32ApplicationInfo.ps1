function New-Win32ApplicationInfo {
    param(
        [CmdletBinding()]
        [OutputType([Hashtable])]

        [Parameter(Mandatory = $true)]
        [string]$displayName,
        
        [Parameter(Mandatory = $true)]
        [string]$description,
        
        [Parameter(Mandatory = $true)]
        [string]$publisher,

        [string]$notes,

        [string]$owner,

        [string]$developer,

        [string]$version,
        
        [bool]$isFeatured = $false,

        [string]$privacyInformationUrl,

        [string]$informationUrl
    )

    $ApplicationInfoHashtable = @{}

    foreach ($param in $PSBoundParameters.Keys) {
        if ($PSBoundParameters[$param]) {
            $ApplicationInfoHashtable.Add($param, $PSBoundParameters[$param])
        }
    }
    if (-Not $ApplicationInfoHashtable.ContainsKey('isFeatured')) {
        $ApplicationInfoHashtable.Add('isFeatured', $isFeatured)
    }

    return $ApplicationInfoHashtable
}