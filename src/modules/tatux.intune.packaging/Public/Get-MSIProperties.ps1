function Get-MSIProperties {
        [CmdletBinding(HelpUri = 'https://pwsh.dev.tatux.co.uk/tatux.intune.packaging/docs/Get-MSIProperties/')]
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
        # Create an empty hashtable to store properties in

        # Creating WI object and load MSI database
        $WindowsInstaller = New-Object -ComObject WindowsInstaller.Installer
        $WindowsInstallerDatabase = $WindowsInstaller.GetType().InvokeMember("OpenDatabase", "InvokeMethod", $null, $WindowsInstaller, @(($Path), 0))

        # Open the Property-view
        $WindowsInstallerDatabaseView = $WindowsInstallerDatabase.GetType().InvokeMember("OpenView", "InvokeMethod", $null, $WindowsInstallerDatabase, "SELECT * FROM Property")
        $WindowsInstallerDatabaseView.GetType().InvokeMember("Execute", "InvokeMethod", $null, $WindowsInstallerDatabaseView, $null)

        $Results = @{}

        # Loop thru the table
        $WindowsInstallerDatabaseRow = $WindowsInstallerDatabaseView.GetType().InvokeMember("Fetch", "InvokeMethod", $null, $WindowsInstallerDatabaseView, $null)
        while ($null -ne $WindowsInstallerDatabaseRow) {
            # Add property and value to hash table
            $name = $WindowsInstallerDatabaseView.GetType().InvokeMember("StringData", "GetProperty", $null, $WindowsInstallerDatabaseRow, 1)
            $value = $WindowsInstallerDatabaseView.GetType().InvokeMember("StringData", "GetProperty", $null, $WindowsInstallerDatabaseRow, 2)
            $Results."$name" = $value

            # Fetch the next row
            $WindowsInstallerDatabaseRow = $WindowsInstallerDatabaseView.GetType().InvokeMember("Fetch", "InvokeMethod", $null, $WindowsInstallerDatabaseView, $null)
        }

        $WindowsInstallerDatabaseView.GetType().InvokeMember("Close", "InvokeMethod", $null, $WindowsInstallerDatabaseView, $null)

        # Return the hash table
        [PSCustomObject]$Results
    }
}