$here = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace '\\Tests', ''
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

$myConfig = Import-PowerShellDataFile -Path "$here\configuration.psd1"

Import-Module \\jfvfs1\it$\scripts\modules\FMServer -Force
Import-Module VMware.VimAutomation.Core

Describe "Invoke-VMDeployment" {

    It "Given a site, creates a VM using appropriate parameters" {
        Mock -CommandName New-VM -MockWith {}
        Invoke-VMDeployment -SiteName JFV
    }
    Context "Manually specified hostname" {
        mock -CommandName "New-VM" -MockWith {}

        It "Given a hostname, creates a VM with that name" {
            Invoke-VMDeployment -Name TEST -SiteName JFV
            Assert-MockCalled -CommandName New-VM -ParameterFilter {$Name -eq 'TEST'}
        }
    }

    Context "Automatic hostname" {
        Mock -CommandName "New-VM" -MockWith {}
        Mock -CommandName "New-FMServerName" -MockWith {}
        It "Calls New-FMServerName to generate a hostname" {
            Assert-MockCalled -CommandName "New-FMServerName"
        }
    }
}
