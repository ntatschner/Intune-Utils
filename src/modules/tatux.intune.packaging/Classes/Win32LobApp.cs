using Microsoft.Graph.Models;

namespace Tatux.Intune.Packaging
{
    public class Win32LobApp
    {
        public string OdataType { get; } = "#microsoft.graph.win32LobApp";
        public string DisplayName { get; set; }
        public string Description { get; set; }
        public string Publisher { get; set; }
        private string _largeIcon;
        public string LargeIcon 
        { 
            get 
            { 
                return _largeIcon; 
            } 
            set 
            { 
                if (System.IO.Path.IsPathFullyQualified(value))
                {
                    _largeIcon = value; 
                }
                else
                {
                    throw new ArgumentException("Value must be a fully qualified path.");
                }
            } 
        }
        public bool IsFeatured { get; set; }
        public string PrivacyInformationUrl { get; set; }
        public string InformationUrl { get; set; }
        public string Owner { get; set; }
        public string Developer { get; set; }
        public string Notes { get; set; }
        public MobileAppPublishingState PublishingState { get; set; }
        public string CommittedContentVersion { get; set; }
        public string FileName { get; set; }
        public long Size { get; set; }
        public string InstallCommandLine { get; set; }
        public string UninstallCommandLine { get; set; }
        public WindowsArchitecture ApplicableArchitectures { get; set; }
        public long MinimumFreeDiskSpaceInMB { get; set; }
        public long MinimumMemoryInMB { get; set; }
        public long MinimumNumberOfProcessors { get; set; }
        public long MinimumCpuSpeedInMHz { get; set; }
        public List<Win32LobAppRule> Rules { get; set; }
        public Win32LobAppInstallExperience InstallExperience { get; set; }
        public List<Win32LobAppReturnCode> ReturnCodes { get; set; }
        public Win32LobAppMsiInformation MsiInformation { get; set; }
        public string SetupFilePath { get; set; }
        public string MinimumSupportedWindowsRelease { get; set; }
    }
}

var requestBody = new Win32LobApp
{
	OdataType = "#microsoft.graph.win32LobApp",
	DisplayName = "Display Name value",
	Description = "Description value",
	Publisher = "Publisher value",
	LargeIcon = new MimeContent
	{
		OdataType = "microsoft.graph.mimeContent",
		Type = "Type value",
		Value = Convert.FromBase64String("dmFsdWU="),
	},
	IsFeatured = true,
	PrivacyInformationUrl = "https://example.com/privacyInformationUrl/",
	InformationUrl = "https://example.com/informationUrl/",
	Owner = "Owner value",
	Developer = "Developer value",
	Notes = "Notes value",
	PublishingState = MobileAppPublishingState.Processing,
	CommittedContentVersion = "Committed Content Version value",
	FileName = "File Name value",
	Size = 4L,
	InstallCommandLine = "Install Command Line value",
	UninstallCommandLine = "Uninstall Command Line value",
	ApplicableArchitectures = WindowsArchitecture.X86,
	MinimumFreeDiskSpaceInMB = 8,
	MinimumMemoryInMB = 1,
	MinimumNumberOfProcessors = 9,
	MinimumCpuSpeedInMHz = 4,
	Rules = new List<Win32LobAppRule>
	{
		new Win32LobAppRegistryRule
		{
			OdataType = "microsoft.graph.win32LobAppRegistryRule",
			RuleType = Win32LobAppRuleType.Requirement,
			Check32BitOn64System = true,
			KeyPath = "Key Path value",
			ValueName = "Value Name value",
			OperationType = Win32LobAppRegistryRuleOperationType.Exists,
			Operator = Win32LobAppRuleOperator.Equal,
			ComparisonValue = "Comparison Value value",
		},
	},
	InstallExperience = new Win32LobAppInstallExperience
	{
		OdataType = "microsoft.graph.win32LobAppInstallExperience",
		RunAsAccount = RunAsAccountType.User,
		DeviceRestartBehavior = Win32LobAppRestartBehavior.Allow,
	},
	ReturnCodes = new List<Win32LobAppReturnCode>
	{
		new Win32LobAppReturnCode
		{
			OdataType = "microsoft.graph.win32LobAppReturnCode",
			ReturnCode = 10,
			Type = Win32LobAppReturnCodeType.Success,
		},
	},
	MsiInformation = new Win32LobAppMsiInformation
	{
		OdataType = "microsoft.graph.win32LobAppMsiInformation",
		ProductCode = "Product Code value",
		ProductVersion = "Product Version value",
		UpgradeCode = "Upgrade Code value",
		RequiresReboot = true,
		PackageType = Win32LobAppMsiPackageType.PerUser,
		ProductName = "Product Name value",
		Publisher = "Publisher value",
	},
	SetupFilePath = "Setup File Path value",
	MinimumSupportedWindowsRelease = "Minimum Supported Windows Release value",
};