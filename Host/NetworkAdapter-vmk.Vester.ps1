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
    $Object | Get-VMHostNetworkAdapter | Where-Object { $_.Name -like "vmk*" } | ForEach-Object {
        # [0] = Name
        # [1] = PortGroupName
        # [2] = VMotionEnabled
        # [3] = FaultToleranceLoggingEnabled
        # [4] = ManagementTrafficEnabled
        # [5] = IPv6Enabled
        # [6] = Mtu
        # [7] = VsanTrafficEnabled
        # [8] = DhcpEnabled
        $var = $_.Name+";"+$_.PortGroupName+";"+$_.VMotionEnabled+";"+
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
        Get-VMHostNetworkAdapter -Name ($_.InputObject.split(";")[0]) |
        Set-VMHostNetworkAdapter -Mtu ($_.InputObject.split(";")[6])    -Confirm:$false -ErrorAction Stop
    Write-Host "Work in progress"
    }
}