function Set-ModuleConfig {
    [CmdletBinding(HelpUri = 'https://pwsh.dev.tatux.co.uk/tatux.utils/docs/Set-ModuleConfig.html')]
    param(
        [Parameter(HelpMessage = "Determines if the update message is displayed when the module is loaded.")]
        [ValidateSet('True', 'False')]
        [string]$UpdateWarning,
    
        [Parameter(HelpMessage = "Name of the module the configurationis being set for.")]
        [string]$ModuleName,

        [Parameter(HelpMessage = "Path of the module config.")]
        [string]$ModuleConfigFilePath,

        [Parameter(HelpMessage = "Path of the module.")]
        [string]$ModuleConfigPath,

        [Parameter(HelpMessage = "Path of the module.")]
        [string]$ModulePath,

        [switch]$BasicTelemetry
    )

    # Test to see if module config JSON exists and create it if it doesn't
    if (-not (Test-Path -Path $ModuleConfigFilePath)) {
        New-Item -Path $ModuleConfigFilePath -ItemType File -Force -Confirm:$false | Out-Null
        $NewConfig = Get-ParameterValues -PSBoundParametersHash $PSBoundParameters
        $NewConfig | ConvertTo-Json | Set-Content -Path $ModuleConfigFilePath -Force -Confirm:$false
    }
    else {
        # Read the module config JSON
        $Config = (Get-Content -Path $ModuleConfigFilePath | ConvertFrom-Json)
        $ConfigHashTable = @{}
        $Config.PSObject.Properties | ForEach-Object { $ConfigHashTable[$_.Name] = $_.Value }
        # Update or add new values to the module config JSON
        $NewConfig = Get-ParameterValues -PSBoundParametersHash $PSBoundParameters
        Write-Verbose "Updating module config with the following values: $NewConfig"
        $NewConfig.GetEnumerator() | ForEach-Object {
            $Key = $_.Key
            $Value = $_.Value
            if ($ConfigHashTable.ContainsKey($Key)) {
                $ConfigHashTable[$Key] = $Value
            }
            else {
                $ConfigHashTable.Add($Key, $Value)
            }
        }
        $ConfigHashTable | ConvertTo-Json | Set-Content -Path $ModuleConfigFilePath -Force -Confirm:$false
    }
}