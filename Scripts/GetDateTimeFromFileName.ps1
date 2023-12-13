using module "..\Modules\GetDateTimeFromFileName.psm1"

Param(
    [Parameter(Position = 0, Mandatory = $true)]
    # [ValidateScript({ Test-Path -LiteralPath $_ })]
    [String] $FilePath,

    [Parameter(Position = 1)]
    [String] $UnknownTimeAs
)

Get-DateTimeFromFileName -FilePath $FilePath -UnknownTimeAs $UnknownTimeAs
