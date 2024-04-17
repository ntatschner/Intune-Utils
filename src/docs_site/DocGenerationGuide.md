Install-Module Alt3.Docusaurus.Powershell
Install-Module PlatyPS

$parameters = @{
    Module = "tatux.intune.packaging"
    DocsFolder = "D:\Nerd Stuff\Dev Stuff\Git_Repos\Intune-Utils\src\docs_site\tatux-intune\docs\tatux.intune.packaging\docs"
    Sidebar = "docs"
    Exclude = @( )
    MetaDescription = 'Help page for the PowerShell command "%1"'
    MetaKeywords = @(
        "PowerShell"
        "Documentation"
    )
}

New-DocusaurusHelp @parameters