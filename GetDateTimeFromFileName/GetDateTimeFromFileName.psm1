<#
.Synopsis
Get a date code from the specified file.

.Description
Get the older date time string from the specified file.

.Parameter FilePath
The file path.

.Example
PS> Get-DateTimeFromFileName -FilePath "C:\20181115T194401_myphoto.jpg"
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

function Get-DateTimeFromFileName {
    [CmdletBinding()]
    Param(
        [Parameter(Position = 0, Mandatory = $true)]
        [ValidateScript({ Test-Path -LiteralPath $_ })]
        [String] $FilePath
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

        # Extract the date code from the file name
        $bn = $f.BaseName

        if ($bn -match "(\d{4})[_-]*(\d{2})[_-]*(\d{2})[T\s_-](\d{2})[_-]*(\d{2})[_-]*(\d{2})") {
            Write-Host ('yyyy: {0}' -f $Matches[1])
            Write-Host ('MM: {0}' -f $Matches[2])
            Write-Host ('dd: {0}' -f $Matches[3])
            Write-Host ('hh: {0}' -f $Matches[4])
            Write-Host ('mm: {0}' -f $Matches[5])
            Write-Host ('ss: {0}' -f $Matches[6])
        }
        else {
            Write-Error "This file name is not type of the date code: `"$Arg`""
            exit 1
        }

        # Check the number strings
        try {
            Get-Date -Month $Matches[2] | Out-Null
            Get-Date -Day $Matches[3] | Out-Null
            Get-Date -Hour $Matches[4] | Out-Null
            Get-Date -Minute $Matches[5] | Out-Null
            Get-Date -Second $Matches[6] | Out-Null
            Write-Host "[OK] It's the correct date string"
        }
        catch {
            Write-Error $_
            exit 1
        }

        # Create the date time
        $dateStr = [string]::Concat($Matches[1], "/", $Matches[2], "/", $Matches[3], " ", $Matches[4], ":", $Matches[5], ":", $Matches[6])

        $dateTime = [DateTime]::ParseExact($dateStr, "yyyy/MM/dd hh:mm:ss", $null)

        Write-Host foobar
        return $dateTime
    }
}
Export-ModuleMember -Function Get-DateTimeFromFileName