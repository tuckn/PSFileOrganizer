using module "..\Modules\GetExcelWorkbookInfo.psm1"

Param(
    [Alias('FullName')]
    [Parameter(ValueFromPipelineByPropertyName=$true, ValueFromPipeline=$true, Mandatory=$true)]
    [String]$Path
)

$ErrorActionPreference = "Continue"
Set-StrictMode -Version 2.0

Get-ExcelWorkbookInfo -FullName $Path
