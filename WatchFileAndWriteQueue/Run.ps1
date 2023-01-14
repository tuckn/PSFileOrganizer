using module ".\WatchFileAndWriteQueue.psm1"

Param(
    [Parameter(Position = 0, Mandatory = $true)]
    [ValidateScript({ Test-Path -LiteralPath $_ })]
    [String] $WatchingDir,

    [Parameter(Position = 1)]
    [String] $FilteredName = "*",

    [Parameter(Position = 2)]
    [String[]] $FilteredEvents = @("Created", "Changed", "Renamed", "Deleted"),

    [Parameter(Position = 3)]
    [Boolean] $IncludesSubdir = $False,

    [Parameter(Position = 4)]
    [String] $QueueDir = ($env:TEMP | Join-Path -ChildPath "Queue_$($([System.Guid]::NewGuid().Guid))"),

    [Parameter(Position = 5)]
    [String] $QueueFileName = ((Get-Date -Format "yyyyMMddTHHmmssK").Replace(':', '') + ".txt"),

    [Parameter(Position = 6)]
    [String] $QueueFileEncoding = "utf-8",

    [Parameter(Position = 7)]
    [Int16] $DotIntervalSec = 1
)

$ErrorActionPreference = "Continue"
Set-StrictMode -Version 3.0

Watch-FileAndWriteQueue `
    -WatchingDir "$WatchingDir" `
    -DotIntervalSec $DotIntervalSec `
    -FilteredName $FilteredName `
    -FilteredEvents $FilteredEvents `
    -IncludesSubdir $IncludesSubdir `
    -QueueDir $QueueDir