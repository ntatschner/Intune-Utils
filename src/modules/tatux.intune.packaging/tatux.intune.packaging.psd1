@{

    # Script module or binary module file associated with this manifest.
    # RootModule = ''

    # Version number of this module.
    ModuleVersion        = '0.9.0.55'

    # Supported PSEditions
    CompatiblePSEditions = @('Desktop')

    # ID used to uniquely identify this module
    GUID                 = 'bfe12388-5f86-4da1-b08b-a439ff6f690c'

    # Author of this module
    Author               = 'Nigel Tatschner'

    # Company or vendor of this module
    CompanyName          = 'Tatux Solutions'

    # Copyright statement for this module
    Copyright            = '(c) 2024 Nigel Tatschner. All rights reserved.'

    # Description of the functionality provided by this module
    Description          = 'A set of functions designed to package and deploy Application packages to Microsoft Intune.'

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion    = '5.1'

    # Modules that must be imported into the global environment prior to importing this module
    RequiredModules = @(
        @{ ModuleName = 'Microsoft.Graph.Intune'; ModuleVersion = '6.1907.1.0' },
        @{ ModuleName = 'Microsoft.Graph.Authentication'; ModuleVersion = '2.17.0' },
        'tatux.telemetry'
    )

    # Assemblies that must be loaded prior to importing this module
    # RequiredAssemblies = @()


    # Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
    NestedModules        = @('tatux.intune.packaging.psm1')

    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    FunctionsToExport    = '*'

    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
    CmdletsToExport      = '*'

    # Variables to export from this module
    VariablesToExport    = '*'

    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
    AliasesToExport      = '*'

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData          = @{

        PSData = @{
            # Tags applied to this module. These help with module discovery in online galleries.
            Tags = @('Intune', 'Packaging', 'Deployment', 'Applications')

            ExternalModuleDependencies = @(
                'Microsoft.Graph.Intune'
            )

            # ReleaseNotes of this module
            ReleaseNotes = 'Added update module config framework and notification of updates on module load.'

        } # End of PSData hashtable

    } # End of PrivateData hashtable

    # HelpInfo URI of this module
    HelpInfoURI = 'https://update.tatux.co.uk/tatux.intune.packaging/'

    # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
    # DefaultCommandPrefix = ''
}