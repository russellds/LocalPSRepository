function New-LocalPSRepository {
    <#
    .SYNOPSIS
        Creates a new local Powershell Repository
    .FUNCTIONALITY
        PowerShell Repository
    .DESCRIPTION
        Creates a new local Powershell Repository
    .PARAMETER Name
        Name of the local Powershell Repository. 
        Default: Local
    .PARAMETER SourceLocation
        Specifies the Path for discovering and installing modules from this repository.
        Should be either a network share or a directory on the local computer.
        Default: $env:SystemDrive\LocalPSRepository
    .PARAMETER PublishLocation
        Specifies the Path of the publish location. Should be the same as SourceLocation
        Default: $env:SystemDrive\LocalPSRepository
    .PARAMETER InstallationPolicy
        Specifies the installation policy. Valid values are: Trusted, UnTrusted. 
        A repository's installation policy specifies PowerShell behavior when installing from that repository. When installing modules from an UnTrusted repository, the user is prompted for confirmation.
        You can set the InstallationPolicy with the Set-PSRepository cmdlet.
        Default: Trusted
    .EXAMPLE
        New-LocalPSRepository
    .EXAMPLE
        New-LocalPSRepository -Name LocalRepo
    .LINK
        https://github.com/russellds/LocalPSRepository
    #>
    [CmdletBinding()]
    param(
        [string]
        $Name = 'Local',

        [string]
        $SourceLocation = $(Join-Path -Path $env:SystemDrive -ChildPath 'LocalPSRepository'),

        [string]
        $PublishLocation = $(Join-Path -Path $env:SystemDrive -ChildPath 'LocalPSRepository'),
        
        [ValidateSet('Trusted', 'UnTrusted')]
        [string]
        $InstallationPolicy = 'Trusted'
    )

    if (-not (Test-Path -Path $SourceLocation)) {
        [void](New-Item -Path $SourceLocation -ItemType Directory)
    }

    if (-not (Test-Path -Path $PublishLocation)) {
        [void](New-Item -Path $PublishLocation -ItemType Directory)
    }

    $repository = @{
        Name = $Name
        SourceLocation = $SourceLocation
        PublishLocation = $PublishLocation
        InstallationPolicy = $InstallationPolicy
    }

    Register-PSRepository @repository

    Get-PSRepository
}