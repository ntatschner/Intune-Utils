param(
    [switch]$Uninstall
)
# Install application defined in the Intune-I-MainInstaller.json file and run and pre and post installation scripts

# Importing the install configuration json file
$InstallConfig = Get-Content -Path "$PSScriptRoot\config.installer.json" | ConvertFrom-Json

#region Global Variables
$ConfigBase = if ($InstallConfig.target -eq "user") { $env:APPDATA } else { ${env:ProgramFiles(x86)} }
$APFBase = "APF"
$InvalidChars = [System.IO.Path]::GetInvalidFileNameChars()
$Extention = $InstallConfig.filename -split "\." | Select-Object -Last 1
$LogName = $InstallConfig.filename.Replace($Extention, "log")
$InvalidChars | % { $LogName = $LogName -replace [regex]::Escape($_), "" }
$LoggingPath = Join-Path -Path (Join-Path -Path $ConfigBase -ChildPath "\$APFBase\UserLogs\") -ChildPath $LogName
$ExistingConfig = $false
$StartTime = Get-Date
#endregion Global Variables

#region Logging function
try {
    Import-Module -Name "$PSScriptRoot\Write-DeploymentLog.ps1" -Force -ErrorAction Stop
}
Catch {
    Write-Host "Failed to import the logging function with error: $_"
    exit 1
}
#endregion Logging Function
Write-DeploymentLog -Message "APF Started." -MessageType "Info" -LogPath $LoggingPath
# Setup Working Directory

# Create config directory if it dosent exist

if (-not (Test-Path -Path "$ConfigBase\$APFBase\AppConfigs")) {
    Write-DeploymentLog -Message "Creating the APF App Configs folder" -MessageType "Info" -LogPath $LoggingPath
    New-Item -Path "$ConfigBase\$APFBase\AppConfigs" -ItemType Directory -Force
}

if (-not (Test-Path -Path "$ConfigBase\$APFBase\AppConfigs\$($InstallConfig.name)_config.installer.json")) {
    Write-DeploymentLog -Message "Installer config dosen't exist in the APF App Configs folder" -MessageType "Info" -LogPath $LoggingPath
}
else {
    $ExistingConfig = $true
    $LocalConfig = Get-Content -Path "$ConfigBase\$APFBase\AppConfigs\$($InstallConfig.name)_config.installer.json" | ConvertFrom-Json
    if ($LocalConfig -ne $InstallConfig) {
        if (([version]$InstallConfig.version -gt [version]$LocalConfig.version) -and (-not $Uninstall)) {
            Write-DeploymentLog -Message "The installer config is newer than the one in the APF App Configs folder, this installation will upgrade the existing installation" -MessageType "Info" -LogPath $LoggingPath
        }
        elseif (([version]$InstallConfig.version -lt [version]$LocalConfig.version) -and (-not $Uninstall)) {
            Write-DeploymentLog -Message "The installer config is older than the one in the APF App Configs folder, this installation will not be performed" -MessageType "Info" -LogPath $LoggingPath
            exit 0
        }
        elseif (([version]$InstallConfig.version -eq [version]$LocalConfig.version) -and (-not $Uninstall)) {
            Write-DeploymentLog -Message "The version number in the installer config is the same as the one in the APF App Configs folder, check if another value has changed, this installation will not be performed" -MessageType "Info" -LogPath $LoggingPath
            exit 0
        }
    }
    else {
        Write-DeploymentLog -Message "The installer config is the same as the one in the APF Scripts folder, Detection might have failed. Aborting" -MessageType "Info" -LogPath $LoggingPath
        exit 1
    }
}

# Check if the pre-install script exists

if (-not [string]::IsNullOrEmpty($InstallConfig.precommandfile)) {
    Write-DeploymentLog -Message "Pre-install script found, running $($InstallConfig.precommandfile)" -MessageType "Info" -LogPath $LoggingPath
    try {
        Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -File `"$PSScriptRoot\$($InstallConfig.precommandfile)`"" -Wait -NoNewWindow -ErrorAction Stop
    }
    Catch {
        Write-DeploymentLog -Message "Failed to run pre-install script with error: $_" -MessageType "Error" -LogPath $LoggingPath
        exit 1
    }
}

if ($Uninstall) {
    if ($InstallConfig.uninstallpath -eq "") {
        Write-DeploymentLog -Message "Uninstall path not found in the config.installer.json file, trying Uninstall Switches on setup file" -MessageType "Warning" -LogPath $LoggingPath
        $Script:UninstallPath = Join-Path -Path $PSScriptRoot -ChildPath $InstallConfig.filename
        Write-DeploymentLog -Message "Uninstall Path: $UninstallPath" -MessageType "Info" -LogPath $LoggingPath
    }
    else {
        if ($InstallConfig.target -eq "user") {
            $Script:UninstallPath = $InstallConfig.uninstallpath -replace "c:\\Users\\[^\\]*\\", "C:\Users\$($Env:USERNAME)\"
            Write-DeploymentLog -Message "Uninstall Path: $UninstallPath" -MessageType "Info" -LogPath $LoggingPath
        }
        else {
            Write-DeploymentLog -Message "Uninstall Path: $UninstallPath" -MessageType "Info" -LogPath $LoggingPath
            $Script:UninstallPath = $InstallConfig.uninstallpath
        }
    }

    Write-DeploymentLog -Message "Uninstalling $($InstallConfig.name), Version $($InstallConfig.version) with Uninstall Path $($UninstallPath)" -MessageType "Info" -LogPath $LoggingPath
    Write-DeploymentLog -Message "Imported the following configuration: `n$($InstallConfig | ConvertTo-Json -Depth 5)" -MessageType "Info" -LogPath $LoggingPath
    if ($UninstallPath -match ".msi") {
        try {
            $UninstallSplat = @{
                FilePath         = "msiexec.exe"
                WorkingDirectory = $(if ($UninstallPath -contains " ") { Split-Path -Path $UninstallPath -Parent } else { $UninstallPath })
                ArgumentList     = "/x `"$(Split-Path -Path $UninstallPath -Leaf)`" $($InstallConfig.uninstallswitches)"
                NoNewWindow      = $true
                Wait             = $true
                ErrorAction      = "Stop"
                PassThru         = $true
            }
            Write-DeploymentLog -Message "Splat contains: `n$($UninstallSplat | ConvertTo-Json -Depth 5)" -MessageType "Info" -LogPath $LoggingPath
            Write-DeploymentLog -Message "MSI Found. Running msiexec.exe /x `"$UninstallPath`" $($InstallConfig.uninstallswitches)" -MessageType "Info" -LogPath $LoggingPath
            Start-Process @UninstallSplat
            Write-DeploymentLog -Message "Process ID: $($Process.Id)" -MessageType "Info" -LogPath $LoggingPath
            Write-DeploymentLog -Message "Process Exit Code: $($Process.ExitCode)" -MessageType "Info" -LogPath $LoggingPath
            if ($Process.ExitCode -ne 0) {
                Write-Error -Message "ExitCode: $($Process.ExitCode)"
                throw "ExitCode: $($Process.ExitCode)"
            }
            else {
                Write-DeploymentLog -Message "Uninstall completed successfully" -MessageType "Info" -LogPath $LoggingPath
                if ($InstallConfig.shortcut) {
                    Write-DeploymentLog -Message "Removing shortcuts" -MessageType "Info" -LogPath $LoggingPath
                    foreach ($Shortcut in $InstallConfig.CreatedShortcuts) {
                        if (Test-Path -Path $Shortcut) {
                            Remove-Item -Path $Shortcut -Force -Confirm:$false
                        }
                    }
                }
                if ($ExistingConfig -eq $true) {
                    Remove-Item -Path "$ConfigBase\$APFBase\AppConfigs\$($InstallConfig.name)_config.installer.json" -Force -Confirm:$false
                }
            }
        }
        Catch {
            Write-DeploymentLog -Message "Failed to uninstall $($InstallConfig.name), Version $($InstallConfig.version) with error: $($_.Exception.Message)" -MessageType "Error" -LogPath $LoggingPath
            exit 1
        }
    }
    else {
        try {
            $UninstallSplat = @{
                FilePath         = "cmd.exe"
                WorkingDirectory = $(if ($UninstallPath -match " ") { Split-Path -Path $UninstallPath -Parent } else { $UninstallPath })
                ArgumentList     = "/c $(Split-Path -Path $UninstallPath -Leaf) $($InstallConfig.uninstallswitches)"
                NoNewWindow      = $true
                Wait             = $true
                ErrorAction      = "Stop"
                PassThru         = $true
            }
            Write-DeploymentLog -Message "Splat contains: `n$($UninstallSplat | ConvertTo-Json -Depth 5)" -MessageType "Info" -LogPath $LoggingPath
            Write-DeploymentLog -Message "EXE Found. Running cmd.exe /c `"$UninstallPath`" $($InstallConfig.uninstallswitches)" -MessageType "Info" -LogPath $LoggingPath
            $Process = Start-Process @UninstallSplat
            Write-DeploymentLog -Message "Process ID: $($Process.Id)" -MessageType "Info" -LogPath $LoggingPath
            Write-DeploymentLog -Message "Process Exit Code: $($Process.ExitCode)" -MessageType "Info" -LogPath $LoggingPath
            if ($Process.ExitCode -ne 0) {
                Write-Error -Message "ExitCode: $($Process.ExitCode)"
                throw "ExitCode: $($Process.ExitCode)"
            }
            else {
                Write-DeploymentLog -Message "Uninstall completed successfully" -MessageType "Info" -LogPath $LoggingPath
                if ($InstallConfig.shortcut) {
                    Write-DeploymentLog -Message "Removing shortcuts" -MessageType "Info" -LogPath $LoggingPath
                    foreach ($Shortcut in $InstallConfig.CreatedShortcuts) {
                        if (Test-Path -Path $Shortcut) {
                            Remove-Item -Path $Shortcut -Force -Confirm:$false
                        }
                    }
                }
                if ($ExistingConfig -eq $true) {
                    Remove-Item -Path "$ConfigBase\$APFBase\AppConfigs\$($InstallConfig.name)_config.installer.json" -Force -Confirm:$false
                }
            }
        }
        Catch {
            Write-DeploymentLog -Message "Failed to uninstall $($InstallConfig.name), Version $($InstallConfig.version) with error: $($_.Exception.Message)" -MessageType "Error" -LogPath $LoggingPath
            exit 1
        }
    }
    $Script:TimeTaken = $(Get-Date) - $StartTime
    Write-DeploymentLog -Message "Uninstallation of $($InstallConfig.name), Version $($InstallConfig.version) took $($TimeTaken.ToString('hh\:mm\:ss\.fff'))" -MessageType "Info" -LogPath $LoggingPath
    exit 0
}
else {
    Write-DeploymentLog -Message "Starting installation of $($InstallConfig.name), Version $($InstallConfig.version)" -MessageType "Info" -LogPath $LoggingPath
    # Log the config import
    Write-DeploymentLog -Message "Imported the following configuration: `n$($InstallConfig | ConvertTo-Json -Depth 5)" -MessageType "Info" -LogPath $LoggingPath
    # Set the execution policy to bypass
    Write-DeploymentLog -Message "Setting the execution policy to bypass" -MessageType "Info" -LogPath $LoggingPath
    Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
    # Install the application
    Write-DeploymentLog -Message "Installing $($InstallConfig.name), Version $($InstallConfig.version) with Installation Switches $($InstallConfig.installswitches)" -MessageType "Info" -LogPath $LoggingPath
    # Check if the application is an MSI or an executable
    if ($InstallConfig.filename -match ".msi") {
        # The application is an MSI, install it using msiexec
        try {
            $InstallSplat = @{
                FilePath         = "msiexec.exe"
                WorkingDirectory = $PSScriptRoot
                ArgumentList     = "/i `"$($InstallConfig.filename)`" $($InstallConfig.installswitches)"
                NoNewWindow      = $true
                Wait             = $true
                ErrorAction      = "Stop"
                PassThru         = $true
            }
            Write-DeploymentLog -Message "Splat contains: `n$($InstallSplat | ConvertTo-Json -Depth 5)" -MessageType "Info" -LogPath $LoggingPath
            Write-DeploymentLog -Message "MSI Found. Running Command: $($InstallSplat.FilePath) $($InstallSplat.ArgumentList)" -MessageType "Info" -LogPath $LoggingPath
            $Process = Start-Process @InstallSplat
            Write-DeploymentLog -Message "Process ID: $($Process.Id)" -MessageType "Info" -LogPath $LoggingPath
            Write-DeploymentLog -Message "Process Exit Code: $($Process.ExitCode)" -MessageType "Info" -LogPath $LoggingPath
            if ($Process.ExitCode -ne 0) {
                Write-Error -Message "ExitCode: $($Process.ExitCode)"
                throw "ExitCode: $($Process.ExitCode)"
            }
            else {
                Write-DeploymentLog -Message "Installation completed successfully" -MessageType "Info" -LogPath $LoggingPath
                # Create a config file for the installed application
                if ($ExistingConfig -eq $false) {
                    Write-DeploymentLog -Message "Creating the config file for the installed application" -MessageType "Info" -LogPath $LoggingPath
                    $InstallConfig | ConvertTo-Json | Set-Content -Path "$ConfigBase\$APFBase\AppConfigs\$($InstallConfig.name)_config.installer.json"
                }
                else {
                    # Backup previous config file
                    Write-DeploymentLog -Message "Backing up the previous config file for the installed application" -MessageType "Info" -LogPath $LoggingPath
                    Copy-Item -Path "$ConfigBase\$APFBase\AppConfigs\$($InstallConfig.name)_config.installer.json" -Destination "$ConfigBase\$APFBase\AppConfigs\$($InstallConfig.name)_config.installer.json.bak" -Force
                    Write-DeploymentLog -Message "Updating the config file for the installed application" -MessageType "Info" -LogPath $LoggingPath
                    $InstallConfig | ConvertTo-Json | Set-Content -Path "$ConfigBase\$APFBase\AppConfigs\$($InstallConfig.name)_config.installer.json"
                }
            }
        }
        Catch {
            $Script:TimeTaken = $(Get-Date) - $StartTime
            Write-DeploymentLog -Message "Failed to install $($InstallConfig.name), Version $($InstallConfig.version) with error: $_" -MessageType "Error" -LogPath $LoggingPath
            exit 1
        }
    }
    else {
        # The application is not an MSI, install it using the executable
        try {
            $InstallSplat = @{
                FilePath         = "cmd.exe"
                WorkingDirectory = $PSScriptRoot
                ArgumentList     = "/c $($InstallConfig.filename) $($InstallConfig.installswitches)"
                NoNewWindow      = $true
                Wait             = $true
                ErrorAction      = "Stop"
                PassThru         = $true
            }
            Write-DeploymentLog -Message "Splat contains: `n$($InstallSplat | ConvertTo-Json -Depth 5)" -MessageType "Info" -LogPath $LoggingPath
            Write-DeploymentLog -Message "EXE Found. Running Command: $($InstallSplat.FilePath) $($InstallSplat.ArgumentList)" -MessageType "Info" -LogPath $LoggingPath
            $Process = Start-Process @InstallSplat
            Write-DeploymentLog -Message "Process ID: $($Process.Id)" -MessageType "Info" -LogPath $LoggingPath
            Write-DeploymentLog -Message "Process Exit Code: $($Process.ExitCode)" -MessageType "Info" -LogPath $LoggingPath
            if ($Process.ExitCode -ne 0) {
                Write-Error -Message "ExitCode: $($Process.ExitCode)"
                throw "ExitCode: $($Process.ExitCode)"
            }
            else {
                Write-DeploymentLog -Message "Installation completed successfully" -MessageType "Info" -LogPath $LoggingPath
                if ( -not [string]::IsNullOrEmpty($InstallConfig.shortcut)) {
                    # Get all the Start Menu Shotcuts just created so we can create the defined shortcut in the config file
                    $TimeLimit = (Get-Date).AddSeconds(-5)
                    $StartMenuShortcuts = Get-ChildItem -Path "$env:APPDATA\Microsoft\Windows\Start Menu\Programs" -Recurse -Include "*.lnk" | Where-Object { $_.CreationTime -gt $TimeLimit } | Where-Object { $_.Name -notmatch "Uninstall|remove|readme|guide" }
                    if ($StartMenuShortcuts -eq $null) {
                        Write-DeploymentLog -Message "No Start Menu Shortcuts found" -MessageType "Info" -LogPath $LoggingPath
                    }
                    else {
                        foreach ($Shortcut in $StartMenuShortcuts) {
                            $WshShell = New-Object -ComObject WScript.Shell
                            $ShortcutObject = $WshShell.CreateShortcut($Shortcut)
                            try {                            
                                Write-DeploymentLog -Message "Creating shortcut $($Shortcut.BaseName)" -MessageType "Info" -LogPath $LoggingPath
                                $ShortcutFullPath = Join-Path -Path $ShortcutBasePath -ChildPath "$($Shortcut.BaseName).lnk"
                                $WshShell = New-Object -ComObject WScript.Shell
                                $Shortcut = $WshShell.CreateShortcut($ShortcutFullPath)
                                $Shortcut.TargetPath = $ShortcutObject.TargetPath
                                $Shortcut.Save()
                                $InstallConfig.CreatedShortcuts += $ShortcutFullPath
                            }
                            Catch {
                                Write-DeploymentLog -Message "Failed to create shortcut with error: $_" -MessageType "Error" -LogPath $LoggingPath
                            }
                        }
                    }
                }
                # Create a config file for the installed application
                if ($ExistingConfig -eq $false) {
                    Write-DeploymentLog -Message "Creating the config file for the installed application" -MessageType "Info" -LogPath $LoggingPath
                    $InstallConfig | ConvertTo-Json | Set-Content -Path "$ConfigBase\$APFBase\AppConfigs\$($InstallConfig.name)_config.installer.json"
                }
                else {
                    # Backup previous config file
                    Write-DeploymentLog -Message "Backing up the previous config file for the installed application" -MessageType "Info" -LogPath $LoggingPath
                    Copy-Item -Path "$ConfigBase\$APFBase\AppConfigs\$($InstallConfig.name)_config.installer.json" -Destination "$ConfigBase\$APFBase\AppConfigs\$($InstallConfig.name)_config.installer.json.bak" -Force
                    Write-DeploymentLog -Message "Updating the config file for the installed application" -MessageType "Info" -LogPath $LoggingPath
                    $InstallConfig | ConvertTo-Json | Set-Content -Path "$ConfigBase\$APFBase\AppConfigs\$($InstallConfig.name)_config.installer.json"
                }
            }          
        }
        Catch {
            Write-DeploymentLog -Message "Failed to install $($InstallConfig.name), Version $($InstallConfig.version) with error: $_" -MessageType "Error" -LogPath $LoggingPath
            exit 1
        }
    }
    Write-DeploymentLog -Message "Installation of $($InstallConfig.name), Version $($InstallConfig.version) completed successfully" -MessageType "Info" -LogPath $LoggingPath
    $Script:TimeTaken = $(Get-Date) - $StartTime
    Write-DeploymentLog -Message "Installation of $($InstallConfig.name), Version $($InstallConfig.version) took $($TimeTaken.ToString('hh\:mm\:ss\.fff'))" -MessageType "Info" -LogPath $LoggingPath
}
# Check if the post-install script exists

if (-not [string]::IsNullOrEmpty($InstallConfig.postcommandfile)) {
    Write-DeploymentLog -Message "Post-install script found, running $($InstallConfig.postcommandfile)" -MessageType "Info" -LogPath $LoggingPath
    # Run the post-install script
    try {
        Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -File `"$PSScriptRoot\$($InstallConfig.postcommandfile)`"" -Wait -NoNewWindow -ErrorAction Stop
    }
    Catch {
        Write-DeploymentLog -Message "Failed to run post-install script with error: $_" -MessageType "Error" -LogPath $LoggingPath
        exit 1
    }
}
Write-DeploymentLog -Message "APF Completed." -MessageType "Info" -LogPath $LoggingPath
exit 0