function Set-ModuleConfig {
        [CmdletBinding(HelpUri = 'https://pwsh.dev.tatux.co.uk/tatux.intune.packaging/docs/Set-ModuleConfig/')]
    param(
        [Parameter(HelpMessage = "Determines if the update message is displayed when the module is loaded.")]
        [ValidateSet('True', 'False')]
        [string]$UpdateWarning,
        
        [Parameter(HelpMessage = "Name of the module the configurationis being set for.")]
        [string]$ModuleName,

        [Parameter(HelpMessage = "Path of the module.")]
        [string]$ModulePath
    )

    $ConfigPath = Join-Path -Path $(Split-Path -Path $PSScriptRoot -Parent) -ChildPath 'Module.Config.json'
    # Test to see if module config JSON exists and create it if it doesn't
    if (-not (Test-Path -Path $ConfigPath)) {
        New-Item -Path $ConfigPath -ItemType File -Force -Confirm:$false | Out-Null
        $NewConfig = Get-ParameterValues -PSBoundParametersHash $PSBoundParameters
        $NewConfig | ConvertTo-Json | Set-Content -Path $ConfigPath -Force -Confirm:$false
    }
    else {
        # Read the module config JSON
        $Config = (Get-Content -Path $ConfigPath | ConvertFrom-Json)
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
        $ConfigHashTable | ConvertTo-Json | Set-Content -Path $ConfigPath -Force -Confirm:$false
    }
}