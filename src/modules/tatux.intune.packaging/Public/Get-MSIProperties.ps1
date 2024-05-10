function Get-MSIProperties {
    [CmdletBinding(HelpUri = 'https://pwsh.dev.tatux.co.uk/tatux.intune.packaging/docs/Get-MSIProperties.html')]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, HelpMessage = "MSI Database Filename", ValueFromPipeline)]
        [ValidateScript({
                if (!(Test-Path $_)) {
                    throw "Could not find " + $_
                }
                else {
                    $true
                }
            })]
        [Alias("Filename", "MSIDbName", "Database", "Msi")]
        $Path
    )
    process {
        try {
            $CurrentConfig = Get-ModuleConfig
            $TelmetryArgs = @{
                ModuleName    = $CurrentConfig.ModuleName
                ModulePath    = $CurrentConfig.ModulePath
                ModuleVersion = $MyInvocation.MyCommand.Module.Version
                CommandName   = $MyInvocation.MyCommand.Name
                URI           = 'https://telemetry.tatux.in/api/telemetry'
            }
            if ($CurrentConfig.BasicTelemetry -eq 'True') {
                $TelmetryArgs.Add('Minimal', $true)
            }
            #Invoke-TelemetryCollection @TelmetryArgs -Stage start -ClearTimer
        }
        catch {
            Write-Verbose "Failed to load telemetry"
        }
        # Create an empty hashtable to store properties in
        $Path = Get-Item $Path | Select-Object -ExpandProperty FullName
        # Creating WI object and load MSI database
        try {
            $WindowsInstaller = New-Object -ComObject WindowsInstaller.Installer
            $WindowsInstallerDatabase = $WindowsInstaller.OpenDatabase($Path, 0)

            # Open the Property-view
            $WindowsInstallerDatabaseView = $WindowsInstallerDatabase.OpenView("SELECT * FROM Property")
            $WindowsInstallerDatabaseView.Execute($null)

            $Results = @{}

            # Loop thru the table
            $WindowsInstallerDatabaseRow = $WindowsInstallerDatabaseView.Fetch($null)
            while ($null -ne $WindowsInstallerDatabaseRow) {
                # Add property and value to hash table
                $name = $WindowsInstallerDatabaseView.GetType().InvokeMember("StringData", "GetProperty", $null, $WindowsInstallerDatabaseRow, 1)
                $value = $WindowsInstallerDatabaseView.GetType().InvokeMember("StringData", "GetProperty", $null, $WindowsInstallerDatabaseRow, 2)
                $Results."$name" = $value

                # Fetch the next row
                $WindowsInstallerDatabaseRow = $WindowsInstallerDatabaseView.Fetch($null)
            }

            $WindowsInstallerDatabaseView.Close($null)

            # Return the hash table
            [PSCustomObject]$Results
        }
        catch {
            #Invoke-TelemetryCollection @TelmetryArgs -Stage End -ClearTimer -Failed $true -Exception $_
            Write-Error "Failed to load MSI database"
            $_
            break
        }
        #Invoke-TelemetryCollection @TelmetryArgs -Stage End -ClearTimer
    }
}