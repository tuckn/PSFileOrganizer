$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

function Get-DateTimeFromStr {
<#
.SYNOPSIS
Extracts a datetime object from a string based on specific formatting patterns.

.DESCRIPTION
The `Get-DateTimeFromStr` function parses a string to extract a date and time, based on recognized patterns. It is capable of identifying various date and time formats within a string and converting them into a datetime object. The function also provides flexibility to handle cases where the day or time might be unknown, allowing defaults to be specified.


.PARAMETER Str
Mandatory. The string from which the date and time are to be extracted. The string should contain date and/or time information in recognizable formats. It needs to include from year to second by default.

.PARAMETER UnknownDayAs
Optional. A default value for the day when the day is not present or discernible in the string. It should be in the format "dd". For example, "01". Even if the day string analysis becomes an error, if this argument is specified, the process will proceed.

.PARAMETER UnknownTimeAs
Optional. A default value for the time when the time is not present or recognizable in the string. It should be in the format "HH:mm:ss". For example, "00:00:00". Even if the time string analysis becomes an error, the process will proceed if this argument is specified.

.EXAMPLE
This example extracts the date and time from the string "20181115T194401_myphoto.jpg", which is already in a complete and recognizable format.

```powershell
PS> Get-DateTimeFromStr -Str "20181115T194401_myphoto.jpg"
yyyy: 2018
MM: 11
dd: 15
hh: 19
mm: 44
ss: 01
[OK] It's the correct date string

2018年11月15日 19:44:01
```

.EXAMPLE
This example extracts the date and time from the string "20210305", using "00:00:00" as the default time.

```powershell
PS> Get-DateTimeFromStr -Str "2018-11-15.jpg" -UnknownTimeAs "00:00:00"
yyyy: 2018
MM: 11
dd: 15
hh: 00
mm: 00
ss: 00
```
#>
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

        # yyyyMMddHHmmss,yyyyMMddTHHmmss, yyyyMMdd_hh-mm-ss, yyyyMMdd-hh_mm_ss
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