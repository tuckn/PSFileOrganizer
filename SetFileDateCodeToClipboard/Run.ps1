using module ".\SetFileDateCodeToClipboard.psm1"

Param(
    [Parameter(Position = 0, Mandatory = $true)]
    [String] $FilePath,

    [Parameter(Position = 1)]
    [String] $DateFormat = "yyyyMMddTHHmmss+0900"
)

Set-FileDateCodeToClipboard -FilePath "$FilePath" -DateFormat "$DateFormat"
