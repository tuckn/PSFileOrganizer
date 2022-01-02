using module ".\GetDateTimeFromFileName.psm1"

Param(
    [Parameter(Position = 0, Mandatory = $true)]
    [String] $FilePath
)

Get-DateTimeFromFileName -FilePath "$FilePath"
