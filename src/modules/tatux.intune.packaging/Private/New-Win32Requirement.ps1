function New-Win32Requirement {
    [CmdletBinding()]
    [OutputType([Hashtable])]
    param (
        $minimumFreeDiskSpaceInMB,

        $minimumMemoryInMB,

        $minimumNumberOfProcessors,

        $minimumCpuSpeedInMHz,

        [ValidateSet('x86', 'x64', 'x86,x64')]
        $applicableArchitectures = 'x86,x64',

        [Parameter(Mandatory = $true)]
        [ValidateSet('Windows11_22H2', 'Windows11_21H2', 'Windows11_21H1', 'Windows11_20H2', 'Windows10_21H1', 'Windows10_20H2', 'Windows10_20H1', 'Windows10_1909', 'Windows10_1903', 'Windows10_1809', 'Windows10_1803', 'Windows10_1709', 'Windows10_1703', 'Windows10_1607')]
        $minimumSupportedWindowsRelease
    )

    $RequirementHashTable = @{}
    foreach ($param in $PSBoundParameters.Keys) {
        if ($PSBoundParameters[$param]) {
            $RequirementHashTable.Add($param, $PSBoundParameters[$param])
        }
    }
    if (-Not $RequirementHashTable.ContainsKey('applicableArchitectures')) {
        $RequirementHashTable.Add('applicableArchitectures', $applicableArchitectures)
    }

    return $RequirementHashTable
}