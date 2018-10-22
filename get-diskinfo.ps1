#========================================================================
# Created with: SAPIEN Technologies, Inc., PowerShell Studio 2012 v3.1.11
# Created on:   10/23/2012 3:48 PM
# Created by:   PGallagher
# Organization: 
# Filename:     
#========================================================================


function Get-DiskInfo {
		<# help here #>
	[CmdletBinding()]
	Param ( [Parameter(Mandatory=$true,ValueFromPipeline=$true)][string[]]$ComputerName,
	[int]$threshold = '20'
    )
    PROCESS {
        foreach ($computer in $computername) {
            try {
                $goodtogo = $true
                $net = get-wmiobject -class win32_networkadapter -ComputerName $Computer -EA Stop -EV myerr 
            } catch {
                "BROKE: $computer" | out-file c:\hold\_powershell\diskerror.txt -append
                Write-Verbose "Talking to $computer, $myerr"
                $goodtogo = $false
            }
				Write-Verbose "Now Trying $computer"
				Get-WmiObject Win32_LogicalDisk -ComputerName $computer -Filter "drivetype=3" |  select deviceid,
					
					@{n='FreeSpacepercent';e={$_.freespace / $_.size * 100 -as [int] }} | 
									where {$_.freespacepercent -gt $threshold}
				}
			}
	}

				get-diskinfo -computername mkc11      -Verbose | ft -AutoSize