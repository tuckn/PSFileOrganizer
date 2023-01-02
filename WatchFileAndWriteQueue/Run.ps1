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
    [String] $QueueDir = ($env:TEMP | Join-Path -ChildPath $([System.Guid]::NewGuid().Guid))
)

$ErrorActionPreference = "Continue"
Set-StrictMode -Version 2.0

# FilePath is Foler
# if ((Get-Item -LiteralPath $FilePath).PSIsContainer) {
#     $childPath = Join-Path -Path "$FilePath" -ChildPath "*.*"
#     foreach ($f in Get-ChildItem $childPath) {
#         try {
#             Get-MetadataFromFile -FilePath "$($f.FullName)" -DateFormat "$DateFormat" -OriginalName "$OriginalName"
        Write-Host $FilteredEvents
        Write-Host $FilteredEvents.Count
Watch-FileAndWriteQueue -WatchingDir "$WatchingDir" -FilteredEvents $FilteredEvents
#         }
#         catch {
#             Write-Error $_
#         }
#     }
# }
# # FilePath is File
# elseif (Test-Path -LiteralPath $FilePath) {
#     try {
#         Get-MetadataFromFile -FilePath "$FilePath" -DateFormat "$DateFormat" -OriginalName "$OriginalName"
#     }
#     catch {
#         Write-Error $_
#     }
# }
# else {
#     Write-Error "The file is not existing: `"$FilePath`""
#     exit 1
# }