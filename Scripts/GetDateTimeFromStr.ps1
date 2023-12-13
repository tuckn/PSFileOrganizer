using module "..\Modules\GetDateTimeFromStr.psm1"

Param(
    [Parameter(Position = 0, Mandatory = $true)]
    [String] $Str,

    [Parameter(Position = 1)]
    [String] $UnknownTimeAs
)

Get-DateTimeFromStr -Str $Str -UnknownTimeAs $UnknownTimeAs
