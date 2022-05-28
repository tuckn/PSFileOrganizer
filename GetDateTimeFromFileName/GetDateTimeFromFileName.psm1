using module "..\GetDateTimeFromStr\GetDateTimeFromStr.psm1"

<#
.Synopsis
Get a date code from the specified file.

.Description
Get the older date time string from the specified file.

.Parameter FilePath
The file path. This filename needs to include from year to sec by default.

.Parameter UnknownDayAs
You can use a numeric two-digit number string. For example, "01". Even if the day string analysis becomes an error, if this argument is specified, the process will proceed.

.Parameter UnknownTimeAs
You can use "hh:mm:ss" format. for example "00:00:00". Even if the time string analysis becomes an error, if this argument is specified, the process will proceed.

.Example
PS> Get-DateTimeFromFileName -FilePath "C:\20181115T194401_myphoto.jpg"
yyyy: 2018
MM: 11
dd: 15
hh: 19
mm: 44
ss: 01
[OK] It's the correct date string

2018年11月15日 19:44:01

.Example
PS> Get-DateTimeFromFileName -FilePath "C:\2018-11-15.jpg"
Get-DateTimeFromFileName : This string is not containing the time code "hh:mm:ss": "2018-11-15.jpg"
#>
$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

function Get-DateTimeFromFileName {
    [CmdletBinding()]
    Param(
        [Parameter(Position = 0, Mandatory = $true)]
        [ValidateScript({ Test-Path -LiteralPath $_ })]
        [String] $FilePath,

        [Parameter(Position = 1)]
        [String] $UnknownDayAs,

        [Parameter(Position = 2)]
        [String] $UnknownTimeAs
    )
    Process {
        Write-Host $FilePath

        $f = $null
        try {
            $f = Get-Item -LiteralPath "$FilePath"
        }
        catch {
            Write-Error $_
            exit 1
        }

        # Extract the date code from the file name
        $bn = $f.BaseName

        try {
            $dateTime = Get-DateTimeFromStr -Str "$bn" -UnknownDayAs "$UnknownDayAs" -UnknownTimeAs "$UnknownTimeAs"
        }
        catch {
            Write-Error $_
            exit 1
        }

        return $dateTime
    }
}
Export-ModuleMember -Function Get-DateTimeFromFileName