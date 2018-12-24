#(Get-VDPortgroup -VDSwitch DSwitch01) | ForEach-Object { 
#    $var= $_.Name+";"+$_.VlanConfiguration
#    #$var
#}

#Write-Host $var
#    $split=$var.Split(";")
#
#    $name = $split[0]
#    $vlan = $split[1]
#    Write-Host "Naam" $name
#    Write-Host "VlanID"$vlan



$desired = (
"0;vMotion;VLAN 110",
"1;Management;VLAN 100",
"2;Servers;VLAN 200",
"3;NFS;VLAN 2",
"4;DSwitch01-DVUplinks-42;VLAN Trunk [0-4094]")

#$desired = (
#"0;vMotion;VLAN 110",
#"1;Servers;VLAN 210",
#"2;Management;VLAN 100",
#"3;NFS;VLAN 2",
#"4;DSwitch01-DVUplinks-42;VLAN Trunk [0-4094]")

$i=0
[ScriptBlock]$Actual = {
    #$i = 0    # First element is 0
    (Get-VDPortgroup -VDSwitch "DSwitch01") | ForEach-Object {
        # [0] = Index, variable $i
        # [1] = Name of portgroup
        # [2] = VlanConfiguration
        # $var = one portgroup with all properties 
        $var = $i.ToString()+";"+$_.Name+";"+$_.VlanConfiguration
        $i ++
        $Var    # Returns value
    }
}

# Scriptblocks roep je aan met: PS> & $scriptblock

& $Actual 

# $Desired[1].split(";")[0]
$i=0
[ScriptBlock]$Fix = {
    (Get-VDPortgroup -VDSwitch "DSwitch01") | ForEach-Object { 
        $var = $i.ToString()+";"+$_.Name+";"+$_.VlanConfiguration
        if ($var -ne $Desired[$i]){
            Set-VDVlanConfiguration -VDPortgroup $Desired[$i].split(";")[1] -VlanId $Desired[$i].split(";")[2].Substring(5)
            #Write-Host "Change row: "$i
        }
        $i ++
    }
}

& $Fix
