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
        [ValidateSet('Create', 'Delete', 'Update')]
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
            "id"                             = ""
            "displayName"                    = ""
            "description"                    = ""
            "publisher"                      = ""
            "largeIcon"                      = ""
            "createdDateTime"                = $([System.DateTimeOffset]::Now.ToString())
            "lastModifiedDateTime"           = ""
            "isFeatured"                     = ""
            "privacyInformationUrl"          = ""
            "informationUrl"                 = ""
            "owner"                          = ""
            "developer"                      = ""
            "notes"                          = ""
            "publishingState"                = ""
            "committedContentVersion"        = ""
            "fileName"                       = ""
            "size"                           = ""
            "installCommandLine"             = ""
            "uninstallCommandLine"           = ""
            "applicableArchitectures"        = ""
            "minimumFreeDiskSpaceInMB"       = ""
            "minimumMemoryInMB"              = ""
            "minimumNumberOfProcessors"      = ""
            "minimumCpuSpeedInMHz"           = ""
            "rules"                          = ""
            "installExperience"              = ""
            "returnCodes"                    = ""
            "msiInformation"                 = ""
            "setupFilePath"                  = ""
            "minimumSupportedWindowsRelease" = ""
        }
        $hashTable.GetEnumerator() | ForEach-Object {
            if ($JSONContent.ContainsKey($_.Key)) {
                $_.Value = $JSONContent[$_.Key]
            }
        }
    }
    
    process {
        # Modify $Hash based on $ReturnType
        #region LargeIcon
        $_LargeIcon = @{
            "@odata.type" = "#microsoft.graph.mimeContent"
            "type"        = "String"
            "value"       = "binary"
        }
        #endregion
    }
    
    end {
        
    }
}
