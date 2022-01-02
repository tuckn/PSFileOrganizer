using module ".\GetDateCodeFromFile.psm1"

Param(
    [Parameter(Position = 0, Mandatory = $true)]
    [String] $FilePath,

    [Parameter(Position = 1)]
    [String] $DateFormat = "yyyyMMddTHHmmss"
)

Get-DateCodeFromFile -FilePath "$FilePath" -DateFormat "$DateFormat"
