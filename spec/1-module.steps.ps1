Given 'we have script files' {
    $projectRoot = Resolve-Path "$PSScriptRoot\.."
    $moduleRoot = Split-Path (Resolve-Path "$projectRoot\*\*.psm1")
    $scripts = Get-ChildItem $moduleRoot -Include *.ps1,*.psm1,*.psd1 -Recurse
    $scripts | Should Exist
}

Then 'the script files should be valid Powershell' {
    foreach ($script in $scripts) {
        $contents = Get-Content -Path $script.FullName -ErrorAction Stop
        $errors = $null
        $null = [System.Management.Automation.PSParser]::Tokenize($contents, [ref]$errors)
        $errors.Count | Should Be 0
    }
}

And 'the module should import cleanly' {  
    $moduleName = Split-Path $moduleRoot -Leaf
    {Import-Module (Join-Path $moduleRoot "$moduleName.psm1") -force } | Should Not Throw
}