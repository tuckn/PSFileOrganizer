using module "..\GetDateTimeFromFileName\GetDateTimeFromFileName.psm1"

<#
.Synopsis
Change the file creation time from file name.

.Description
Change the file creation time from file name.

.Parameter FilePath
The file path. It needs to start from year to month or day.

.Parameter SplitFormat
the destination folder format. The following format can be used.
"yyyy", "yyyy-MM, "yyyy/MM" (default), "yyyy/MM/dd"
Slash "\" means breaking directory. If day string analysis fails, it will be assigned to 01.

.Parameter DestBaseDirPath
The distination directory path. You can use relative path from Parameter FilePath.

.Example
#>
$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

function Move-FilesIntoDateFolder {
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
            $f = Get-Item -LiteralPath "$FilePath"
        }
        catch {
            Write-Error $_
            exit 1
        }

        # Create dest path
        $date = Get-DateTimeFromFileName -FilePath "$FilePath" -UnknownDayAs "01" -UnknownTimeAs "00:00:00"
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
Export-ModuleMember -Function Move-FilesIntoDateFolder