using module ".\SplitCsvDataWithDateCol.psm1"

Param(
    [Parameter(Position = 0, Mandatory = $true)]
    [String] $FilePath,

    [Parameter(Position = 1, Mandatory = $true)]
    [String] $ColumnName
)

$ErrorActionPreference = "Continue"
Set-StrictMode -Version 2.0

# FilePath is Foler
if ((Get-Item -LiteralPath $FilePath).PSIsContainer) {
    $childPath = Join-Path -Path "$FilePath" -ChildPath "*.*"
    foreach ($f in Get-ChildItem $childPath) {
        try {
            Split-CsvDataWithDateCol -FilePath "$($f.FullName)" -ColumnName "$ColumnName"
        }
        catch {
            Write-Error $_
        }
    }
}
# FilePath is File
elseif (Test-Path -LiteralPath $FilePath) {
    try {
        Split-CsvDataWithDateCol -FilePath "$FilePath" -ColumnName "$ColumnName"
    }
    catch {
        Write-Error $_
    }
}
else {
    Write-Error "The file is not existing: `"$FilePath`""
    exit 1
}