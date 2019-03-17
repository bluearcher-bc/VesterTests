# under construction

# Functions
function Dashboard-Vester {
	<#
	.SYNOPSIS
		
	.EXAMPLE
		PS> New-AdvancedFunction -Param1 MYPARAM

        This example does something to this and that.
	.PARAMETER Param1
        This param does this thing.
	.PARAMETER 
	.PARAMETER 
	.PARAMETER 
	#>

	[CmdletBinding()]
	param (
        [string]$Param1
	)

    # Run Invoke-Vester
    [Array]$Vesters = @()
    [Array]$DateTimes = @()
    $i = 0
    foreach ($VC in $VCs) {
        if (!$creds) {$creds = Get-Credential }
        # try catch 
        Connect-VIServer -Server $VC -Credential $creds
        # For testing, with limited Scope
        # $Vester = @(Invoke-Vester -Config $Configs[$i]  -Test (Get-VesterTest -Scope vCenter) -PassThru)
        $Vester = Invoke-Vester -Config $Configs[$i] -PassThru
        $DateTimes += Get-Date
        Disconnect-VIServer -Server $VC -Force -Confirm:$false
        # Last line
        #$Vesters += $vester
        $Vesters = $Vesters,$Vester
        $i++
    }
    
    # Process Data
    $VCColors = @()
    [Array]$GridDatas = @() 
    foreach ($Vester in $Vesters) {
        # Dashboard Color
        if ($Vester.FailedCount -ne 0) {
            $VCColor = 'yellow'
        } else {
            $VCColor = 'green'
        }
        $VCColors += $VCColor
        # Create DataGrid
        $GridData = $Vester.TestResult | Where-Object {$_.Passed -eq $false} |
        ForEach-Object {
            [pscustomobject]@{
            # Split Name field
            Type     = $_.Name.Split(" ")[0]
            Name     = $_.Name.Split(" ")[1]
            Test     = $_.Name.Split("-")[1].Substring(1)
            # Convert Errorcode to String, Split on linebreak and remove first part
            Desired  = $_.ErrorRecord.ToString().Split([Environment]::NewLine)[0].Substring(11)
            Actual   = $_.ErrorRecord.ToString().Split([Environment]::NewLine)[1].Substring(11)
            Synopsis = $_.ErrorRecord.ToString().Split([Environment]::NewLine)[2].Substring(11)
            }
        } 
        #$GridDatas += @($GridData)
        $GridDatas = $GridDatas,$GridData
    }



    # Stop old dashboard
    Get-UDDashboard -Name 'VesterDashboard' | Stop-UDDashboard

    # Create New Dashboard
    $FontColor = 'Black'
    # Footer
    $NavBarLinks = @((New-UDLink -Text "About" -Url "https://paulgrevink.wordpress.com/2018/11/29/about-configuration-drift-pester-and-vester/" -Icon question_circle),
                     (New-UDLink -Text "More info" -Url "https://paulgrevink.wordpress.com/2018/11/29/about-configuration-drift-pester-and-vester/" -Icon book))
    $Footer = New-UDFooter -Copyright "Copyright: Paul Grevink"
    # Index
    $i = 0
    $HomePage = New-UDPage -Name "Home" -Icon home -DefaultHomePage -Content { 
      New-UDRow {
        New-UDColumn -Size 12 {
          New-UDLayout -Columns 2 -Content {
            New-UDCard -Title $VCs[$i] -Content {
              New-UDParagraph -Text "Config: $($Configs[$i])" -Color $FontColor
              New-UDParagraph -Text "=== Test Results of $($DateTimes[$i]) ==="  -Color $FontColor
              New-UDParagraph -Text "Total   : $($Vesters[$i].TotalCount)"    -Color 'Black'
              New-UDParagraph -Text "Passed  : $($Vesters[$i].PassedCount)"   -Color 'Green'
              New-UDParagraph -Text "Failed  : $($Vesters[$i].FailedCount)"   -Color 'Red'
              New-UDParagraph -Text "Skipped : $($Vesters[$i].SkippedCount)"  -Color 'Black'
              New-UDParagraph -Text "Pending : $($Vesters[$i].PendingCount)"  -Color 'Black'
            } -FontColor $FontColor -BackgroundColor $VCColors[$i] -Links (New-UDLink -Text "See Errors" -Url $VCs[$i] -Icon book)
            $i ++
            New-UDCard -Title $($VCs[$i]) -Content {
              New-UDParagraph -Text "Config: $($Configs[$i])" -Color $FontColor
              New-UDParagraph -Text "=== Test Results of $($DateTimes[$i]) ==="  -Color $FontColor
              New-UDParagraph -Text "Total   : $($Vesters[$i].TotalCount)"    -Color 'Black'
              New-UDParagraph -Text "Passed  : $($Vesters[$i].PassedCount)"   -Color 'Green'
              New-UDParagraph -Text "Failed  : $($Vesters[$i].FailedCount)"   -Color 'Red'
              New-UDParagraph -Text "Skipped : $($Vesters[$i].SkippedCount)"  -Color 'Black'
              New-UDParagraph -Text "Pending : $($Vesters[$i].PendingCount)"  -Color 'Black'
            } -FontColor $FontColor -BackgroundColor $VCColors[$i] -Links (New-UDLink -Text "See Errors" -Url $VCs[$i] -Icon book)
            $i++
            New-UDCard 
          }
        }
      }
    }
    # Index
    $i = 0
    $VC0 = New-UDPage -Name $VCs[$i] -Icon grav -Content { 
        New-UDRow {
            New-UDColumn -Size 12 {
                New-UDGrid -Title "Errors $($VCs[$i])"  -Headers @("Type", "Name", "Test", "Desired", "Actual", "Synopsis") -Properties @("Type", "Name", "Test", "Desired", "Actual", "Synopsis") -Endpoint {
                $GridDatas[$i] | Out-UDGridData
                } -FontColor "black"  
            }
        }
    }
    $i ++
    $VC1 = New-UDPage -Name $VCs[$i] -Icon grav -Content { 
        New-UDRow {
            New-UDColumn -Size 12 {
                New-UDGrid -Title "Errors $($VCs[$i])"  -Headers @("Type", "Name", "Test", "Desired", "Actual", "Synopsis") -Properties @("Type", "Name", "Test", "Desired", "Actual", "Synopsis") -Endpoint {
                $GridDatas[$i] | Out-UDGridData
                } -FontColor "black"  
            }
        }
    }
    $i ++
    #Next page

    #Start presenting Dashboard
    Start-UDDashboard -Content { 
        New-UDDashboard -NavbarLinks $NavBarLinks -Title "Vester Dashboard" -NavBarColor 'Orange' -NavBarFontColor 'Ẃhite' -BackgroundColor "#FF333333" -FontColor "#FFFFFFF" -Pages @(
            $HomePage,
            $VC0,
            $VC1
        ) -Footer $Footer
    } -Port 10000 -Name 'VesterDashboard'

    Write-Host "VesterCount" $Vesters.count

} # eof function






# Main
$VCs = @("vc06.virtual.local",
         "192.168.100.106")
$Configs = @("C:\Program Files\WindowsPowerShell\Modules\Vester\1.2.0\Configs\Config.json",
             "C:\Program Files\WindowsPowerShell\Modules\Vester\1.2.0\Configs\Config2.json")


Dashboard-Vester

