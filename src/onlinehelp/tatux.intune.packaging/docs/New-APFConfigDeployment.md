---
external help file: tatux.intune.packaging-help.xml
Module Name: tatux.intune.packaging
online version:
schema: 2.0.0
---

# New-APFConfigDeployment

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

```
New-APFConfigDeployment [-Name <String>] [-Version <Version>] [-Target <String>] [-ConfigurationType <String>]
 [-DestinationPath <String>] -Path <Object> [-IncludedFiles <String[]>] [-DestinationFolder <String>]
 [-CreateIntuneWinPackage] [-ProgressAction <ActionPreference>] [<CommonParameters>]
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

### -ConfigurationType
The type of configuration this command is for.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: Registry, Files, Script-OS, Script-App, Script-User, Custom

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

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

### -DestinationPath
Destination path for the files on the target system.

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

### -Name
The name of the application. 
This is written in to the exported configuration files. 
If you do not provide a name, the script will attempt to generate it.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
