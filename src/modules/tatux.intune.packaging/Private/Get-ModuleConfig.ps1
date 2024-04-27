function Get-ModuleConfig {
    [OutputType([hashtable])]
    
    $ConfigPath = Join-Path -Path $(Split-Path -Path $PSScriptRoot -Parent) -ChildPath 'Module.Config.json'
    $ConfigDefaults = Join-Path -Path $(Split-Path -Path $PSScriptRoot -Parent) -ChildPath "\Config\Module.Defaults.json"
    # Test to see if module config JSON exists and create it if it doesn't
    if (-not (Test-Path -Path $ConfigPath)) {
        $DefaultConfig = Get-Content -Path $ConfigDefaults | ConvertFrom-Json
        $HashTable = @{}
        $DefaultConfig.PSObject.Properties | ForEach-Object { $HashTable[$_.Name] = $_.Value }
        $ModulePath = (Split-Path -Path $PSCommandPath -Parent)
        while ($null -eq (Get-ChildItem -Path $ModulePath -Filter "*.psd1" -File)) {
            $ModulePath = Split-Path -Path $ModulePath -Parent
            if ($ModulePath -eq (Split-Path -Path $ModulePath -Parent)) {
                Write-Error "No .psd1 file found in the directory tree."
                return
            }
        }
        $ModuleName = Get-ChildItem -Path $ModulePath -Filter "*.psd1" -File | Select-Object -First 1 | Select-Object -ExpandProperty BaseName
        $HashTable.Add('ModuleName', $ModuleName)
        $HashTable.Add('ModulePath', $ModulePath)
        Set-ModuleConfig @HashTable
        Get-ModuleConfig
    } else {
        $Config = Get-Content -Path $ConfigPath | ConvertFrom-Json
        $HashTable = @{}
        $Config.PSObject.Properties | ForEach-Object { $HashTable[$_.Name] = $_.Value }
        $HashTable
    }
}