function Get-ModuleConfig {
    [OutputType([hashtable])]
    
    $ConfigPath = Join-Path -Path $(Split-Path -Path $PSScriptRoot -Parent) -ChildPath 'ModuleConfig.json'
    $ConfigDefaults = Join-Path -Path $(Split-Path -Path $PSScriptRoot -Parent) -ChildPath "\Config\Module.Defaults.json"
    # Test to see if module config JSON exists and create it if it doesn't
    if (-not (Test-Path -Path $ConfigPath)) {
        $DefaultConfig = Get-Content -Path $ConfigDefaults | ConvertFrom-Json
        $HashTable = @{}
        $DefaultConfig.PSObject.Properties | ForEach-Object { $HashTable[$_.Name] = $_.Value }
        Set-ModuleConfig @HashTable
        Get-ModuleConfig
    } else {
        $DefaultConfig = Get-Content -Path $ConfigDefaults | ConvertFrom-Json
        $HashTable = @{}
        $DefaultConfig.PSObject.Properties | ForEach-Object { $HashTable[$_.Name] = $_.Value }
        $HashTable
    }
}