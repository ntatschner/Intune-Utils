---
slug: /
---

### Welcome To the Intune Utilities Documentation


I've created some PowerShell modules to help with managing your Intune Application deployments, Device configuration, and perform reporting.

I intend to expand the functions as I go and will try to keep things as up to date as possible. All the code here is published to the PSGallery, and I've set up Updatable Help and Online versions of the help files for ease of use.


To install these modules follow the standard Powershell Module installation commands. See below:
```PowerShell
Install-PSResource -Repository PSGallery -Name MODULENAME -Scope AllUsers
```
Or to reinstall
```PowerShell
Install-PSResource -Repository PSGallery -Name MODULENAME -Scope AllUsers -ReInstall
```
For more information on how to install PowerShell modules, you can visit the [Install-PSResource](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.psresourceget/install-psresource?view=powershellget-3.x) webpage.