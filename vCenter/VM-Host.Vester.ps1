# Test file for the Vester module - https://github.com/WahlNetwork/Vester
# Called via Invoke-Pester VesterTemplate.Tests.ps1

# Test title, e.g. 'DNS Servers'
$Title = 'VM Placement'

# Test description: How New-VesterConfig explains this value to the user
$Description = ''

# The config entry stating the desired values
$Desired = $cfg.vcenter.vmplacement

# The test value's data type, to help with conversion: bool/string/int
$Type = 'string[]'

# The command(s) to pull the actual value for comparison
# $Object will scope to the folder this test is in (Cluster, Host, etc.)
#
# $lines contains the "pre-set"values for VM placement,
# format: "virtual machine name";"ESXi host name"
# Each line ends with a comma, exce[pt the last line.
# After running New-VesterConfig, the resulting Config.json can be edited.
$lines = (
"VM01;esx01.virtual.local",
"LinkedVM;esx01.virtual.local"
)
[ScriptBlock]$Actual = {
    if (!$Desired) {
        Foreach ($line in $lines){
            ($line)
        }
    }
    else {
        Foreach ($line in $lines){
            ($line.split(";")[0]+";"+(Get-VM -Name ($line.split(";")[0])).VMhost.Name)
        }

    }
}

# The command(s) to match the environment to the config
# Use $Object to help filter, and $Desired to set the correct value
[ScriptBlock]$Fix = {
    Write-Host "To be fixed, vMotion...."
}
