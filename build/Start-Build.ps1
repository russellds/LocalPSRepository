param(
    [string]
    $Task = 'Default',
    [switch]
    $Local,
    [switch]
    $Force
)

$Environment = Get-Item ENV: | where { $_.Name -like "APPVEYOR*" -or $_.Name -eq 'NugetApiKey' }
foreach( $env in $Environment) { Write-Host "`$env:$($env.Name) = '$($env.Value)'" }

# dependencies
Get-PackageProvider -Name NuGet -ForceBootstrap | Out-Null
if(-not (Get-Module -ListAvailable PSDepend))
{
    & (Resolve-Path "$PSScriptRoot\helpers\Install-PSDepend.ps1")
}
Import-Module PSDepend
$null = Invoke-PSDepend -Path "$PSScriptRoot\build.requirements.psd1" -Install -Import -Force

Set-BuildEnvironment -Force:$Force

if ($Local) {
    $env:BHBuildSystem = 'Local'
}

Invoke-psake $PSScriptRoot\psake.ps1 -taskList $Task -nologo
exit ( [int]( -not $psake.build_success ) )