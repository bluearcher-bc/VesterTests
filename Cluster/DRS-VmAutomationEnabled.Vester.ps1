# Test file for the Vester module - https://github.com/WahlNetwork/Vester
# Called via Invoke-Pester VesterTemplate.Tests.ps1

# Test title, e.g. 'DNS Servers'
$Title = 'DRS Virtual machine Automation'

# Test description: How New-VesterConfig explains this value to the user
$Description = 'Enable individual virtual machine automation levels'
# The valid values are: True, False

# The config entry stating the desired values
$Desired = $cfg.cluster.drsvmautomation

# The test value's data type, to help with conversion: bool/string/int
$Type = 'bool'

# The command(s) to pull the actual value for comparison
# $Object will scope to the folder this test is in (Cluster, Host, etc.)
[ScriptBlock]$Actual = {
    ($Object | Get-View).Configuration.DrsConfig.EnableVmBehaviorOverrides
}

# The command(s) to match the environment to the config
# Use $Object to help filter, and $Desired to set the correct value
[ScriptBlock]$Fix = {
    $clusterview = Get-Cluster -Name $Object | Get-View
    $clusterspec = New-Object -TypeName VMware.Vim.ClusterConfigSpecEx
    $clusterspec.drsConfig = New-Object -TypeName VMware.Vim.ClusterDrsConfigInfo
    $clusterspec.drsConfig.EnableVmBehaviorOverrides = $Desired
    $clusterview.ReconfigureComputeResource_Task($clusterspec, $true)
}
