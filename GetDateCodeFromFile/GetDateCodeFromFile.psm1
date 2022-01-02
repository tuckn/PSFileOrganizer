<#
.Synopsis
Get a date code from the specified file.

.Description
Get the older date time string from the specified file.

.Parameter FilePath
The file path.

.Parameter DateFormat
The date format. For example "yyyy-MM-dd". Default is "yyyyMMddTHHmmss+0900".

.Example
PS> Get-DateCodeFromFile -FilePath "C:\myphoto.jpg"
Created:  2018/11/15 19:44:01
Modefied: 2021/12/31 18:22:21
20181115T194401

.Example
PS> Get-DateCodeFromFile -FilePath "C:\myphoto.jpg" -DateFormat "yy-MM-dd" | Set-Clipboard
Created:  2018/11/15 19:44:01
Modefied: 2021/12/31 18:22:21
#>
$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

function Get-DateCodeFromFile {
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
            $f = Get-Item -LiteralPath "$FilePath"
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