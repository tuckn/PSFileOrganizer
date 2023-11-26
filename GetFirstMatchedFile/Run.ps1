using module ".\GetFirstMatchedFile.psm1"

Param(
    [Parameter(Position = 0, Mandatory = $true)]
    [ValidateScript({ Test-Path -LiteralPath $_ })]
    [ValidateScript({ (Get-Item $_).PSIsContainer })]
    [string] $FolderPath,

    [Parameter(Position = 1)]
    [string] $RegExpPattern,

    [Parameter(Position = 2)]
    [switch] $Ascending
)

Set-StrictMode -Version 3.0

$params = @{
    FolderPath = $FolderPath
    RegExpPattern = $RegExpPattern
    Ascending = $Ascending
}

Get-FirstMatchedFile @params
