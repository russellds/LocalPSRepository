function Get-NextNugetPackageCalendarVersion {
    <#
    .SYNOPSIS
        Get the next version for a nuget package, such as a module or script in the PowerShell Gallery
    .FUNCTIONALITY
        CI/CD
    .DESCRIPTION
        Get the next version for a nuget package, such as a module or script in the PowerShell Gallery
        Uses the versioning scheme adopted by the user
        Where possible, users should stick to semver: http://semver.org/ (Major.Minor.Patch, given restrictions .NET Version class)
        
        If no existing module is found, we return 0.0.1
    .PARAMETER Name
        Name of the nuget package
    .PARAMETER PackageSourceUrl
        Nuget PackageSourceUrl to query.
            PSGallery Module URL: https://www.powershellgallery.com/api/v2/ (default)
            PSGallery Script URL: https://www.powershellgallery.com/api/v2/items/psscript/
    .EXAMPLE
        Get-NextNugetPackageVersion PSDeploy
    .EXAMPLE
        Get-NextNugetPackageVersion Open-ISEFunction -PackageSourceUrl https://www.powershellgallery.com/api/v2/items/psscript/
    .LINK
        https://github.com/RamblingCookieMonster/BuildHelpers
    .LINK
        about_BuildHelpers
    #>
    [cmdletbinding()]
    param(
        [parameter(ValueFromPipelineByPropertyName=$True)]
        [string[]]$Name,

        [string]$PackageSourceUrl = 'https://www.powershellgallery.com/api/v2/'
    )
    Begin {
        [int]$year = Get-Date -Format yy
        [int]$month = (Get-Date).Month
    }
    Process
    {
        foreach($Item in $Name)
        {
            Try
            {
                $Existing = $null
                $Existing = Find-NugetPackage -Name $Item -PackageSourceUrl $PackageSourceUrl -IsLatest -ErrorAction Stop
            }
            Catch
            {
                if($_ -match "No match was found for the specified search criteria")
                {
                    New-Object System.Version ($year,$month,0)
                }
                else
                {
                    Write-Error $_
                }
                continue
            }

            if($Existing.count -gt 1)
            {
                Write-Error "Found more than one $Type matching '$Item': Did you use a wildcard?"
                continue
            }
            elseif($Existing.count -eq 0)
            {
                Write-Verbose "Found no $Type matching '$Item'"
                New-Object System.Version ($year,$month,0)
                continue
            }
            else
            {
                $Version = [System.Version]$Existing.Version
            }

            if($Version.Major -ne $year)
            {
                New-Object System.Version ($year,$month,0)
            }
            elseif($Version.Minor -ne $month)
            {
                New-Object System.Version ($year,$month,0)
            }
            else
            {
                $build = $Version.Build + 1
                New-Object System.Version ($year,$month,$build)
            }
        }
    }
}