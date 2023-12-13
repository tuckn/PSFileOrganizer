using module ".\GetDateTimeFromStr.psm1"

$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

function Get-DateTimeFromFileName {
<#
.SYNOPSIS
Extracts a datetime object from a file's name.

.DESCRIPTION
The `Get-DateTimeFromFileName` function interprets and extracts a date and time from a given file's name. This is particularly useful for files named with a specific date format embedded within them. The function allows for handling unknown day and time values through user-defined parameters. It's a handy tool for organizing files or extracting metadata based solely on file names.

.PARAMETER FilePath
Mandatory. The full path of the file from which the date and time are to be extracted. The function verifies if the specified file exists.

.PARAMETER UnknownDayAs
Optional. A string to represent unknown day values in the file name. This parameter allows the user to define a default value for the day portion of the date if it is not present or discernible in the file name.
You can use a numeric two-digit number string. For example, "01". Even if the day string analysis becomes an error, the process will proceed if this argument is specified.

.PARAMETER UnknownTimeAs
Optional. A string to represent unknown time values in the file name. Similar to `UnknownDayAs`, this parameter allows the user to set a default time if it is not present or recognizable in the file name.
You can use "hh:mm:ss" format. for example "00:00:00". Even if the time string analysis becomes an error, the process will proceed if this argument is specified.

.EXAMPLE
In this example, the function is used to extract the date and time from the file name "file_20210101.txt". If the day or time portions are missing or unclear, it defaults them to the first day of the month and midnight, respectively.

```powershell
PS> Get-DateTimeFromFileName -FilePath "C:\path\to\file_20210123.txt" -UnknownDayAs "01" -UnknownTimeAs "00:00"
yyyy: 2021
MM: 01
dd: 23
hh: 00
mm: 00
ss: 00
[OK] It's the correct date string

2021年01月23日 00:00:00
```
#>
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
            $f = Get-Item -LiteralPath $FilePath
        }
        catch {
            Write-Error $_
            exit 1
        }

        # Extract the date code from the file name
        $bn = $f.BaseName

        try {
            $dateTime = Get-DateTimeFromStr -Str $bn -UnknownDayAs $UnknownDayAs -UnknownTimeAs $UnknownTimeAs
        }
        catch {
            Write-Error $_
            exit 1
        }

        return $dateTime
    }
}
Export-ModuleMember -Function Get-DateTimeFromFileName