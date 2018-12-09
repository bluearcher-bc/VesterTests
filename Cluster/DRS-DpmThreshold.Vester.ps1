# Test file for the Vester module - https://github.com/WahlNetwork/Vester
# Called via Invoke-Pester VesterTemplate.Tests.ps1

# Test title, e.g. 'DNS Servers'
$Title = 'DRS Power Management Threshold'

# Test description: How New-VesterConfig explains this value to the user
$Description = 'Set Threshold for Power Management DPM'
# The valid values are: 1 - 5
# 1 = Agressive, 5 = Conservative (differs from values in vSphere Client!)
# Imporatent, this setting is only relevant when DPM is enabled, see DRS-DpmEnabled,
# otherwise stick to the default value.

# The config entry stating the desired values
$Desired = $cfg.cluster.drsDpmThreshold

# The test value's data type, to help with conversion: bool/string/int
$Type = 'int'

# The command(s) to pull the actual value for comparison
# $Object will scope to the folder this test is in (Cluster, Host, etc.)
[ScriptBlock]$Actual = {
    if (($Object | Get-View).Configurationex.DpmConfigInfo.Enabled -eq "True") {
        ($Object | Get-View).Configurationex.DpmConfigInfo.HostPowerActionRate
    }
    else { 3 } 
}

# The command(s) to match the environment to the config
# Use $Object to help filter, and $Desired to set the correct value
[ScriptBlock]$Fix = {
if (($Object | Get-View).Configurationex.DpmConfigInfo.Enabled -eq "True") {
        $clusterview = Get-Cluster -Name $Object | Get-View
        $clusterspec = New-Object -TypeName VMware.Vim.ClusterConfigSpecEx
        $clusterspec.DpmConfig = New-Object -TypeName VMware.Vim.ClusterDpmConfigInfo
        $clusterspec.DpmConfig.HostPowerActionRate = $Desired
        $clusterview.ReconfigureComputeResource_Task($clusterspec, $true)
    }
    else { 3 }
}