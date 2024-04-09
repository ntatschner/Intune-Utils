#requires -Version 7.0 -Modules 'Microsoft.Graph.Intune', 'Microsoft.Graph.Authentication'
# Takes the .intunewin and configuration .json and publishes the application to Intune
function Publish-IntuneAppPackage {
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateScript({Test-Path -Path $_ -PathType Leaf})]
        [string]$IntuneAppJSONPath,
        [Parameter(Mandatory = $true)]
        [ValidateScript({Test-Path -Path $_ -PathType Leaf})]
        [string]$IntuneWinPath,
        [switch]$Force,
        [switch]$NoTenantDetails
    )
    
    begin {
        # Get the JSON object from the file
        $IntuneAppJSON = Get-Content -Path $IntuneAppJSONPath | ConvertFrom-Json
        # Check if the user is already connected to Intune
        $GraphContext = Get-MgContext
        if (-not $GraphContext) {
            Write-Error "You are not connected to Intune. Please connect to Intune using the Connect-MgGraph function"
            return
        }
        $TenantDetails = Get-MgOrganization
        if ($NoTenantDetails -eq $false) {
            Write-Warning "You're connected to MgGraph as:" +
            "`n`tUserName: $($GraphContext.Account)`n`t" +
            "In the Context Scope: $($GraphContext.ContextScope)`n`t" +
            "TenantId: $($TenantDetails.Id)`n`tTenantName: $($TenantDetails.DisplayName)"
            return
        }
    }
    process {
        # Check if the application already exists in Intune
        $IntuneApp = Get-MgGraphApplication -Filter "displayName eq '$($IntuneAppJSON.ApplicationParameters.DisplayName)'"
        if ($IntuneApp) {
            if ($Force) {
                Write-Warning "Application already exists in Intune. Forcing update of application"

            }
            else {
                Write-Error "Application already exists in Intune. Use the -Force switch to update the application"
                return
            }
        }
        else {
            
        }
        
    }
}