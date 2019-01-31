# Test file for the Vester module - https://github.com/WahlNetwork/Vester
# Called via Invoke-Pester VesterTemplate.Tests.ps1
# Host Kernel Setting iovDisableIR - https://kb.vmware.com/kb/1030265 and https://virtuallyjason.blogspot.com/2017/02/psods-and-iovdisableir-setting.html

# Test title, e.g. 'DNS Servers'
$Title = 'Software Vib list'

# Test description: How New-VesterConfig explains this value to the user
$Description = 'Shows VIBs installed on host'

# The config entry stating the desired values
$Desired = $cfg.host.softwareviblist

# The test value's data type, to help with conversion: bool/string/int
$Type = 'string[]'

# The command(s) to pull the actual value for comparison
# $Object will scope to the folder this test is in (Cluster, Host, etc.)
#[ScriptBlock]$Actual = {
#    (Get-EsxCli -VMHost $Object -v2).software.vib.list.invoke() | ForEach-Object {
#        $var = $_.Name+","+$_.Version
#        $Var    # Returns value
#    }
#}
[ScriptBlock]$Actual = {
    (Get-EsxCli -VMHost $Object -v2).software.vib.list.invoke() | ForEach-Object {
        $_.Name+"   "+$_.Version
    }
}

# The command(s) to match the environment to the config
# Use $Object to help filter, and $Desired to set the correct value
[ScriptBlock]$Fix = {
    Write-Host "VIBs have changed"
}
