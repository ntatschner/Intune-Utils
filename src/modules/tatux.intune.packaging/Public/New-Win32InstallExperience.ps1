function New-Win32InstallExperience {
    [CmdletBinding()]
    [OutputType([Hashtable])]
    param (
        [Alias('InstallTimeInMinutes')]
        [string]$maxRunTimeInMinutes,

        [ValidateSet('basedOnReturnCode', 'never', 'always', 'prompt', 'suppress')]
        [string]$restartBehavior = 'basedOnReturnCode',

        [Alias('InstallFor')]
        [ValidateSet('system', 'sser')]
        [string]$runAsAccount = 'system'
    )

    $installExperienceHashTable = @{
        "maxRunTimeInMinutes" = $maxRunTimeInMinutes
        "restartBehavior" = $restartBehavior
        "runAsAccount" = $runAsAccount
    }
    if ([string]::IsNullOrEmpty($maxRunTimeInMinutes)) {
        $installExperienceHashTable.Remove("maxRunTimeInMinutes")
    }

    return $installExperienceHashTable
}