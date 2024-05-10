function New-APFConfigDeployment {
    param(
        [CmdletBinding(SupportsShouldProcess, HelpUri = 'https://pwsh.dev.tatux.co.uk/tatux.intune.packaging/docs/New-APFConfigDeployment.html')]
        [OutputType([string])]

        [Parameter(ParameterSetName = "config")]
        [Alias("ApplicationName", "AppName")]
        [Parameter(HelpMessage = "The name of the application. `nThis is written in to the exported configuration files. `nIf you do not provide a name, the script will attempt to generate it.")]
        [string]$Name,

        [Parameter(ParameterSetName = "config")]
        [Alias("ApplicationVersion", "AppVersion")]
        [Parameter(HelpMessage = "The version of the application. `nThis is written in to the exported configuration files. `nThis should be in the format of x.x.x.x. `nIf you do not provide a version, the script will attempt to extract it from the installer file.")]
        [version]$Version,

        [Parameter(ParameterSetName = "config")]
        [Parameter(HelpMessage = "The target for the deployment, User context or System context. Default is 'system'.")]
        [ValidateSet("system", "user")]
        [string]$Target = "system",

        [Parameter(ParameterSetName = "config", "registry", "files", "script-os", "script-app", "script-user", "custom")]
        [Parameter(HelpMessage = "The type of configuration this command is for.")]
        [ValidateSet("Registry", "Files", "Script-OS", "Script-App", "Script-User", "Custom")]
        [string]$ConfigurationType,

        [Parameter(ParameterSetName = "registry")]
        [Parameter(HelpMessage = "The registry key details to create or modify. \
        `nThis should be in the format of {fullPath: `"HKEY_LOCAL_MACHINE\Software\MyApp`", `"value`": `"Setting1`"}.\
        `nThere will also be a .csv file created where you can add as many registy items as you like.\
        `nBare in mind that any failure of any registry item will cause the whole configuration to fail.")]
        [string]$RegistryValue,

        [Parameter(ParameterSetName = "config")]
        [Parameter(HelpMessage = "Destination path for the files on the target system.")]
        [string]$DestinationPath,

        [Parameter(Mandatory = $false)]
        [Alias("IncludedFile", "SourceFile")]
        [ValidateScript({
                foreach ($i in $_) {
                    if (-not (Test-Path $_)) {
                        throw "Path $($i) is invalid, double check and try again."
                    }
                } 
                return $true
            })]
        [string[]]$Path,

        [Parameter(HelpMessage = "The folder where the output will be created. Default is the current directory.")]
        [ValidateScript({
                if (-not (Test-Path $_)) {
                    throw "The folder $_ does not exist."
                }
                return $true
            })]
        [string]$DestinationFolder = $PWD.Path,

        [Parameter(HelpMessage = "Create a Intune package for the application. Default is false.")]
        [switch]$CreateIntuneWinPackage
    )
    begin {
        try {
            $CurrentConfig = Get-ModuleConfig
            $TelmetryArgs = @{
                ModuleName    = $CurrentConfig.ModuleName
                ModulePath    = $CurrentConfig.ModulePath
                ModuleVersion = $MyInvocation.MyCommand.Module.Version
                CommandName   = $MyInvocation.MyCommand.Name
                URI           = 'https://telemetry.tatux.in/api/telemetry'
            }
            if ($CurrentConfig.BasicTelemetry -eq 'True') {
                $TelmetryArgs.Add('Minimal', $true)
            }
            Invoke-TelemetryCollection @TelmetryArgs -Stage start -ClearTimer
        }
        catch {
            Write-Verbose "Failed to load telemetry"
        }
        # Invoke-TelemetryCollection @TelmetryArgs -Stage End -ClearTimer -Failed $true -Exception $_
        # Invoke-TelemetryCollection @TelmetryArgs -Stage End -ClearTimer
    } 
    Process {

        # Create Switch on ConfigurationType

        switch ($ConfigurationType) {
            "Registry" {
                
                break
            }
            "Files" {
                break
            }
            "Script-OS" {
                break
            }
            "Script-App" {
                break
            }
            "Script-User" {
                break
            }
            "Custom" {
                break
            }
        }

        # Create subfolder for the application
        $AppFolder = Join-Path -Path $DestinationFolder -ChildPath $Name
        if (-not (Test-Path $AppFolder)) {
            New-Item -Path $AppFolder -ItemType Directory | Out-Null
        }
        else {
            if ($PSCmdlet.ShouldContinue("Overwrite existing subfolder for the application? Warning: This will recursively delete all files in the folder.", "Confirm Overwrite")) {
                Remove-Item -Path $AppFolder -Recurse -Force | Out-Null
                New-Item -Path $AppFolder -ItemType Directory | Out-Null
            }
        }
        # Copy the installer file and any additional files to the application folder
        Copy-Item -Path $Path -Destination $AppFolder
        if ($IncludedFiles) {
            foreach ($file in $IncludedFiles) {
                Copy-Item -Path $file -Destination $AppFolder
            }
        }
        # Copy the template files to the application folder
        Copy-Item -Path "$PSScriptRoot\Templates\Application\*" -Destination $AppFolder -Recurse

        # Update the template files with the application name and version
        $InstallerFileName = (Get-ChildItem -Path $Path).BaseName
        $MainConfig = Get-Content -Path "$AppFolder\config.installer.json" | ConvertFrom-Json
        $MainConfig.name = $Name
        $MainConfig.version = $Version.ToString()
        $MainConfig.filename = (Get-ChildItem -Path $Path).Name
        $MainConfig.target = $Target
        $MainConfig.installSwitches = $InstallSwitches
        $MainConfig.uninstallSwitches = $UninstallSwitches
        $MainConfig.uninstallPath = $UninstallPath
        $MainConfig | ConvertTo-Json -Depth 10 | Set-Content -Path "$AppFolder\config.installer.json"

        $DetectionScript = Get-Content -Path "$AppFolder\Intune-D-AppDetection.ps1"
        $DetectionScript = $DetectionScript -replace "##NAME_TEMPLATE", $Name
        $DetectionScript = $DetectionScript -replace "##VERSION_TEMPLATE", $Version.ToString()
        $DetectionScript = $DetectionScript -replace "##FILENAME_TEMPLATE", (Get-ChildItem -Path $Path).Name
        $DetectionScript | Set-Content -Path "$AppFolder\Intune-D-AppDetection.ps1"

        # Create IntuneWin Package
        if ($CreateIntuneWinPackage) {
            try {
                # Get module directory path
                $ModulePath = Split-Path -Path $MyInvocation.MyCommand.Module.Path
                # Test if the IntuneWinAppUtil application exists in module directory
                if (-not (Test-Path "$ModulePath\IntuneWinAppUtil.exe")) {
                    if ($PSCmdlet.ShouldContinue("The IntuneWinAppUtil.exe application was not found in the module directory. Would you like to download it now?", "Download Now?")) {
                        Get-IntunePackagingTool -Path $ModulePath
                    }
                    else {
                        Write-Warning "The IntuneWinAppUtil.exe application is required to create IntuneWin packages. Please download it manually."
                        return
                    }
                } 
                # Create IntuneWin package
                $IntunewinFullPath = Join-Path -Path $DestinationFolder -ChildPath "$InstallerFileName.intunewin"
                $MainInstallerFilePath = Join-Path -Path $AppFolder -ChildPath (Get-Item -Path $Path).Name
                if (Test-Path $IntunewinFullPath) {
                    if ($PSCmdlet.ShouldContinue("Overwrite existing IntuneWin package? Warning: This will delete the existing package.", "Confirm Overwrite")) {
                        Remove-Item -Path $IntunewinFullPath -Force
                    }
                    else {
                        Write-Warning "The IntuneWin package already exists. Please delete it manually or choose a different destination folder."
                        return
                    }
                }
                Start-Process -FilePath "$ModulePath\IntuneWinAppUtil.exe" -ArgumentList "-c `"$AppFolder`"", "-s `"$MainInstallerFilePath`"", "-o `"$DestinationFolder`"" -Wait -NoNewWindow -ErrorAction Stop
                if (-not (Test-Path $IntunewinFullPath)) {
                    throw "$IntuneWinFullPath was not created"
                }
                else {
                    Write-Output "The application '$Name' has been successfully packaged.`nThis can be found in the folder '$AppFolder'."
                    Write-Output "The application '$Name' was also packaged to an intunewin file.`nThis can be found in the folder '$DestinationFolder'."
                }
            }
            catch {
                Write-Error "Failed to create IntuneWin package: $_"
            }
        }
        else {
            Write-Output "The application '$Name' has been successfully packaged.`nThis can be found in the folder '$AppFolder'."
        }
        Write-Output "When publishing the application to Intune, use`n'powershell.exe -ExecutionPolicy Bypass -File Intune-I-MainInstaller.ps1' for the install Command and`n'powershell.exe -ExecutionPolicy Bypass -File Intune-I-MainInstaller.ps1 -Uninstall' for the Uninstall Command."
    }
}