function Find-PSGModule {
    <#
    .SYNOPSIS
        A wrapper for Invoke-RestMethod to search the PowerShell Gallery
    .FUNCTIONALITY
        PowerShell Gallery
    .DESCRIPTION
        A wrapper for Invoke-RestMethod to search the PowerShell Gallery
        In order to support wildcards, we build pretty complicated URLs, 
        and then we filter the results by title.
    .PARAMETER Name
        The module name (supports the * wildcard)
    .EXAMPLE
        Find-PSGModule -Name LocalPSRepository
    .LINK
        https://github.com/russellds/LocalPSRepository
    .LINK
        https://gist.github.com/Jaykul/9a810bac8584dd654cf9b0cffe6426eb
    #>
    [CmdletBinding()]
    param (
        [string]
        $Name
    )
    # We can support wildcards by splitting, searching for each piece, and then filtering the results
    # Build a URL using substringof
    $filter = @($Name.Trim('*').Split('*') | ForEach { "substringof('$_',Id)" }) -join " and "
    $url = "https://www.powershellgallery.com/api/v2/Packages?`$filter=$filter and IsLatestVersion"  

    # Fetch results and filter them with -like, and then shape the output
    Invoke-RestMethod $url | Where { $_.title.'#text' -like $Name } |
    Select-Object @{n='Name';ex={$_.title.'#text'}},
                  @{n='Version';ex={$_.properties.version}},
                  @{n='Url';ex={$_.Content.src}}
}
