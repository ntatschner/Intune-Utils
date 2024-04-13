﻿#
# Module manifest for module 'rsy.intune.packaging'
#
# Generated by: Nigel Tatschner
#
# Generated on: 04/03/2024
#

@{

    # Script module or binary module file associated with this manifest.
    # RootModule = ''

    # Version number of this module.
    ModuleVersion        = '0.6'

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

    # Name of the Windows PowerShell host required by this module
    #PowerShellHostName = ''

    # Minimum version of the Windows PowerShell host required by this module
    # PowerShellHostVersion = ''

    # Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    # DotNetFrameworkVersion = ''

    # Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    # CLRVersion = ''

    # Processor architecture (None, X86, Amd64) required by this module
    # ProcessorArchitecture = ''

    # Modules that must be imported into the global environment prior to importing this module
    RequiredModules      = @("Microsoft.Graph.Intune", "Microsoft.Graph.Authentication")

    # Assemblies that must be loaded prior to importing this module
    # RequiredAssemblies = @()

    # Script files (.ps1) that are run in the caller's environment prior to importing this module.
    # ScriptsToProcess = @()

    # Type files (.ps1xml) to be loaded when importing this module
    # TypesToProcess = @()

    # Format files (.ps1xml) to be loaded when importing this module
    # FormatsToProcess = @()

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
            ReleaseNotes = 'Initial release of the module.'

        } # End of PSData hashtable

    } # End of PrivateData hashtable

    # HelpInfo URI of this module
    HelpInfoURI = "https://pwsh.dev.tatux.co.uk/pages/tatux.intune.packaging/files/"

    # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
    # DefaultCommandPrefix = ''

}

