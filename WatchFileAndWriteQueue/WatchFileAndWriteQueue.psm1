<#
.Synopsis
Watch a foler and write queue files.

.Description
Get the older date time string from the specified file.

.Parameter WatchingDir
The watched folder path.

.Parameter IntervalSec
The watching interval second.

.Parameter FilteredName
The triggered file name.

.Parameter FilterdEvents
The watched event name.

.Parameter QueueDir
The foler path to write queue files.

.Example
PS> Watch-FileAndWriteQueue -WatchingDir "C:\myphoto.jpg"
Created:  2018/11/15 19:44:01
Modefied: 2021/12/31 18:22:21
20181115T194401

.Example
PS> Watch-FileAndWriteQueue -WatchingDir "C:\myphoto.jpg" -IntervalSec "yy-MM-dd" | Set-Clipboard
Created:  2018/11/15 19:44:01
Modefied: 2021/12/31 18:22:21
#>
$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

function Watch-FileAndWriteQueue {
    [CmdletBinding()]
    Param(
        [Parameter(Position = 0, Mandatory = $true)]
        [ValidateScript({ Test-Path -LiteralPath $_ })]
        [String] $WatchingDir,

        [Parameter(Position = 1)]
        [Int16] $IntervalSec = 4,

        [Parameter(Position = 2)]
        [String] $FilteredName = "*",

        [Parameter(Position = 3)]
        [String[]] $FilteredEvents = @("Created", "Changed", "Renamed", "Deleted"),

        [Parameter(Position = 4)]
        [String] $QueueDir = ($env:TEMP | Join-Path -ChildPath $([System.Guid]::NewGuid().Guid))
    )
    Process {
        Write-Host $WatchingDir
        Write-Host $IntervalSec
        Write-Host $FilteredName
        Write-Host $FilteredEvents
        Write-Host $FilteredEvents.Count
        Write-Host $QueueDir

        # $f = $null
        # try {
        #     $f = Get-Item -LiteralPath "$WatchingDir"
        # }
        # catch {
        #     Write-Error $_
        #     exit 1
        # }

        # # Select the older date time
        # Write-Host ('Created:  {0}' -f $f.CreationTime)
        # Write-Host ('Modefied: {0}' -f $f.LastWriteTime)

        # $d = $f.CreationTime
        # if ($f.LastWriteTime -lt $f.CreationTime) {
        #     $d = $f.LastWriteTime
        # }

        # # @TODO: Get Meta data from EXIF, IPTC and so on...

        # $dateCode = $d.ToString($DateFormat)

        # return $dateCode
    }
}
Export-ModuleMember -Function Watch-FileAndWriteQueue