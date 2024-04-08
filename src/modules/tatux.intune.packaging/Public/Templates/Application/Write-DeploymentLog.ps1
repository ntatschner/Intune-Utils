function Write-DeploymentLog {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Message,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Info", "Warning", "Error")]
        [string]$MessageType = "Info",

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$LogPath
    )
    # Create a variable in the caller scope with the fist instance of the function call date
    if (-not (Get-Variable -Name "FirstCallDate" -Scope 1 -ErrorAction SilentlyContinue)) {
        Set-Variable -Name "FirstCallDate" -Value (Get-Date) -Scope 1
    }
    # Check if the file exists
    if (-not (Test-Path -Path $LogPath)) {
        # The file does not exist, create it
        New-Item -Path $LogPath -ItemType File -Force

        # Get the current date and time
        $currentDateTime = Get-Date -Format "[yyyy-MM-dd HH:mm:ss]"

        # Get the current user
        $currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name

        # Get the context it was launched in
        $launchContext = $ExecutionContext.SessionState.LanguageMode

        # Create the log entry
        $logEntry = "$currentDateTime - [$MessageType] - File created by $currentUser in context $launchContext"

        # Write the log entry to the file
        Add-Content -Path $LogPath -Value $logEntry
    }

    # Format the log message
    $LogMessage = "[$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")] [Runtime: $($((Get-Date) - $FirstCallDate).ToString('hh\:mm\:ss\.fff'))]- [$MessageType] - $Message"

    # Write the log message to the file
    Add-Content -Path $LogPath -Value $LogMessage
}