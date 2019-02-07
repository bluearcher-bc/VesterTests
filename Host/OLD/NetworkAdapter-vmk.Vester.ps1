# Test file for the Vester module - https://github.com/WahlNetwork/Vester
# Called via Invoke-Pester VesterTemplate.Tests.ps1

# Test title, e.g. 'DNS Servers'
$Title = 'Network adapter Virtual settings (vmk)'

# Test description: How New-VesterConfig explains this value to the user
$Description = 'Specifies the virtual network adapter settings'

# The config entry stating the desired values
$Desired = $cfg.host.vmk

# The test value's data type, to help with conversion: bool/string/int
$Type = 'string[]'

# The command(s) to pull the actual value for comparison
# $Object will scope to the folder this test is in (Cluster, Host, etc.)
# $i = 0
[ScriptBlock]$Actual = {
    $i = 0    # First element $i 0
    $Object | Get-VMHostNetworkAdapter | Where-Object { $_.Name -like "vmk*" } | ForEach-Object {
        # [0] = Index, variable $i
        # [1] = Name
        # [2] = PortGroupName
        # [3] = VMotionEnabled
        # [4] = FaultToleranceLoggingEnabled
        # [5] = ManagementTrafficEnabled
        # [6] = IPv6Enabled
        # [7] = Mtu
        # [8] = VsanTrafficEnabled
        # [9] = DhcpEnabled
        # $var = one portgroup with all properties 
        $var = $i.ToString()+";"+$_.Name+";"+$_.PortGroupName+";"+$_.VMotionEnabled+";"+$_.FaultToleranceLoggingEnabled+";"+$_.ManagementTrafficEnabled+";"+$_.IPv6Enabled+";"+$_.Mtu+";"+$_.VsanTrafficEnabled+";"+$_.DhcpEnabled
        $i ++
        $Var    # Returns value
    }
}

# The command(s) to match the environment to the config
# Use $Object to help filter, and $Desired to set the correct value
[ScriptBlock]$Fix = {
#    $i = 0
#    ($Object | Get-VDPortgroup) | ForEach-Object {
#        $var = $i.ToString()+";"+$_.Name+";"+$_.VlanConfiguration
#        if ($var -ne $Desired[$i]){
#            Set-VDVlanConfiguration -VDPortgroup $Desired[$i].split(";")[1] -VlanId $Desired[$i].split(";")[2].Substring(5)
#            #Write-Host "Change row: "$i
#        }
#        $i ++
#    }
     Write-Host "Work in progress"
}