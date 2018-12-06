# Test file for the Vester module - https://github.com/WahlNetwork/Vester
# Called via Invoke-Pester VesterTemplate.Tests.ps1

# Test title, e.g. 'DNS Servers'
$Title = 'DRS Power Management enabled'

# Test description: How New-VesterConfig explains this value to the user
$Description = 'Enable Power Management DPM'
# The valid values are: boolean

# The config entry stating the desired values
$Desired = $cfg.cluster.drsDpmEnable

# The test value's data type, to help with conversion: bool/string/int
$Type = 'bool'

# The command(s) to pull the actual value for comparison
# $Object will scope to the folder this test is in (Cluster, Host, etc.)
[ScriptBlock]$Actual = {
    ($Object | Get-View).Configurationex.DpmConfigInfo.Enabled
}

# The command(s) to match the environment to the config
# Use $Object to help filter, and $Desired to set the correct value
[ScriptBlock]$Fix = {
    $clusterview = Get-Cluster -Name $Object | Get-View
    $clusterspec = New-Object -TypeName VMware.Vim.ClusterConfigSpecEx
    $clusterspec.DpmConfig = New-Object -TypeName VMware.Vim.ClusterDpmConfigInfo
    $clusterspec.DpmConfig.Enabled = $Desired
    $clusterview.ReconfigureComputeResource_Task($clusterspec, $true)    
}
