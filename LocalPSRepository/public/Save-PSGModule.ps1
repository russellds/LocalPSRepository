function Save-PSGModule {
    <#
    .SYNOPSIS
        A wrapper for Invoke-WebRequest -OutFile to save modules with the nuget package file names. 
    .FUNCTIONALITY
    PowerShell Gallery
    .DESCRIPTION
        A wrapper for Invoke-WebRequest -OutFile to save modules with the nuget package file names.
    .PARAMETER Url
        The Url to download from.
    .PARAMETER Name
        The name of the module (for naming the output file).
    .PARAMETER Version
        The version of the module (for naming the output file).
     .PARAMETER Destination
        The folder to save to.
    .EXAMPLE
        Find-PSGModule -Name LocalPSRepository | Save-PSGModule
    .LINK
        https://github.com/russellds/LocalPSRepository
    .LINK
        https://gist.github.com/Jaykul/9a810bac8584dd654cf9b0cffe6426eb
    #>
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipelineByPropertyName=$true, Mandatory=$true)]
        $Url,

        [Parameter(ValueFromPipelineByPropertyName=$true, Mandatory=$true)]
        $Name,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        $Version="",
        
        # The folder to save to
        [Alias("Path")]
        [string]$Destination = $pwd
    )
    process {
        if ($Destination -eq "CurrentUser") {
            $Destination = Join-Path ([Environment]::GetFolderPath("MyDocuments")) "WindowsPowerShell\Modules"
        }
        if ($Destination -eq "AllUsers" -or $Destination -eq "LocalMachine") {
            $Destination = Join-Path ([Environment]::GetFolderPath("ProgramFiles")) "WindowsPowerShell\Modules"
        }
        if (-not (Test-Path $Destination)) {
            $null = mkdir $Destination -force
        }
        $Path = Join-Path $Destination "$Name.$Version.nupkg"
        Invoke-WebRequest $Url -OutFile $Path
        Get-Item $Path
    }
}
