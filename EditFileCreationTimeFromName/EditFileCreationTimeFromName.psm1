using module "..\GetDateTimeFromFileName\GetDateTimeFromFileName.psm1"

<#
.Synopsis
Change the file creation time from file name.

.Description
Change the file creation time from file name.

.Parameter FilePath
The file path. It needs to start from year to sec by default.

.Example
PS > (Get-Item -LiteralPath "C:\20181115T194401_myphoto.jpg").CreationTime
2021年1月1日 11:15:14

PS> Get-DateTimeFromFileName -FilePath "C:\20181115T194401_myphoto.jpg"
...
..
PS > (Get-Item -LiteralPath "C:\20181115T194401_myphoto.jpg").CreationTime
2018年11月15日 19:44:01

#>
$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

function Edit-FileCreatinTimeFromName {
    [CmdletBinding()]
    Param(
        [Parameter(Position = 0, Mandatory = $true)]
        [ValidateScript({ Test-Path -LiteralPath $_ })]
        [String] $FilePath
    )
    Process {
        Write-Host $FilePath

        $date = Get-DateTimeFromFileName -FilePath "$FilePath"

        $f = $null
        try {
            $f = Get-Item -LiteralPath "$FilePath"
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
Export-ModuleMember -Function Edit-FileCreatinTimeFromName