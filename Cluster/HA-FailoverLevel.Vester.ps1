# Test file for the Vester module - https://github.com/WahlNetwork/Vester
# Called via Invoke-Pester VesterTemplate.Tests.ps1

# Test title, e.g. 'DNS Servers'
$Title = $Title = 'HA Failover level'

# Test description: How New-VesterConfig explains this value to the user
$Description = 'Specifies the the number [int] (1-4) of physical host failures that can be tolerated'

# The valid values are Disabled, Low, Medium, and High

# The config entry stating the desired values
$Desired = $cfg.cluster.hafailoverlevel

# The test value's data type, to help with conversion: bool/string/int
$Type = 'int'

# The command(s) to pull the actual value for comparison
# $Object will scope to the folder this test is in (Cluster, Host, etc.)
[ScriptBlock]$Actual = {
    $Object.HAFailoverLevel

}

# The command(s) to match the environment to the config
# Use $Object to help filter, and $Desired to set the correct value
[ScriptBlock]$Fix = {
    Set-Cluster -Cluster $Object -HAFailoverLevel:$Desired -Confirm:$false -ErrorAction Stop
}
