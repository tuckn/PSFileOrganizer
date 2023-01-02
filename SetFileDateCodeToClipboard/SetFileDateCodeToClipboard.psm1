using module "..\GetDateCodeFromFile\GetDateCodeFromFile.psm1"

<#
.Synopsis
Set a file date code to the clipboard.

.Description
Set a file date code to the clipboard.

.Parameter FilePath
The file path.

.Parameter DateFormat
The date format. For example "yyyy-MM-dd". Default is "yyyyMMddTHHmmss".

.Example
PS> Set-FileDateCodeToClipboard -FilePath "C:\myphoto.jpg" -DateFormat "yyyyMMddTHHmmss"
#>
$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

function Set-FileDateCodeToClipboard {
    [CmdletBinding()]
    Param(
        [Parameter(Position = 0, Mandatory = $true)]
        [ValidateScript({ Test-Path -LiteralPath $_ })]
        [String] $FilePath,

        [Parameter(Position = 1)]
        [String] $DateFormat = "yyyyMMddTHHmmss" # ISO 8601
    )
    Process {
        Get-DateCodeFromFile -FilePath "$FilePath" -DateFormat $DateFormat | Set-Clipboard

        return
    }
}
Export-ModuleMember -Function Set-FileDateCodeToClipboard