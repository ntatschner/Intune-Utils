---
external help file: tatux.intune.packaging-help.xml
Module Name: tatux.intune.packaging
online version: https://pwsh.dev.tatux.co.uk/pages/tatux.intune.packaging/docs/New-APFDeployment.html
schema: 2.0.0
---

# New-APFDeployment

## SYNOPSIS
Creates a new APF deployment.

## SYNTAX

```
New-APFDeployment [-Name <String>] [-Version <Version>] [-Target <String>] [-InstallSwitches <String>]
 [-UninstallSwitches <String>] [-UninstallPath <String>] -Path <Object> [-IncludedFiles <String[]>]
 [-DestinationFolder <String>] [-CreateIntuneWinPackage] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The New-APFDeployment function creates a new APF deployment based on the provided parameters.

## EXAMPLES

### EXAMPLE 1
```
New-APFDeployment -Name "MyApp" -Version 1.0.0.0 -Path "C:\Installers\MyApp.msi" -DestinationFolder "C:\Deployments\MyApp"
```

This example creates a new APF deployment for an application named "MyApp" with version 1.0.0.0.
The installer file is located at "C:\Installers\MyApp.msi", and the deployment files will be copied to "C:\Deployments\MyApp".

## PARAMETERS

### -Name
The name of the application.
This is written into the exported configuration files. 
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

### -Version
The version of the application.
This is written into the exported configuration files. 
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

### -Target
The target for the deployment, User context or System context.
Default is 'system'.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: System
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

### -Path
The path to the installer file.
This should be a .msi or .exe file.
This parameter is mandatory.

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

### -DestinationFolder
The folder where the files will be copied to.
Default is the current directory.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: $PWD.Path
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
Default value: False
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

## OUTPUTS

## NOTES

## RELATED LINKS

## LINKS
https://pwsh.dev.tatux.co.uk/pages/tatux.intune.packaging/docs/New-APFDeployment.html
