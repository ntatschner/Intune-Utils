---
external help file: tatux.intune.packaging-help.xml
Module Name: tatux.intune.packaging
online version:
schema: 2.0.0
---

# New-IntuneApplication

## SYNOPSIS
{{ Fill in the Synopsis }}

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
{{ Fill in the Description }}

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -ApplicationName
{{ Fill ApplicationName Description }}

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
{{ Fill AssignmentGroup Description }}

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
{{ Fill AssignmentType Description }}

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
{{ Fill Description Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
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
{{ Fill Developer Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterRule
{{ Fill FilterRule Description }}

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
{{ Fill InstallCommand Description }}

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
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IntuneToolsPath
{{ Fill IntuneToolsPath Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 22
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LogoPath
{{ Fill LogoPath Description }}

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
{{ Fill NoCleanUp Description }}

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

### -NoIntuneWin
{{ Fill NoIntuneWin Description }}

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

### -NoJson
{{ Fill NoJson Description }}

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

### -OutputFolder
{{ Fill OutputFolder Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Overwrite
{{ Fill Overwrite Description }}

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

### -Publish
{{ Fill Publish Description }}

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

### -Publisher
{{ Fill Publisher Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RequirementRuleConfig
{{ Fill RequirementRuleConfig Description }}

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
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SourceFiles
{{ Fill SourceFiles Description }}

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
{{ Fill UninstallCommand Description }}

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
{{ Fill Version Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
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
Default value: None
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Management.Automation.PSObject

## NOTES

## RELATED LINKS
