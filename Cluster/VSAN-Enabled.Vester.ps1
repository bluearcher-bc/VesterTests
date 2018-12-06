# Test file for the Vester module - https://github.com/WahlNetwork/Vester
# Called via Invoke-Pester VesterTemplate.Tests.ps1

# Test title, e.g. 'DNS Servers'
$Title = 'VSAN State'

# Test description: How New-VesterConfig explains this value to the user
$Description = 'Specifies whether the Virtual SAN feature is enabled'
# The valid values are: True, False

# The config entry stating the desired values
$Desired = $cfg.cluster.vsanenable

# The test value's data type, to help with conversion: bool/string/int
$Type = 'bool'

# The command(s) to pull the actual value for comparison
# $Object will scope to the folder this test is in (Cluster, Host, etc.)
[ScriptBlock]$Actual = {
    $Object.VsanEnabled
}

# The command(s) to match the environment to the config
# Use $Object to help filter, and $Desired to set the correct value
[ScriptBlock]$Fix = {
    Set-Cluster -Cluster $Object -VsanEnabled:$Desired -Confirm:$false -ErrorAction Stop
}
