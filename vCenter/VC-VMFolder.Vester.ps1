# Test file for the Vester module - https://github.com/WahlNetwork/Vester
# Called via Invoke-Pester VesterTemplate.Tests.ps1

# Test title, e.g. 'DNS Servers'
$Title = 'VMFolder'

# Test description: How New-VesterConfig explains this value to the user
$Description = 'Checks Folder structure in VMs and Templates'

# The config entry stating the desired values
$Desired = $cfg.vcenter.VmFolder

# The test value's data type, to help with conversion: bool/string/int
$Type = 'string[]'

# The command(s) to pull the actual value for comparison
# $Object will scope to the folder this test is in (Cluster, Host, etc.)
[ScriptBlock]$Actual = {
    $array = Get-View -ViewType Folder | Where-Object { $_.childtype -like "VirtualMachine"} | select Name,Moref,Parent
    $array | ForEach-Object {
        $myout = ""
        $folder =$_.Name
        $parent = $_.Parent
        while ($folder -ne "vm" -and $parent -notlike "Datacenter-datacenter*") {
            $myout = $myout+"/"+$folder
            $folder = ($array | Where-Object { $_.Moref -eq $parent}).Name
            $parent = ($array | Where-Object { $_.Moref -eq $parent}).Parent
        }
        $myout
    }
}

# The command(s) to match the environment to the config
# Use $Object to help filter, and $Desired to set the correct value
[ScriptBlock]$Fix = {
    Write-Host "VM folders has changed"
}
