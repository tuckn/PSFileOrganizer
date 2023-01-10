using module ".\WatchFileAndWriteQueue.psm1"

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
    [Boolean] $IncludesSubdir = $False,

    [Parameter(Position = 5)]
    [String] $QueueDir = ($env:TEMP | Join-Path -ChildPath $([System.Guid]::NewGuid().Guid)),

    [Parameter(Position = 6)]
    [String] $QueueFileName = ((Get-Date -Format "yyyyMMddTHHmmssK").Replace(':', '') + ".txt"),

    [Parameter(Position = 7)]
    [String] $QueueFileEncoding = "utf-8"
)

$ErrorActionPreference = "Continue"
Set-StrictMode -Version 3.0

Watch-FileAndWriteQueue `
    -WatchingDir "$WatchingDir" `
    -IntervalSec $IntervalSec `
    -FilteredName $FilteredName `
    -FilteredEvents $FilteredEvents `
    -IncludesSubdir $IncludesSubdir `
    -QueueDir $QueueDir