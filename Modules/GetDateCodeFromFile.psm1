$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

function Get-DateCodeFromFile {
<#
.SYNOPSIS
Generates a date code from a file's creation or last write time.

.DESCRIPTION
The `Get-DateCodeFromFile` function creates a date code based on the specified file's creation time or last write time. The function compares the file's creation and last write times and uses the earlier of the two. The resulting date code is formatted according to the specified or default date format, which follows the ISO 8601 standard.

.PARAMETER FilePath
Mandatory. The full path of the file from which the date code is generated. The function checks if the specified file exists.

.PARAMETER DateFormat
Optional. The format string to use for the date code. The default format is "yyyyMMddTHHmmss", which corresponds to the ISO 8601 format. This parameter allows customization of the output date code format. For example "yyyy-MM-dd".

.EXAMPLE
This example generates a date code for the specified file using the default date format ("yyyyMMddTHHmmss").

```powershell
PS> Get-DateCodeFromFile -FilePath "C:\path\to\file.png"
Created:  2018/11/15 19:44:01
Modified: 2021/12/31 18:22:21
20181115T194401
```

.EXAMPLE
This example generates a date code for the specified file using a custom date format ("yyyy-MM-dd") and sets the date code in the clipboard.

```powershell
Get-DateCodeFromFile -FilePath "C:\path\to\file.txt" -DateFormat "yyyy-MM-dd" | Set-Clipboard
Created:  2018/11/15 19:44:01
Modified: 2021/12/31 18:22:21
```
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
        Write-Host $FilePath

        $f = $null
        try {
            $f = Get-Item -LiteralPath $FilePath
        }
        catch {
            Write-Error $_
            exit 1
        }

        # Select the older date time
        Write-Host ('Created:  {0}' -f $f.CreationTime)
        Write-Host ('Modefied: {0}' -f $f.LastWriteTime)

        $d = $f.CreationTime
        if ($f.LastWriteTime -lt $f.CreationTime) {
            $d = $f.LastWriteTime
        }

        # @TODO: Get Meta data from EXIF, IPTC and so on...

        $dateCode = $d.ToString($DateFormat)

        return $dateCode
    }
}
Export-ModuleMember -Function Get-DateCodeFromFile