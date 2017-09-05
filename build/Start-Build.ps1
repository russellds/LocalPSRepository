param(
    [string]
    $Task = 'Default',
    [switch]
    $Local,
    [switch]
    $Force
)

$Environment = Get-Item ENV:
foreach ($env in $Environment) { 
    if ($env.Name -like "APPVEYOR*") {
        Write-Host "`$env:$($env.Name) = '$($env.Value)'"
    }
    elseif ($env.Name -eq 'NugetApiKey') {
        Write-Host "`$env:$($env.Name) = '$($env.Value)'"
    }
} 

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