function New-APFDeployment {
    param(
        [CmdletBinding(SupportsShouldProcess)]

        [Alias("ApplicationName", "AppName")]
        [Parameter(HelpMessage = "The name of the application. `nThis is written in to the exported configuration files. `nIf you do not provide a name, the script will attempt to extract it from the installer file.")]
        [string]$Name,

        [Alias("ApplicationVersion", "AppVersion")]
        [Parameter(HelpMessage = "The version of the application. `nThis is written in to the exported configuration files. `nThis should be in the format of x.x.x.x. `nIf you do not provide a version, the script will attempt to extract it from the installer file.")]
        [version]$Version,

        [Parameter(Mandatory = $true)]
        [Alias("InstallerFile", "SourceFile")]
        [ValidateScript({
            if ($_ -notmatch "\.(msi|exe)$") {
                throw "Please supply a valid installer file path. Only .msi and .exe files are supported."
            } else {
                if (-not (Test-Path $_)) {
                    throw "The file $_ does not exist."
                }
                return $true
            }
        })]
        $Path,

        [Parameter(HelpMessage = "Paths to any additional files that need to be included in the installation.")]
        [ValidateScript({
            foreach ($file in $_) {
                if (-not (Test-Path $file)) {
                    throw "The file $file does not exist."
                }
            }
            return $true
        })]
        [string[]]$IncludedFiles,

        [Parameter(HelpMessage = "The folder where the files will be copied to. Default is the current directory.")]
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

    if ($Path -match "\.msi$") {
        # Attempt to extract the application name and version from the MSI file
        $MSIProperties = Get-MSIProperties -Path $Path
        if (-not $Name) {
            $Name = $MSIProperties.ProductName
        }
        if (-not $Version) {
            $Version = $MSIProperties.ProductVersion
        }
    } else {
        $EXEProperties = Get-ItemProperty -Path $Path
        if (-not $Name) {
            $Name = $EXEProperties.BaseName
        }
        if (-not $Version) {
            $Version = [version]$EXEProperties.VersionInfo.FileVersion
        }
    }

    # Create subfolder for the application
    $AppFolder = Join-Path -Path $DestinationFolder -ChildPath $Name
    if (-not (Test-Path $AppFolder)) {
        New-Item -Path $AppFolder -ItemType Directory | Out-Null
    } else {
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
    $MainConfig = Get-Content -Path "$AppFolder\config.installer.json" | ConvertFrom-Json
    $MainConfig.name = $Name
    $MainConfig.version = $Version.ToString()
    $MainConfig.filename = (Get-ChildItem -Path $Path).Name
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
                } else {
                    Write-Warning "The IntuneWinAppUtil.exe application is required to create IntuneWin packages. Please download it manually."
                }
            } 
            # Create IntuneWin package
            $IntunewinFullPath = Join-Path -Path $DestinationFolder -ChildPath "$Name.intunewin"
            $MainInstallerFilePath = Join-Path -Path $AppFolder -ChildPath (Get-Item -Path $Path).Name
            if (Test-Path $IntunewinFullPath) {
                if ($PSCmdlet.ShouldContinue("Overwrite existing IntuneWin package? Warning: This will delete the existing package.", "Confirm Overwrite")) {
                    Remove-Item -Path $IntunewinFullPath -Force
                }
            }
            Start-Process -FilePath "cmd.exe" -ArgumentList "/c $ModulePath\IntuneWinAppUtil.exe -c $AppFolder -o $DestinationFolder -s $MainInstallerFilePath -q" -Wait -WindowStyle Hidden -ErrorAction Stop
        } catch {
            Write-Error "Failed to create IntuneWin package: $_"
        }
    }
    Write-Output "The application '$Name' has been successfully packaged.`nThis can be found in the folder '$AppFolder'."
}