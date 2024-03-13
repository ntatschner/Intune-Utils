# This function takes in a Hashtable of parameters and creates a JSON object for an Intune Application
function New-IntuneAppJSON {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [hashtable]$AppParams
    )
    
    begin {
        # First Split out the required parameters for the .intunewin file
        $IntuneWinParams = @{
            "MainInstallerFileName" = $AppParams.MainInstallerFileName
            "SourceFiles"           = $AppParams.SourceFiles
            "OutputFolder"          = $AppParams.OutputFolder
        }
        # Remove the parameters from the hashtable
        $AppParams.Remove("MainInstallerFileName")
        $AppParams.Remove("SourceFiles")
        $AppParams.Remove("OutputFolder")
    }
    
    process {
        # Create PS Object to build multidimensional array
        $ObjectParams = @{
            "ApplicationParameters" = $AppParams
            "IntuneWinParameters"   = $IntuneWinParams
        }
        $Object = New-Object -TypeName PSObject -Property $ObjectParams
        $Object | ConvertTo-Json
    }
}