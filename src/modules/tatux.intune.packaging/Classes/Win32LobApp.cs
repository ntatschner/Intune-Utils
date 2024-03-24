using System.Collections.Generic;
using System;
using System.IO;
using System.Text.Json;
using System.Text.Json.Serialization;

namespace Tatux.Intune.Packaging
{
	public enum MobileAppPublishingState
	{
		NotPublished,
		Processing,
		Published,
	}
	public enum WindowsArchitecture
	{
		None,
		X86,
		X64,
		Arm,
		Neutral,
	}
	public enum Win32LobAppRuleType
	{
		Requirement,
		Detection,
	}
	public enum RunAsAccountType
	{
		User,
		System,
	}
	public enum Win32LobAppRestartBehavior
	{
		Allow,
		Forced,
		NotAllowed,
	}
	public enum Win32LobAppReturnCodeType
	{
		Success,
		Failure,
	}
	public enum Win32LobAppMsiPackageType
	{
		PerMachine,
		PerUser,
	}
	public enum Win32LobAppRegistryRuleOperationType
	{
		Exists,
		DoesNotExist,
		String,
		Integer,
		Version,
	}
	public enum Win32LobAppRuleOperator
	{
		Equal,
		NotEqual,
		GreaterThan,
		GreaterThanOrEqual,
		LessThan,
		LessThanOrEqual,
		Contains,
		NotContains,
		BeginsWith,
		EndsWith,
		NotBeginsWith,
		NotEndsWith,
		NotContainsAll,
		NotContainsAny,
		NotContainsAllValues,
		NotContainsAnyValues,
		ContainsAll,
		ContainsAny,
		ContainsAllValues,
	}
    
	// Main Class
	public class Win32LobApp
    {
        public string OdataType { get; } = "#microsoft.graph.win32LobApp";
        public string DisplayName { get; set; }
        public string Description { get; set; } = string.Empty;
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

		private MimeContent GetIcon(string path)
		{
			if (System.IO.File.Exists(path))
			{
				var extension = System.IO.Path.GetExtension(path).ToLower();
				var _largeIconOutput = new MimeContent(
					"image/" + extension,
					Convert.ToBase64String(System.IO.File.ReadAllBytes(path))
				);
				return _largeIconOutput;
			} 
			else
			{
				throw new ArgumentException("File not found.");
			}
		}
		public string ToJson()
		{
			return JsonSerializer.Serialize(this);
		}
    }
	public struct MimeContent 
	{
		public string OdataType { get; } = "microsoft.graph.mimeContent";
		public string Type { get; set; } = "String";
		public string Value { get; set; }

		public MimeContent(string type, string value)
		{
			Type = type;
			Value = value;
		}
		public string ToJson()
		{
			return JsonSerializer.Serialize(this);
		}
	}
	public class Win32LobAppRule
	{
		public string OdataType { get; set; }
		public Win32LobAppRuleType RuleType { get; set; }
	}
	public class Win32LobAppRegistryRule : Win32LobAppRule
	{
		public bool Check32BitOn64System { get; set; }
		public string KeyPath { get; set; }
		public string ValueName { get; set; }
		public Win32LobAppRegistryRuleOperationType OperationType { get; set; }
		public Win32LobAppRuleOperator Operator { get; set; }
		public string ComparisonValue { get; set; }
	}
	public class Win32LobAppInstallExperience
	{
		public string OdataType { get; set; }
		public RunAsAccountType RunAsAccount { get; set; }
		public Win32LobAppRestartBehavior DeviceRestartBehavior { get; set; }
	}
	public class Win32LobAppReturnCode
	{
		public string OdataType { get; set; }
		public int ReturnCode { get; set; }
		public Win32LobAppReturnCodeType Type { get; set; }
	}
	public class Win32LobAppMsiInformation
	{
		public string OdataType { get; set; }
		public string ProductCode { get; set; }
		public string ProductVersion { get; set; }
		public string UpgradeCode { get; set; }
		public bool RequiresReboot { get; set; }
		public Win32LobAppMsiPackageType PackageType { get; set; }
		public string ProductName { get; set; }
		public string Publisher { get; set; }
	}
	
}