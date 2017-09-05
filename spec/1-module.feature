Feature: PowerShell Module
    As a PowerShell Module Author
    The module should be valid PowerShell

Scenario: The module should be valid PowerShell
    Given we have script files
    Then the script files should be valid Powershell
    And the module should import cleanly