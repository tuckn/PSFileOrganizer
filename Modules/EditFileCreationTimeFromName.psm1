using module ".\GetDateTimeFromFileName.psm1"

$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

function Edit-FileCreationTimeFromName {
<#
.SYNOPSIS
Edits the creation time of a file based on its name.

.DESCRIPTION
The Edit-FileCreationTimeFromName function modifies the creation time of a specified file. It extracts a date from the file's name and sets this date as the new creation time of the file. This function is useful for organizing files or correcting the creation time based on naming conventions that include dates.

.PARAMETER FilePath
Mandatory. The full path of the file whose creation time needs to be edited. The function checks if the specified file exists. The file name should contain a date from which the new creation time will be derived.

.EXAMPLE
In this example, the function takes the file located at "C:\path\to\20181115T194401_myphoto.jpg", extracts the date from the file name, and sets that date as the file's creation time.

```powershell
PS > (Get-Item -LiteralPath "C:\path\to\20181115T194401_myphoto.jpg").CreationTime
2021年1月1日 11:15:14

PS> Edit-FileCreationTimeFromName -FilePath "C:path\to\20181115T194401_myphoto.jpg"
...
..
PS > (Get-Item -LiteralPath "C:path\to\20181115T194401_myphoto.jpg").CreationTime
2018年11月15日 19:44:01
```
#>
    [CmdletBinding()]
    Param(
        [Parameter(Position = 0, Mandatory = $true)]
        [ValidateScript({ Test-Path -LiteralPath $_ })]
        [String] $FilePath
    )
    Process {
        Write-Host $FilePath

        $date = Get-DateTimeFromFileName -FilePath $FilePath

        $f = $null
        try {
            $f = Get-Item -LiteralPath $FilePath
        }
        catch {
            Write-Error $_
            exit 1
        }

        try {
            $f.CreationTime = $date
        }
        catch {
            Write-Error $_
            exit 1
        }

        return $f
    }
}
Export-ModuleMember -Function Edit-FileCreationTimeFromName