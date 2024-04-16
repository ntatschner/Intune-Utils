function Get-ModuleConfig {
    [OutputType([hashtable])]
    
    $ConfigPath = Join-Path -Path $(Split-Path -Path $PSScriptRoot -Parent) -ChildPath 'ModuleConfig.json'
    $ConfigDefaults = Join-Path -Path $ConfigPath -ChildPath "\Config\Module.Defaults.json"
    # Test to see if module config JSON exists and create it if it doesn't
    if (-not (Test-Path -Path $ConfigPath)) {
        $DefaultConfig = Get-Content -Path $ConfigDefaults | ConvertFrom-Json -AsHashtable
        Set-ModuleConfig @DefaultConfig
        Get-ModuleConfig
    } else {
        $Config = (Get-Content -Path $ConfigPath | ConvertFrom-Json -AsHashtable)
        $Config
    }
}