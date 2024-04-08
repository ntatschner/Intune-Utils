function New-Win32Installation {
    [OutputType([Hashtable])]
    param(
        [Alias('InstallationCommandline')]
        $installCommandLine,

        [Alias('UninstallCommandLine')]
        $uninstallCommandLine,

        [Alias('InstallExperience')]
        $installExperience,

        [Alias('MinimumFreeDiskSpaceInMB')]
        $minimumFreeDiskSpaceInMB,

        [Alias('MinimumMemoryInMB')]
        $minimumMemoryInMB,

        [Alias('MinimumNumberOfProcessors')]
        $minimumNumberOfProcessors,

        [Alias('MinimumCpuSpeedInMHz')]
        $minimumCpuSpeedInMHz,

        [Alias('ApplicableArchitectures')]
        $applicableArchitectures
    )
}