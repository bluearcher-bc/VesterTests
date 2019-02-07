# Test file for the Vester module - https://github.com/WahlNetwork/Vester
# Called via Invoke-Pester VesterTemplate.Tests.ps1

# Test title, e.g. 'DNS Servers'
$Title = 'DRS VM Distribution - TryBalanceVmsPerHost'

# Test description: How New-VesterConfig explains this value to the user
$Description = 'For availability, distribute a more even number of VMs across hosts'
# The valid values are: [int] 1
# A value of "1", means VM Distribution is enabled
# A value of "-1", means the option is not enabled, the variable does not exist.

# The config entry stating the desired values
$Desired = $cfg.cluster.drsvmdistribution

# The test value's data type, to help with conversion: bool/string/int
$Type = 'int'

# The command(s) to pull the actual value for comparison
# $Object will scope to the folder this test is in (Cluster, Host, etc.)
[ScriptBlock]$Actual = {
    if (Get-AdvancedSetting -Entity $object -Name TryBalanceVmsPerHost) {
        (Get-AdvancedSetting -Entity $object -Name TryBalanceVmsPerHost).Value
    }
    else {
        -1
    }
}

# The command(s) to match the environment to the config
# Use $Object to help filter, and $Desired to set the correct value
[ScriptBlock]$Fix = {
    if ($Desired -eq "-1") {
        Get-AdvancedSetting -Entity $object -Name TryBalanceVmsPerHost | Remove-AdvancedSetting -Confirm:$false -ErrorAction Stop
    } 
    else {
        $Object | New-AdvancedSetting -Name TryBalanceVmsPerHost -Value $Desired -Type ClusterDRS -Force -Confirm:$false -ErrorAction Stop
    }
}
