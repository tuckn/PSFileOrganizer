using module ".\GetDateTimeFromFileName.psm1"

$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

function Move-FileIntoDateFolder {
<#
.SYNOPSIS
Automatically moves files into folders based on a date extracted from their file names.

.DESCRIPTION
The `Move-FileIntoDateFolder` function organizes files by moving them into directories named after dates that are extracted from the files' names. This function is particularly useful for sorting and organizing files named with date codes. It allows customization of the date format for directory naming and supports the specification of a base directory for the destination.

.PARAMETER FilePath
Mandatory. Specifies the full path of the file that needs to be moved. The script checks if the file exists at the given path.
The file name must be in a format that "Get-DateTimeFromFileName" can recognize. To change the name, you can use something like "Rename-FileWithDateCode".

.PARAMETER SplitFormat
Optional. Defines the date format to use for creating directory names. The default format is "yyyy/MM". This format is used to extract the date from the file name and create corresponding directories.

.PARAMETER DestBaseDirPath
Optional. Specifies the base directory path for the destination folders. If this parameter is not provided, the script uses the current directory of the file. If a relative path is given, it is converted into an absolute path based on the current directory of the file.

.EXAMPLE
```powershell
Move-FileIntoDateFolder -FilePath "C:\Documents\Report_20210601.xlsx" -SplitFormat "yyyy/MM" -DestBaseDirPath "C:\ArchivedReports"
```
This example moves the file named "Report_20210601.xlsx" from "C:\Documents" to a new or existing folder within "C:\ArchivedReports\2021\06". The folder name is derived from the date in the file's name, using the specified split format.
#>
    [CmdletBinding()]
    Param(
        [Parameter(Position = 0, Mandatory = $true)]
        [ValidateScript({ Test-Path -LiteralPath $_ })]
        [String] $FilePath,

        [Parameter(Position = 1)]
        [String] $SplitFormat = "yyyy/MM",

        [Parameter(Position = 2)]
        [String] $DestBaseDirPath
    )
    Process {
        $f = $null
        try {
            $f = Get-Item -LiteralPath $FilePath
        }
        catch {
            Write-Error $_
            exit 1
        }

        # Create dest path
        $date = Get-DateTimeFromFileName -FilePath $FilePath -UnknownDayAs "01" -UnknownTimeAs "00:00:00"
        $dirName = $date.ToString($SplitFormat)
        $dirNameWin = $dirName.Replace("/", "\")

        $destDirPath = ""
        if ([string]::IsNullOrEmpty($DestBaseDirPath)) {
            $destDirPath = Join-Path -Path $f.DirectoryName -ChildPath $dirNameWin
        }
        elseif ([System.IO.Path]::IsPathRooted($DestBaseDirPath)) {
            $destDirPath = Join-Path -Path $DestBaseDirPath -ChildPath $dirNameWin
        }
        else {
            $destBaseDirRelPath = Join-Path -Path $f.DirectoryName -ChildPath $DestBaseDirPath
            $destBaseDirAbsPath = [System.IO.Path]::GetFullPath($destBaseDirRelPath)
            $destDirPath = Join-Path -Path $destBaseDirAbsPath -ChildPath $dirNameWin
        }

        [System.IO.Directory]::CreateDirectory($destDirPath)

        $destFilePath = Join-Path -Path $destDirPath -ChildPath $f.Name
        # Write-Host $destFilePath # console.log

        try {
            Move-Item -LiteralPath $FilePath -Destination $destFilePath
        }
        catch {
            Write-Error $_
            exit 1
        }

        return $destFilePath
    }
}
Export-ModuleMember -Function Move-FileIntoDateFolder