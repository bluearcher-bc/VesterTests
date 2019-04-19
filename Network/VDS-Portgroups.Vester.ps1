# Test file for the Vester module - https://github.com/WahlNetwork/Vester
# Called via Invoke-Pester VesterTemplate.Tests.ps1

# Test title, e.g. 'DNS Servers'
$Title = 'VDS Portgroup settings'

# Test description: How New-VesterConfig explains this value to the user
$Description = 'Specifies the VDS portgroups'

# The config entry stating the desired values
$Desired = $cfg.vds.portgroupsettings

# The test value's data type, to help with conversion: bool/string/int
$Type = 'string[]'

# The command(s) to pull the actual value for comparison
# $Object will scope to the folder this test is in (Cluster, Host, etc.)
[ScriptBlock]$Actual = {
    # Filter out the uplinks as names differ
    ($Object | Get-VDPortgroup | Where-Object { $_.IsUplink -eq $False } ) | ForEach-Object {
        # [0] = Name of portgroup
        # [1] = VlanConfiguration
        ($_.Name+";"+$_.VlanConfiguration)
    }
}

# The command(s) to match the environment to the config
# Use $Object to help filter, and $Desired to set the correct value
[ScriptBlock]$Fix = {
    Compare-Object $Desired (& $Actual) |
    Where-Object { $_.SideIndicator -eq "<=" } | 
    ForEach-Object {
        Set-VDVlanConfiguration -VDPortgroup ($_.InputObject.split(";")[0]) -VlanId ($_.InputObject.split(";")[1]).Substring(5) # Skip first 5 positions, text "VLAN "
    }
}
