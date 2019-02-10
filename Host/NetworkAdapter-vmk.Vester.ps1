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
[ScriptBlock]$Actual = {
    $var = "Name;PortGroupName;VMotionEnabled;FaultToleranceLoggingEnabled;ManagementTrafficEnabled;IPv6Enabled;Mtu;VsanTrafficEnabled;DhcpEnabled"
    $Var # Returns value
    $Object | Get-VMHostNetworkAdapter | Where-Object { $_.Name -like "vmk*" } | ForEach-Object {
        # [0] = Name
        # [1] = PortGroupName
        # [2] = VMotionEnabled
        # [3] = FaultToleranceLoggingEnabled
        # [4] = ManagementTrafficEnabled
        # [5] = IPv6Enabled # Note: If IPV6 is Disabled, it returns a blanc insteadd of False! 
        # [6] = Mtu
        # [7] = VsanTrafficEnabled
        # [8] = DhcpEnabled
        # Next line, cutoff PortGroupname for VXLAN portgroups (different per ESXi host)
        $PortGroupName = $_.PortGroupName
        if ($PortGroupName -like "vxw-vmknicPg-dvs*") { 
            $PortGroupName = $PortGroupName.Substring(0,16) 
        }
        $Var = $_.Name+";"+$PortGroupName+";"+$_.VMotionEnabled+";"+
        $_.FaultToleranceLoggingEnabled+";"+$_.ManagementTrafficEnabled+";"+
        $_.IPv6Enabled+";"+$_.Mtu+";"+$_.VsanTrafficEnabled+";"+$_.DhcpEnabled
        $Var    # Returns value
    }
}

# The command(s) to match the environment to the config
# Use $Object to help filter, and $Desired to set the correct value
[ScriptBlock]$Fix = {
    Compare-Object $Desired (& $Actual) |
    Where-Object { $_.SideIndicator -eq "<=" } | 
    ForEach-Object {
        $Params = @{
            'VMotionEnabled'                = [System.Convert]::ToBoolean($_.InputObject.split(";")[2])
            'FaultToleranceLoggingEnabled'  = [System.Convert]::ToBoolean($_.InputObject.split(";")[3])
            'ManagementTrafficEnabled'      = [System.Convert]::ToBoolean($_.InputObject.split(";")[4])
            'Mtu'                           = $_.InputObject.split(";")[6]
            'VsanTrafficEnabled'            = [System.Convert]::ToBoolean($_.InputObject.split(";")[7])
            'Dhcp'                          = [System.Convert]::ToBoolean($_.InputObject.split(";")[8])
        }
        Get-VMHostNetworkAdapter -Name ($_.InputObject.split(";")[0]) |
        Set-VMHostNetworkAdapter @Params -Confirm:$false -ErrorAction Stop
    }
}
# Need to convert String value to booean to set most of the parameters: [System.Convert]::ToBoolean($SomeVar) 