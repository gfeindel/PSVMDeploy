<#
 Configuration file for PSVMDeploy. This file
 defines your VMware environment.
#>

@{
    # General settings
    CustomizationSpec = ''

    # Profiles. These define standard VMware configurations.
    # A profile defines four properties:
    # NumCpu    The number of virtual cores. Prefers multi-core CPU to multiple CPUs.
    # MemoryGB  Gigabytes of memory.
    # OSDiskGB  Gigabytes of space for the OS disk.
    # DataDisks Array of sizes for data disks. A size of zero means "no disk."
    Profiles = @{
        'B1' = @{
            NumCpu = 1
            MemoryGB = 4
            OSDiskGB = 40
            DataDisks = @(0)
        }
        'B2' = @{
            NumCpu = 1
            MemoryGB = 4
            OSDiskGB = 40
            DataDisks = @(50)
        }
        'B3' = @{
            NumCpu = 1
            MemoryGB = 4
            OSDiskGB = 40
            DataDisks = @(100)    
        }
    }
    # Site-specific settings
    # For each of your sites, create a hashtable
    # that describes the following information:
    # Site = @{
    #   TemplateName = 'VM Template Name'
    #   DatastoreName = 'Datastore name'
    #   HostName = 'ESX host name'
    #   DefaultGateway = 'Default Gateway IP'
    #   NetworkMask = '255.255.255.0'
    # }
    XYZ = @{
        TemplateName = 'Windows 2012 Std R2'
        DatacenterName = 'XYZ'
        DatastoreName = '' # If blank, will auto select.
        VMName = '' # If blank, will auto select.
        DnsServers = '192.168.0.2','192.168.0.3'
        DefaultGateway = '192.168.0.1'
        SubnetMask = '255.255.255.0'
        OUPath = 'OU=Servers,OU=IT,DC=contoso,DC=com'
    }
}