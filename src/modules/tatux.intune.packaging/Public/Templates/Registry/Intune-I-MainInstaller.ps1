param(
    [switch]$Uninstall
)
# Install application defined in the Intune-I-MainInstaller.json file and run and pre and post installation scripts

# Importing the install configuration json file
$InstallConfig = Get-Content -Path "$PSScriptRoot\config.installer.json" | ConvertFrom-Json

#region Global Variables
$ConfigBase = if ($InstallConfig.target -eq "user") { $env:APPDATA } else { ${env:ProgramFiles(x86)} }
$APFBase = "APF"
$APFFullBase = Join-Path -Path $ConfigBase -ChildPath $APFBase
$StorageFolderBase = "PersistentStorage"
$StorageFolderName = $(if ([string]::IsNullOrEmpty($ConfigBase.name)) {"registry"} {"$($ConfigBase.name)"})
$StorageFolderFullPath = Join-Path -Path $APFFullBase -ChildPath "$StorageFolderBase\$StorageFolderName"
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
    Write-DeploymentLog -Message "Managing Registry config $($InstallConfig.name), Version $($InstallConfig.version)." -MessageType "Info" -LogPath $LoggingPath
    
    # Create storage folder if it dosent exist
    
    if (-not (Test-Path -Path $StorageFolderFullPath)) {
        Write-DeploymentLog -Message "Creating the APF storage folder" -MessageType "Info" -LogPath $LoggingPath
        New-Item -Path $StorageFolderFullPath -ItemType Directory -Force
    }

    # Create a local copy of registry CSV File
    if (Test-Path -Path "$PSScriptRoot\$($InstallConfig.name)_Registry.csv") {
        Copy-Item -Path "$PSScriptRoot\$($InstallConfig.name)_Registry.csv" -Destination "$StorageFolderFullPath\$($InstallConfig.name)_Registry.csv" -Force
    } else {
        Write-DeploymentLog -Message "Registry CSV File not found" -MessageType "Error" -LogPath $LoggingPath
        exit 1
    }
    # Process the CSV File to make the registry modifications
    $RegistryData = Import-Csv -Path "$StorageFolderFullPath\$($InstallConfig.name)_Registry.csv"
    # Add new columns to the CSV File
    $RegistryData | Add-Member -MemberType NoteProperty -Name "Result" -Value ""
    $RegistryData | Add-Member -MemberType NoteProperty -Name "Error" -Value ""
    $RegistryData | Add-Member -MemberType NoteProperty -Name "OldValue" -Value ""
    # Loop through the CSV File and make the registry modifications
    foreach ($RegistryEntry in $RegistryData) {
        try {
            if ($RegistryEntry.State -eq "MODIFY") {
                if (Test-Path -Path "$($RegistryEntry.RegistryPath)\$($RegistryEntry.KeyName)") {
                    $RegistryEntry.OldValue = Get-ItemProperty -Path "$($RegistryEntry.RegistryPath)\$($RegistryEntry.KeyName)" -Name $RegistryEntry.ValueData
                }
                else {
                    $RegistryEntry.Result = "Failed"
                    $RegistryEntry.Error = "Path not found"
                    continue
                }

                if ($RegistryEntry.Type -eq "String") {
                    Set-ItemProperty -Path $RegistryEntry.Path -Name $RegistryEntry.Name -Value $RegistryEntry.Value -Force
                }
                elseif ($RegistryEntry.Type -eq "DWord") {
                    Set-ItemProperty -Path $RegistryEntry.Path -Name $RegistryEntry.Name -Value $RegistryEntry.Value -Type DWord -Force
                }
                elseif ($RegistryEntry.Type -eq "QWord") {
                    Set-ItemProperty -Path $RegistryEntry.Path -Name $RegistryEntry.Name -Value $RegistryEntry.Value -Type QWord -Force
                }
                elseif ($RegistryEntry.Type -eq "Binary") {
                    Set-ItemProperty -Path $RegistryEntry.Path -Name $RegistryEntry.Name -Value $RegistryEntry.Value -Type Binary -Force
                }
                elseif ($RegistryEntry.Type -eq "MultiString") {
                    Set-ItemProperty -Path $RegistryEntry.Path -Name $RegistryEntry.Name -Value $RegistryEntry.Value -Type MultiString -Force
                }
                $RegistryEntry.Result = "Success"
            }
            elseif ($RegistryEntry.Action -eq "REMOVE") {
                Remove-ItemProperty -Path $RegistryEntry.Path -Name $RegistryEntry.Name -Force
                $RegistryEntry.Result = "Success"
            }
            else {
                $RegistryEntry.Result = "Failed"
                $RegistryEntry.Error = "Invalid Action"
            }
        }
        Catch {
            $RegistryEntry.Result = "Failed"
            $RegistryEntry.Error = $_.Exception.Message
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