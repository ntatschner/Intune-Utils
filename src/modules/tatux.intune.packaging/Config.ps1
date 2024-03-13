#region read in or create an initial config file and variable
$ConfigFile = "Config.psd1"

if (Test-Path "$PSScriptRoot\$ConfigFile") {
    try {
	$Params     = @{
	    BaseDirectory = $PSScriptRoot
	    FileName      = $ConfigFile
	}
	$Config = Import-LocalizedData @Params
	foreach ($variable in $Config.keys) {
	    Write-Verbose "Setting $var variable."
	    New-Variable -Name "$variable" -Value $Config.$variable -Force
	    Export-ModuleMember -Variable $variable
	}
    } catch {
	Write-Warning "Invalid configuration data in $ConfigFile."
	Write-Warning "Please fill out or correct $PSScriptRoot\$ConfigFile."
	Write-Verbose $_.Exception.Message
	Write-Verbose $_.InvocationInfo.ScriptName
	Write-Verbose $_.InvocationInfo.PositionMessage
    }
} else {
    @"
@{
    Variable = ""
}
"@ | Out-File -Encoding UTF8 -FilePath "$PSScriptRoot\$ConfigFile"
    Write-Warning "Generated $PSScriptRoot\$ConfigFile."
    Write-Warning "Please edit $ConfigFile and re-import module."
}
#endregion
