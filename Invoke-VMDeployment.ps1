function Invoke-VMDeployment {
<#
.SYNOPSIS
Invokes the deployment of one or more virtual machines.

.DESCRIPTION
Long description

.PARAMETER SiteName
The name of the site where the VM should be deployed. This
must match a site in the configuration.

.PARAMETER Name
The name of the VM. If not specified, will generate automatically.

.PARAMETER MemoryGB
The memory of the VM, in GB.

.PARAMETER NumCpu
The number of virtual processors of the VM.

.PARAMETER DataDiskSizeGb
If specified, the size of the data disk of the VM.

.PARAMETER PowerOn
If specified, power on the VM after creation.

.EXAMPLE
Invoke-VMDeployment -SiteName JFV -Name JFVS0015 -MemoryGB 4 -NumCpu 4

.NOTES
Todo: Add ShouldProcess support.
Todo: Implement data disk support.
#>
    param(
        [parameter(Mandatory=$True)]
        [string]$SiteName,
        [string]$Name,
        [int]$MemoryGB = 2,
        [int]$NumCpu = 2,
        [int]$DataDiskSizeGb,
        [switch]$PowerOn = $false
    )

    $ConfigurationFilePath = '.\configuration.psd1'

    if(-not (Test-Path $ConfigurationFilePath)) {
        throw "Configuration file not found."
    }
    
    $configuration = Import-PowerShellDataFile -Path $ConfigurationFilePath

    $customSpec = New-OSCustomizationSpec @{
        Type = 'NonPersistent'
        OSCustomizationSpec = $configuration.CustomizationSpec
        Name = '_temp'
    }

    # Load data from configuration.
    $datacenter = Get-Datacenter $configuration[$Site].DatacenterName
    $template = Get-Template $configuration[$Site].TemplateName

    # Todo: Pick datastore with most free space, if not specified.
    $datastore = $datacenter | Get-Datastore -Name $configuration[$site].DatastoreName
    $vmhost = Get-VMHost $configuration[$Site].VMHost
    $customSpec.DnsServers = $configuration[$Site].DnsServers
    $customSpec.TimeZone = $configuration[$Site].TimeZone
    New-OSCustomizationNicMapping @{
        OSCustomizationSpec = $customSpec
        IpMode = 'UseStaticIp'
        SubnetMask = $configuration[$Site].SubnetMask
        IpAddress = $IpAddress
        DefaultGateway = $configuration[$Site].DefaultGateway
    }

    # Todo: Generate server name automatically if not specified.
    # if(Name not specified) { $Name = New-Hostname}
    try {
        $vm = New-VM @{
            Name = $Name
            Template = $template
            VMHost = $VMhost
            OSCustomizationSpec = $customSpec
            Datastore = $datastore
        }
        #Invoke customization and wait to finish
        if($PowerOn) {Start-VM -VM $vm}
    } catch {
        Write-Error "Failed to create new virtual machine $Name"
    }
    
}

#Export-ModuleMember Invoke-VMDeployment
