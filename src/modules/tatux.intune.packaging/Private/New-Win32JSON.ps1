# Takes in a JSON file and generates a Win32LOBApp JSON Object for Create, Delete and Update operations.
function New-Win32JSON {
    [CmdletBinding()]
    param (
        [Parameter(ParameterSetName = 'File')]
        [ValidateScript({
                if (Test-Path -Path $_) {
                    if ($null -ne [System.Text.Json.JsonDocument]::Parse($(Get-Content -Path $_ -Raw))) { 
                        $true 
                    }
                    else { 
                        throw "$Path is not a valid JSON file."
                    }
                }
                else { 
                    throw "File does not exist."
                }
            })]
        [string]$Path,
        [Parameter(ParameterSetName = 'Content')]
        [ValidateScript({
                $JSONTest = [System.Text.Json.JsonDocument]::Parse($_)
                if ($null -ne $JSONTest) { 
                    $true 
                }
                else { 
                    throw "Input string is not a valid JSON."
                }
            })]
        [string]$JSONContent,
        [Parameter(ParameterSetName = 'Content')]
        [Parameter(ParameterSetName = 'File')]
        [ValidateSet('Create', 'Update')]
        [string]$ReturnType
    )
    
    begin {
        # Get the JSON content based on the parameter set
        if ($PSCmdlet.ParameterSetName -eq 'File') {
            try {
                $JSONContent = Get-Content -Path $Path -Raw | ConvertFrom-Json -ErrorAction Stop
            }
            catch {
                Write-Error -Message "Failed to read JSON file. $_"
                break
            }
        }
        if ($PSCmdlet.ParameterSetName -eq 'Content') {
            try {
                $JSONContent = $JSONContent | ConvertFrom-Json
            }
            catch {
                Write-Error -Message "Failed to convert JSON content. $_"
                break
            }
        }
        # Extract common fields from imported JSON to minimise repetition when modifying JSON output based on $ReturnType method
        $hashTable = @{
            "@odata.type" = "#microsoft.graph.win32LobApp"
            "displayName" = $null
            "description" = $null
            "publisher" = $null
            "largeIcon" = $null
            "isFeatured" = $null
            "privacyInformationUrl" = $null
            "informationUrl" = $null
            "owner" = $null
            "developer" = $null
            "notes" = $null
            "publishingState" = "processing"
            "committedContentVersion" = $null
            "fileName" = $null
            "size" = $null
            "installCommandLine" = $null
            "uninstallCommandLine" = $null
            "applicableArchitectures" = $null
            "minimumFreeDiskSpaceInMB" = $null
            "minimumMemoryInMB" = $null
            "minimumNumberOfProcessors" = $null
            "minimumCpuSpeedInMHz" = $null
            "rules" = $null
            "returnCodes" = $null
            "msiInformation" = $null
            "setupFilePath" = $null
            "minimumSupportedWindowsRelease" = $null
        }
        $hashTable.GetEnumerator() | ForEach-Object {
            if ($JSONContent.ContainsKey($_.Key)) {
                $_.Value = $JSONContent[$_.Key]
            }
        }
    }
    
    process {
        # Modify $Hash based on $ReturnType
        #region Create
        if ($ReturnType -eq 'Create') {
            $hashTable.Add("installExperience")
            $hashTable.installExperience = @{
                "@odata.type" = "microsoft.graph.win32LobAppInstallExperience"
                runAsAccount = $JSONContent.InstallFor
                deviceRestartBehavior = $JSONContent.RestartBehavior
            }
            $hashTable.committedContentVersion = $JSONContent.Version
        }
        #endregion
        #region Update
        if ($ReturnType -eq 'Update') {
            $hashTable.Add("id")
            $hashTable.id = $JSONContent.id
            # Remove fields that are not required for Update
            $hashTable.Remove("installExperience")
            # Remove any empty fields
        }
        #endregion
        #region Everything Else
        #region LargeIcon
        $hashTable.Add("largeIcon")
        $Type = $(Get-Item -Path $JSONContent.LogoPath | Select-Object -ExpandProperty Extension).Replace(".", "")
        $BinaryToString = [System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes($JSONContent.LogoPath)) 
        $_LargeIcon = @{
            "@odata.type" = "#microsoft.graph.mimeContent"
            "type"        = "image/$Type"
            "value"       = "$BinaryToString"
        }
        $hashTable.largeIcon = $_LargeIcon
        #endregion LargeIcon
        #region Rules
        #endregion Rules
        #endregion Everything Else
    }
    
    end {
        
    }
}
