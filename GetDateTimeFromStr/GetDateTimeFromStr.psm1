<#
.Synopsis
Get a date code from the specified file.

.Description
Get the older date time string from the specified file.

.Parameter Str
The string. It needs to include from year to sec by default.

.Parameter UnknownDayAs
You can use a numeric two-digit number string. For example, "01". Even if the day string analysis becomes an error, if this argument is specified, the process will proceed.

.Parameter UnknownTimeAs
You can use "hh:mm:ss" format. for example "00:00:00". Even if the time string analysis becomes an error, if this argument is specified, the process will proceed.

.Example
PS> Get-DateTimeFromStr -Str "20181115T194401_myphoto.jpg"
yyyy: 2018
MM: 11
dd: 15
hh: 19
mm: 44
ss: 01
[OK] It's the correct date string

2018年11月15日 19:44:01

.Example
PS> Get-DateTimeFromStr -Str "2018-11-15.jpg"
Get-DateTimeFromStr : This string is not containing the time code "hh:mm:ss": "2018-11-15.jpg"
#>
$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

function Get-DateTimeFromStr {
    [CmdletBinding()]
    Param(
        [Parameter(Position = 0, Mandatory = $true)]
        [String] $Str,

        [Parameter(Position = 1)]
        [String] $UnknownDayAs,

        [Parameter(Position = 2)]
        [String] $UnknownTimeAs
    )
    Process {
        Write-Host $Str

        $yearStr = ""
        $monthStr = ""
        $dayStr = ""

        # yyyy-MM-dd, yyyyMMdd, yyyy_MM_dd
        if ($Str -match "(\d{4})[_-]*(\d{2})[_-]*(\d{2})") {
            $yearStr = $Matches[1]
            Write-Host ('yyyy: {0}' -f $yearStr)

            $monthStr = $Matches[2]
            Write-Host ('MM: {0}' -f $monthStr)

            $dayStr = $Matches[3]
            Write-Host ('dd: {0}' -f $dayStr)
        }
        elseif ([string]::IsNullOrEmpty($UnknownDayAs)) {
            Write-Error "This string is not containing the date code `"yyyyMMdd`": `"$Str`""
            exit 1
        }
        elseif ($Str -match "(\d{4})[_-]*(\d{2})") {
            $yearStr = $Matches[1]
            Write-Host ('yyyy: {0}' -f $yearStr)

            $monthStr = $Matches[2]
            Write-Host ('MM: {0}' -f $monthStr)

            $dayStr = $UnknownDayAs
            Write-Host ('dd: {0}' -f $dayStr)
        }
        else {
            Write-Error "The specified parameter UnknownDayAs is not type of `"dd`": `"$UnknownDayAs`""
            exit 1
        }

        $hourStr = ""
        $minuteStr = ""
        $secondStr = ""

        # yyyyMMddhhmmss,yyyyMMddThhmmss, yyyyMMdd_hh-mm-ss, yyyyMMdd-hh_mm_ss
        if ($Str -match "\d{4}[_-]*\d{2}[_-]*\d{2}[T\s_-]?(\d{2})[_-]*(\d{2})[_-]*(\d{2})") {
            $hourStr = $Matches[1]
            Write-Host ('hh: {0}' -f $hourStr)

            $minuteStr = $Matches[2]
            Write-Host ('mm: {0}' -f $minuteStr)

            $secondStr = $Matches[3]
            Write-Host ('ss: {0}' -f $secondStr)
        }
        elseif ([string]::IsNullOrEmpty($UnknownTimeAs)) {
            Write-Error "This string is not containing the time code `"hh:mm:ss`": `"$Str`""
            exit 1
        }
        elseif ($UnknownTimeAs -match "(\d{2}):(\d{2}):(\d{2})") {
            $hourStr = $Matches[1]
            Write-Host ('hh: {0}' -f $hourStr)

            $minuteStr = $Matches[2]
            Write-Host ('mm: {0}' -f $minuteStr)

            $secondStr = $Matches[3]
            Write-Host ('ss: {0}' -f $secondStr)
        }
        else {
            Write-Error "The specified parameter UnknownTimeAs is not type of `"hh:mm:dd`": `"$UnknownTimeAs`""
            exit 1
        }

        # Check the number strings
        try {
            Get-Date -Year $yearStr | Out-Null
            Get-Date -Month $monthStr | Out-Null
            Get-Date -Day $dayStr | Out-Null
            Get-Date -Hour $hourStr | Out-Null
            Get-Date -Minute $minuteStr | Out-Null
            Get-Date -Second $secondStr | Out-Null
            Write-Host "[OK] It's the correct date time string"
        }
        catch {
            Write-Error $_
            exit 1
        }

        # Create the date time
        $dateStr = [string]::Concat($yearStr, "/", $monthStr, "/", $dayStr, " ", $hourStr, ":", $minuteStr, ":", $secondStr)

        try {
            $dateTime = [DateTime]::ParseExact($dateStr, "yyyy/MM/dd HH:mm:ss", $null)
        }
        catch {
            Write-Error $_
            exit 1
        }

        return $dateTime
    }
}
Export-ModuleMember -Function Get-DateTimeFromStr