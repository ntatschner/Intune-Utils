#Downloads the Intune Content Prep Tools from the Microsoft Download Center and extracts the contents to the specified path.
function Get-IntunePackagingTool {
    <#
.SYNOPSIS
Downloads the Intune Content Prep Tools from the Microsoft Download Center and extracts the contents to the specified path.

.DESCRIPTION
The Get-IntunePackagingTool function downloads the Intune Content Prep Tools from the Microsoft Download Center and extracts the contents to the specified path.

.PARAMETER Path
The path to extract the Intune Content Prep Tools to.

.EXAMPLE
Get-IntunePackagingTool -Path "C:\path\to\extract\to"

#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Path,
        [Parameter(ParameterSetName = 'DownloadTag')]
        [string]$DownloadTag,
        [string]$DownloadUrl,
        [switch]$Force

    )
    begin {
        if ($PSBoundParameters.ContainsKey('Debug')) {
            $DebugPreference = 'Inquire'
        }
        else {
            $DebugPreference = 'SilentlyContinue'
        }
        # Set the download URL and path based on the specified tag
        if ($PSCmdlet.ParameterSetName -eq 'DownloadTag') {
            Write-Verbose "Using the specified download tag '$DownloadTag'..."
            $local:DownloadUrl = "https://github.com/microsoft/Microsoft-Win32-Content-Prep-Tool/archive/refs/tags/$DownloadTag.zip"
            $local:DownloadPath = Join-Path -Path $env:TEMP -ChildPath "$DownloadTag.zip"
            $local:DownloadPathParent = Split-Path -Path $DownloadPath -Parent
        }
        if ([string]::IsNullOrEmpty($DownloadUrl) -and [string]::IsNullOrEmpty($DownloadTag)) {
            # Set the download URL and path for the latest release
            Write-Verbose "Getting the latest release of the Intune Content Prep Tools..."
            $LatestTag = $(Invoke-WebRequest -Uri "https://github.com/microsoft/Microsoft-Win32-Content-Prep-Tool/releases/latest" -Headers @{"Accept" = "application/json" } | ConvertFrom-Json).tag_name
            Write-Debug "Latest tag: $LatestTag"
            $local:DownloadUrl = "https://github.com/microsoft/Microsoft-Win32-Content-Prep-Tool/archive/refs/tags/$LatestTag.zip"
            Write-Debug "Download URL: $DownloadUrl"
            $local:DownloadPath = Join-Path -Path $env:TEMP -ChildPath "$LatestTag.zip"
            Write-Debug "Download Path: $DownloadPath"
            $local:DownloadPathParent = Split-Path -Path $DownloadPath -Parent
        }
        else {
            # Split up provided download URL to get the file name
            $local:DownloadUrlSplit = $DownloadUrl.Split("/")[-1]
            $local:DownloadPath = Join-Path -Path $env:TEMP -ChildPath $DownloadUrlSplit
        }
    }
    process {
        try {
            # Download the Intune Content Prep Tools
            Write-Verbose "Downloading the Intune Content Prep Tools from Github;`n$DownloadUrl`nto $DownloadPath..."
            Invoke-WebRequest -Uri $DownloadUrl -OutFile $DownloadPath -ErrorAction Stop
            $local:ExtractionPath = $DownloadPath -replace (Get-item -Path $DownloadPath).Extension , ""
        }
        catch {
            Write-Error "Failed to download the Intune Content Prep Tools from $($DownloadUrl): $_"
            exit
        }
        
        try {
            # Extract the Intune Content Prep Tools
            Write-Verbose "Extracting the Intune Content Prep Tools to '$Path'..."
            Expand-Archive -Path $DownloadPath -DestinationPath $ExtractionPath -Force -ErrorAction Stop
        }
        catch {
            Write-Error "Failed to extract the Intune Content Prep Tools: $_"
            exit
        }

        try {
            # Copy the .exe file to the specified path
            $FileToCopy = Get-childitem -Path $ExtractionPath -Recurse -Include "*.exe"
            Copy-Item -Path $FileToCopy -Destination $Path -ErrorAction Stop
            Write-Verbose "The Intune Content Prep Tools have been extracted to '$Path'."
        }
        catch {
            Write-Error "Failed to copy the Intune Content Prep Tools: $_"
            exit
        }

        try {
            # Remove the downloaded zip file and extracted folder
            Write-Verbose "Removing the downloaded zip file."
            Remove-Item -Path $DownloadPath -Force -Confirm:$false
            Write-Verbose "Removing the extracted folder."
            Remove-Item -Path $ExtractionPath -Recurse -Force -Confirm:$false
        }
        catch {
            Write-Error "Failed to remove the downloaded zip file or the extracted folder: $_"
        }

    }
}