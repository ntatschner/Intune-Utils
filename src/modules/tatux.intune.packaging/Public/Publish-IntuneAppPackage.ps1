#requires -Version 7.0 -Modules 'Microsoft.Graph.Intune', 'Microsoft.Graph.Authentication'
# Takes the .intunewin and configuration .json and publishes the application to Intune
function Publish-IntuneAppPackage {
    <#
    .SYNOPSIS
    This function takes the .intunewin and configuration .json and publishes the application to Intune

    .DESCRIPTION
    This function takes the .intunewin and configuration .json and publishes the application to Intune. If the application already exists in Intune, the function will update the application if the -Force switch is used.

    .PARAMETER IntuneAppJSONPath
    The path to the JSON file that contains the Intune Application configuration

    .PARAMETER IntuneWinPath
    The path to the .intunewin file.

    .PARAMETER Force
    If the application already exists in Intune, this switch will force the application to be updated.

    .EXAMPLE
    Publish-IntuneAppPackage -IntuneAppJSONPath "C:\Temp\IntuneApp.json" -IntuneWinPath "C:\Temp\IntuneApp.intunewin"

    This example will publish the application to Intune using the configuration in the JSON file and the .intunewin file.

    .OUTPUTS
    The function will output the Intune Application details that was created.
    #>
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