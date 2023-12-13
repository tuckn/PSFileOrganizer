using module ".\GetDateCodeFromFile.psm1"

$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

function Set-FileDateCodeToClipboard {
<#
.SYNOPSIS
Copies a date code generated from a file's timestamp to the clipboard.

.DESCRIPTION
The `Set-FileDateCodeToClipboard` function generates a date code from the creation or last write time of a specified file and copies this date code to the clipboard. This function is convenient for quickly obtaining and using a standardized date code from a file, formatted according to the ISO 8601 standard or a specified custom format. The generated date code can be used for various purposes like file naming, documentation, or logging.

.PARAMETER  FilePath
Mandatory. Specifies the full path of the file from which the date code is to be generated. The script verifies that the file exists at this path.

.PARAMETER DateFormat
Optional. Defines the format string of the date code to be generated. The default format is "yyyyMMddTHHmmss", which corresponds to the ISO 8601 format. This parameter allows customization of the output date code format.

.EXAMPLE
```powershell
Set-FileDateCodeToClipboard -FilePath "C:\path\to\file.txt"
```

This example generates a date code from the specified file's timestamp using the default date format ("yyyyMMddTHHmmss") and copies the date code to the clipboard.
#>
    [CmdletBinding()]
    Param(
        [Parameter(Position = 0, Mandatory = $true)]
        [ValidateScript({ Test-Path -LiteralPath $_ })]
        [String] $FilePath,

        [Parameter(Position = 1)]
        [String] $DateFormat = "yyyyMMddTHHmmss" # ISO 8601
    )
    Process {
        Get-DateCodeFromFile -FilePath $FilePath -DateFormat $DateFormat | Set-Clipboard

        return
    }
}
Export-ModuleMember -Function Set-FileDateCodeToClipboard