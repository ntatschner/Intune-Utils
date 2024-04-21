---
external help file: tatux.intune.packaging-help.xml
Module Name: tatux.intune.packaging
online version:
schema: 2.0.0
---

# New-IntuneApplication

## SYNOPSIS
Creates a new Intune Application Deployment, automatically generating the .intunewin file and optionally the JSON file, and optionally publishing it

## SYNTAX

```
New-IntuneApplication [-ApplicationName] <String> [-SourceFiles] <String[]> [-MainInstallerFileName] <String>
 [[-OutputFolder] <String>] [[-Description] <String>] [[-Publisher] <String>] [[-Version] <String>]
 [[-Developer] <String>] [[-owner] <String>] [[-notes] <String>] [[-LogoPath] <String>]
 [[-InstallFor] <String>] [[-RestartBehavior] <String>] [[-isFeatured] <Boolean>] [-InstallCommand] <String>
 [-UninstallCommand] <String> [[-RequirementRuleConfig] <Hashtable>] [-DetectionRuleConfig] <Hashtable>
 [-AssignmentType] <String> [[-AssignmentGroup] <String>] [[-FilterRuleType] <String>] [[-FilterRule] <String>]
 [-Publish] [[-IntuneToolsPath] <String>] [-Overwrite] [-NoJson] [-NoIntuneWin] [-NoCleanUp]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This PowerShell Advanced Function Creates a new Intune Application Deployment,
this can either generate the .intunewin file and a json file describing the application or
create the intunewin file and publish it directly to Intune.

## EXAMPLES

### EXAMPLE 1
```
New-IntuneApplication -ApplicationName "7-Zip" -Description "7-Zip is a file archiver with a high compression ratio." -Publisher "7-Zip" -Version "19.00" -Developer "Igor Pavlov" -InstallCommand "msiexec /i 7z1900-x64.msi /qn" -UninstallCommand "msiexec /x 7z1900-x64.msi /qn" -RequirementRuleType "Config" -RequirementRuleConfig "OS: Windows 10" -DetectionRuleType "MSI" -LogoPath "C:\Program Files\7-Zip\7zFM.exe" -AssignmentType "All-Devices" -IntuneWinPath "C:\Temp\7-Zip" -Publish
Creates a new Intune Application Deployment for 7-Zip, generates the .intunewin file, and publishes it to Intune.
```

## PARAMETERS

### -ApplicationName
The name of the application to be created.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AssignmentGroup
The group to assign the application to.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 19
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AssignmentType
The assignment type for the application.
Either User-Group, Device-Group, All-Users, All-Devices.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: User-Group, Device-Group, All-Users, All-Devices

Required: True
Position: 18
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
The description of the application.
You can either pass a Markdown formatted file or a string.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: "# $ApplicationName`nPublisher: $Publisher`nVersion: $Version`nDeveloper: $Developer`n`n$notes"
Accept pipeline input: False
Accept wildcard characters: False
```

### -DetectionRuleConfig
{{ Fill DetectionRuleConfig Description }}

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: True
Position: 17
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Developer
The developer of the application.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: $Env:USERNAME
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterRule
The filter rule for the application.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 21
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterRuleType
{{ Fill FilterRuleType Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: Include, Exclude

Required: False
Position: 20
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InstallCommand
The command to install the application.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 14
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InstallFor
{{ Fill InstallFor Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: User, System

Required: False
Position: 11
Default value: System
Accept pipeline input: False
Accept wildcard characters: False
```

### -IntuneToolsPath
The path to the IntuneWinAppUtil.exe tool.
If not specified the function will look for the tool in the current directory.
If not found the function will download the tool from the internet.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 22
Default value: .\IntuneWinAppUtil.exe
Accept pipeline input: False
Accept wildcard characters: False
```

### -isFeatured
{{ Fill isFeatured Description }}

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 13
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -LogoPath
The path to the image file for the application.
Needs to be a PNG or JPG with a max resolution of 256x256 pixels.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MainInstallerFileName
{{ Fill MainInstallerFileName Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NoCleanUp
Do not clean up the files after publishing.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -NoIntuneWin
Do not generate the .intunewin file.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -NoJson
Do not generate the JSON file.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -notes
{{ Fill notes Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OutputFolder
The folder to save the .intunewin file and JSON config, current directory by default.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: $($PWD.Path)
Accept pipeline input: False
Accept wildcard characters: False
```

### -Overwrite
Overwrite the .intunewin file and JSON if they already exists.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -owner
{{ Fill owner Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Publish
Publish the application directly to Intune.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Publisher
The publisher of the application.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: $Env:USERNAME
Accept pipeline input: False
Accept wildcard characters: False
```

### -RequirementRuleConfig
The requirement rule Config path for the application.
A string of parsable requirements.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 16
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RestartBehavior
{{ Fill RestartBehavior Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: basedOnReturnCode, allow, suppress, force

Required: False
Position: 12
Default value: BasedOnReturnCode
Accept pipeline input: False
Accept wildcard characters: False
```

### -SourceFiles
This can be a list of files or a directory.
If you specify a directory, the function will include all files in the directory and subdirectories.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UninstallCommand
The command to uninstall the application.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 15
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Version
The version of the application.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: 1.0
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Management.Automation.PSObject

## NOTES

## RELATED LINKS
