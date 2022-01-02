using module "..\GetDateCodeFromFile\GetDateCodeFromFile.psm1"

<#
.Synopsis
Rename a file into the date code

.Description
Rename a file with adding the date code. for Example basename_2021-01-01.ext

.Parameter FilePath
The file path.

.Parameter DateFormat
The date format. For example "yyyy-MM-dd". Default is "yyyyMMddTHHmmss+0900".

.Parameter OriginalName
Specify how to handle the original file name. "Pre" or "Post". Not specify or empty to delete the name.

.Example
PS> Rename-FileIntoDateCode -FilePath "C:\myphoto.jpg"
# Rename myphoto.jpg to 20181115T194401_myphoto.jpg

.Example
PS> Rename-FileIntoDateCode -FilePath "C:\myphoto.jpg" -DateFormat "[yyyy-MM-dd] " -OriginalName "Post"
# Reneme myphoto.jpg to [2018-11-15] myphoto.jpg
#>
$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0
# Import-Module -Name GetDateCodeFromFile -Verbose

function Rename-FileIntoDateCode {
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

        $dateCode = Get-DateCodeFromFile -FilePath "$FilePath" -DateFormat $DateFormat

        $f = $null
        try {
            $f = Get-Item -LiteralPath "$FilePath"
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
Export-ModuleMember -Function Rename-FileIntoDateCode