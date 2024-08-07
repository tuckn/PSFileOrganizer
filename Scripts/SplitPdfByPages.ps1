using module "..\Modules\SplitPdfByPages.psm1"

Param(
    [Parameter(Position = 0, Mandatory = $true)]
    [ValidateScript({ Test-Path -LiteralPath $_ })]
    [String] $PdfFile,

    [Parameter(Position = 1, Mandatory = $true)]
    [int] $TotalPages,

    [Parameter(Position = 2, Mandatory = $true)]
    [int] $PagesPerSplit,

    [Parameter(Position = 3)]
    [String] $OutputDirectory = (Get-Location),

    [Parameter(Position = 4)]
    [String] $QpdfPath = "qpdf"
)

Set-StrictMode -Version 3.0

# # Debug
# Write-Output "PdfFile: $PdfFile"
# Write-Output "TotalPages: $TotalPages"
# Write-Output "PagesPerSplit: $PagesPerSplit"
# Write-Output "OutputDirectory: $OutputDirectory"
# Write-Output "QpdfPath: $QpdfPath"
# Write-Output ([string]::IsNullOrEmpty($OutputDirectory))

$params = @{
    PdfFile = $PdfFile
    TotalPages = $TotalPages
    PagesPerSplit = $PagesPerSplit
}

if (-not [string]::IsNullOrEmpty($OutputDirectory)) {
    $params.OutputDirectory = $OutputDirectory
}

if (-not [string]::IsNullOrEmpty($QpdfPath)) {
    $params.QpdfPath = $QpdfPath
}

Split-PdfByPages @params
