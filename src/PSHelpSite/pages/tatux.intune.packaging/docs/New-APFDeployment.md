---
external help file: tatux.intune.packaging-help.xml
Module Name: tatux.intune.packaging
online version:
schema: 2.0.0
---

# New-APFDeployment

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

```
New-APFDeployment [-Name <String>] [-Version <Version>] [-Target <String>] [-InstallSwitches <String>]
 [-UninstallSwitches <String>] [-UninstallPath <String>] -Path <Object> [-IncludedFiles <String[]>]
 [-DestinationFolder <String>] [-CreateIntuneWinPackage] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -CreateIntuneWinPackage
Create a Intune package for the application.
Default is false.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DestinationFolder
The folder where the files will be copied to.
Default is the current directory.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IncludedFiles
Paths to any additional files that need to be included in the installation.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InstallSwitches
The switches to use when installing the application.
Default is empty.
You'll have to manually edit the configuration file.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The name of the application. 
This is written in to the exported configuration files. 
If you do not provide a name, the script will attempt to extract it from the installer file.

```yaml
Type: String
Parameter Sets: (All)
Aliases: ApplicationName, AppName

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
{{ Fill Path Description }}

```yaml
Type: Object
Parameter Sets: (All)
Aliases: InstallerFile, SourceFile

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Target
The target for the deployment, User context or System context.
Default is 'system'.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: system, user

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UninstallPath
The path to the uninstall file.
Default is empty.
You'll have to manually edit the configuration file.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UninstallSwitches
The switches to use when uninstalling the application.
Default is empty.
You'll have to manually edit the configuration file.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Version
The version of the application. 
This is written in to the exported configuration files. 
This should be in the format of x.x.x.x. 
If you do not provide a version, the script will attempt to extract it from the installer file.

```yaml
Type: Version
Parameter Sets: (All)
Aliases: ApplicationVersion, AppVersion

Required: False
Position: Named
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS