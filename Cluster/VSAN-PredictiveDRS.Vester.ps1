# Test file for the Vester module - https://github.com/WahlNetwork/Vester
# Called via Invoke-Pester VesterTemplate.Tests.ps1

# Test title, e.g. 'DNS Servers'
$Title = 'VSAN Predictive DRS'

# Test description: How New-VesterConfig explains this value to the user
$Description = 'Enable predictiveDRS on VSAN'
# The valid values are: boolean

# The config entry stating the desired values
$Desired = $cfg.cluster.vsanpredictivedrs

# The test value's data type, to help with conversion: bool/string/int
$Type = 'bool'

# The command(s) to pull the actual value for comparison
# $Object will scope to the folder this test is in (Cluster, Host, etc.)
[ScriptBlock]$Actual = {
    ($Object | Get-View).Configurationex.ProactiveDrsConfig
}

# The command(s) to match the environment to the config
# Use $Object to help filter, and $Desired to set the correct value
[ScriptBlock]$Fix = {
    $clusterview = Get-Cluster -Name $Object | Get-View
    $clusterspec = New-Object -TypeName VMware.Vim.ClusterConfigSpecEx
    $clusterspec.ProactiveDrsConfig = New-Object -TypeName VMware.Vim.ClusterProactiveDrsConfigInfo
    $clusterspec.ProactiveDrsConfig.Enabled = $Desired
    $clusterview.ReconfigureComputeResource_Task($clusterspec, $true)    
}
