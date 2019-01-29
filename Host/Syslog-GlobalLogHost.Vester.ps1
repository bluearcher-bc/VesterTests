# Test file for the Vester module - https://github.com/WahlNetwork/Vester
# Called via Invoke-Pester VesterTemplate.Tests.ps1

# Test title, e.g. 'DNS Servers'
$Title = 'Syslog.global.logHost'

# Test description: How New-VesterConfig explains this value to the user
$Description = 'The remote host to output logs to'
# The remote host to output logs to. Reset to default on null. 
# Multiple hosts are supprted an dmust be separated with comma (,).
# Example: udp://hostname:514, hostname2, ssl://hostname3:1514

# The config entry stating the desired values
$Desired = $cfg.host.SyslogGlobalLogHost

# The test value's data type, to help with conversion: bool/string/int
$Type = 'string'

# The command(s) to pull the actual value for comparison
# $Object will scope to the folder this test is in (Cluster, Host, etc.)
[ScriptBlock]$Actual = {
    (Get-AdvancedSetting -Entity $Object | Where-Object -FilterScript {
        $_.Name -eq 'Syslog.global.logHost'
    }).Value
}

# The command(s) to match the environment to the config
# Use $Object to help filter, and $Desired to set the correct value
[ScriptBlock]$Fix = {
    Get-AdvancedSetting -Entity $Object | Where-Object -FilterScript {
            $_.Name -eq 'Syslog.global.logHost'
        } | Set-AdvancedSetting -Value $Desired -Confirm:$false -ErrorAction Stop
}
