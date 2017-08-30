function New-LocalPSRepository {
    [CmdletBinding()]
    param(
        [string]$Name = 'Local',
        [string]$SourceLocation = $(Join-Path -Path $env:SystemDrive -ChildPath 'LocalPSRepository'),
        [string]$PublishLocation = $(Join-Path -Path $env:SystemDrive -ChildPath 'LocalPSRepository'),
        [string]$InstallationPolicy = 'Trusted'
    )

    if (-not (Test-Path -Path $SourceLocation)) {
        New-Item -Path $SourceLocation -ItemType Directory
    }

    if (-not (Test-Path -Path $PublishLocation)) {
        New-Item -Path $PublishLocation -ItemType Directory
    }

    $repository = @{
        Name = $Name
        SourceLocation = $SourceLocation
        PublishLocation = $PublishLocation
        InstallationPolicy = $InstallationPolicy
    }

    Register-PSRepository @repository

}