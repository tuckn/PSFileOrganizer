<#
.Synopsis
Gets the first file in a specified folder that matches a given regular expression pattern.

.Description
The `Get-FirstMatchedFile` function retrieves the first file in the specified folder that matches a regular expression pattern. It searches through the folder, matches files against the provided pattern, sorts them in descending (default) order by name, and returns the first file from the sorted list. This function is useful for finding a specific file when you have a naming convention or pattern to match against.

.Parameter FolderPath
Mandatory. Specifies the path of the folder to search for files. This parameter accepts a string that represents the folder path. The function checks if the specified path exists.

.Parameter RegExpPattern
Optional. Specifies the regular expression pattern to match against the file names in the folder. Defaults to '.+' (matches any file name). This parameter accepts a string that represents the regular expression pattern.

.Parameter Ascending
Optional. A switch parameter that, when specified, sorts the files in ascending order by their names (from A to Z). This typically results in returning the oldest or the first file in the list. If this parameter is not specified, the default behavior is to sort the files in descending order (from Z to A), which usually returns the newest or the last file first.

.Example
```powershell
Get-FirstMatchedFile -FolderPath "C:\Documents" -RegExpPattern "^Report.*\.txt$"
```
This example searches the "C:\Documents" folder for the first file whose name starts with "Report" and ends with ".txt", and then returns this file object.
#>
$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

function Get-FirstMatchedFile {
    [CmdletBinding()]
    Param(
        [Parameter(Position = 0, Mandatory = $true)]
        [ValidateScript({ Test-Path -LiteralPath $_ })]
        [ValidateScript({ (Get-Item $_).PSIsContainer })]
        [string] $FolderPath,

        [Parameter(Position = 1)]
        [string] $RegExpPattern = '.+',

        [Parameter(Position = 2)]
        [switch] $Ascending
    )
    Process {
        try {
            $files = Get-ChildItem -Path $FolderPath  | Where-Object { $_.Name -match $RegExpPattern }

            if ($Ascending) {
                $files = $files | Sort-Object Name
            } else {
                $files = $files | Sort-Object Name -Descending
            }

            $latestFile = $files | Select-Object -First 1
        }
        catch {
            Write-Host $_.Exception.Message
        }

        return $latestFile
    }
}
Export-ModuleMember -Function Get-FirstMatchedFile