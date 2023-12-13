using module ".\GetDateCodeFromFile.psm1"

$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0
# Import-Module -Name GetDateCodeFromFile -Verbose

function Rename-FileWithDateCode {
<#
.SYNOPSIS
Renames a file by incorporating a date code into its name.

.DESCRIPTION
The `Rename-FileWithDateCode` function renames a specified file by adding a date code based on the file's creation or last write time. This function is useful for organizing files with date-coded names for easy identification and sorting. The date code format can be customized, and the original file name can be preserved either before or after the date code, or not included at all.

.PARAMETER FilePath
Mandatory. Specifies the full path of the file to be renamed. The script checks if the file exists at this path.

.PARAMETER DateFormat
Optional. Defines the format of the date code to be added to the file name. The default format is "yyyyMMddTHHmmss_" (ISO 8601 format).

.PARAMETER OriginalName
Optional. Determines the position of the original file name in relation to the date code. Valid options are "Pre" (original name before the date code), "Post" (original name after the date code), and an empty string (original name is not included). The default is "Post".

.EXAMPLE
```powershell
Rename-FileWithDateCode -FilePath "C:\myphoto.jpg"
# Rename myphoto.jpg to 20181115T194401_myphoto.jpg
```

.EXAMPLE
```powershell
Rename-FileWithDateCode -FilePath "C:\myphoto.jpg" -DateFormat "[yyyy-MM-dd] " -OriginalName "Post"
# Reneme myphoto.jpg to [2018-11-15] myphoto.jpg
```
#>
    [CmdletBinding()]
    Param(
        [Parameter(Position = 0, Mandatory = $true)]
        [ValidateScript({ Test-Path -LiteralPath $_ })]
        [String] $FilePath,

        [Parameter(Position = 1)]
        [String] $DateFormat = "yyyyMMddTHHmmss_", # ISO 8601

        [Parameter(Position = 2)]
        [ValidateSet("", "Pre", "Post")]
        [String] $OriginalName = "Post"
    )
    Process {
        Write-Host $FilePath

        $dateCode = Get-DateCodeFromFile -FilePath $FilePath -DateFormat $DateFormat

        $f = $null
        try {
            $f = Get-Item -LiteralPath $FilePath
        }
        catch {
            Write-Error $_
            exit 1
        }

        $newName = $null
        if ($OriginalName -eq "Pre") {
            $newName = "$($f.BaseName)$dateCode$($f.Extension.ToLower())"
        }
        elseif ($OriginalName -eq "Post") {
            $newName = "$dateCode$($f.BaseName)$($f.Extension.ToLower())"
        }
        else {
            $newName = "$dateCode$($f.Extension.ToLower())"
        }

        try {
            Rename-Item -LiteralPath $f.FullName -NewName $newName
        }
        catch {
            Write-Error $_
            exit 1
        }

        return $newName
    }
}
Export-ModuleMember -Function Rename-FileWithDateCode