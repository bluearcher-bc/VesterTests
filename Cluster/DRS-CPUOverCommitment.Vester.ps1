# Test file for the Vester module - https://github.com/WahlNetwork/Vester
# Called via Invoke-Pester VesterTemplate.Tests.ps1

# Test title, e.g. 'DNS Servers'
$Title = 'DRS CPU Over-Commitment'

# Test description: How New-VesterConfig explains this value to the user
$Description = 'CPU over-commitment ratio (% of cluster capacity)'
# The valid values are: [int] 0-500
# By enabling this option a Configuration option is created under Configuration parameters in vSphere Client
# A value of "-1", means the option is not enabled, the variable does not exist.

# The config entry stating the desired values
$Desired = $cfg.cluster.drscpuovercommitment

# The test value's data type, to help with conversion: bool/string/int
$Type = 'int'

# The command(s) to pull the actual value for comparison
# $Object will scope to the folder this test is in (Cluster, Host, etc.)
[ScriptBlock]$Actual = {
    if (Get-AdvancedSetting -Entity $object -Name MaxVcpusPerClusterPct) {
        (Get-AdvancedSetting -Entity $object -Name MaxVcpusPerClusterPct).Value
    }
    else {
        -1
    }
}

# The command(s) to match the environment to the config
# Use $Object to help filter, and $Desired to set the correct value
[ScriptBlock]$Fix = {
    if ($Desired -eq "-1") {
        Get-AdvancedSetting -Entity $object -Name MaxVcpusPerClusterPct | Remove-AdvancedSetting -Confirm:$false -ErrorAction Stop
    } 
    else {
        $Object | New-AdvancedSetting -Name MaxVcpusPerClusterPct -Value $Desired -Type ClusterDRS -Force -Confirm:$false -ErrorAction Stop
    }
}
