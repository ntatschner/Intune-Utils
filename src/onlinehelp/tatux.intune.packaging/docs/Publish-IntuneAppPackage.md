---
external help file: tatux.intune.packaging-help.xml
Module Name: tatux.intune.packaging
online version:
schema: 2.0.0
---

# Publish-IntuneAppPackage

## SYNOPSIS
This function takes the .intunewin and configuration .json and publishes the application to Intune

## SYNTAX

```
Publish-IntuneAppPackage [-IntuneAppJSONPath] <String> [-IntuneWinPath] <String> [-Force] [-NoTenantDetails]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function takes the .intunewin and configuration .json and publishes the application to Intune.
If the application already exists in Intune, the function will update the application if the -Force switch is used.

## EXAMPLES

### EXAMPLE 1
```
Publish-IntuneAppPackage -IntuneAppJSONPath "C:\Temp\IntuneApp.json" -IntuneWinPath "C:\Temp\IntuneApp.intunewin"
```

This example will publish the application to Intune using the configuration in the JSON file and the .intunewin file.

## PARAMETERS

### -Force
If the application already exists in Intune, this switch will force the application to be updated.

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

### -IntuneAppJSONPath
The path to the JSON file that contains the Intune Application configuration

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

### -IntuneWinPath
The path to the .intunewin file.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NoTenantDetails
{{ Fill NoTenantDetails Description }}

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

### The function will output the Intune Application details that was created.
## NOTES

## RELATED LINKS
