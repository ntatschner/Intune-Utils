---
external help file: tatux.intune.packaging-help.xml
Module Name: tatux.intune.packaging
online version:
schema: 2.0.0
---

# New-Win32InstallExperience

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

```
New-Win32InstallExperience [[-maxRunTimeInMinutes] <String>] [[-restartBehavior] <String>]
 [[-runAsAccount] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
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

### -maxRunTimeInMinutes
{{ Fill maxRunTimeInMinutes Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases: InstallTimeInMinutes

Required: False
Position: 0
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

### -restartBehavior
{{ Fill restartBehavior Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: basedOnReturnCode, never, always, prompt, suppress

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -runAsAccount
{{ Fill runAsAccount Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases: InstallFor
Accepted values: system, sser

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Collections.Hashtable

## NOTES

## RELATED LINKS
