[![Build status](https://ci.appveyor.com/api/projects/status/ika23w7kvftx2pbl/branch/master?svg=true)](https://ci.appveyor.com/project/russellds/localpsrepository/branch/master) [![Stories in Ready](https://badge.waffle.io/russellds/LocalPSRepository.png?label=ready&title=Ready)](http://waffle.io/russellds/LocalPSRepository)

# LocalPSRepository

A module to simplify the creation of and working with Local PowerShell Repositories.

## Functionality

The module includes the following functions:

- *New-LocalPSRepository* - creates a local PowerShell Repository.
- *Find-PSGModule* - finds modules in the PowerShell Gallery. Primarily used to pipe input into Save-PSGModule
- *Save-PSGModule* - used to download a module from the PowerShell Gallery in NuGet form.

## Code & Inspiration

- [Powershell: Your first internal PSScript repository] (https://kevinmarquette.github.io/2017-05-30-Powershell-your-first-PSScript-repository/)
- [PowerShell Gallery Module - Light](https://gist.github.com/Jaykul/9a810bac8584dd654cf9b0cffe6426eb)
