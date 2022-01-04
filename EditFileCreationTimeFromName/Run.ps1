using module ".\EditFileCreationTimeFromName.psm1"

Param(
    [Parameter(Position = 0, Mandatory = $true)]
    [String] $FilePath
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

# FilePath is Foler
if ((Get-Item $FilePath).PSIsContainer) {
    $childPath = Join-Path -Path "$FilePath" -ChildPath "*.*"
    foreach ($f in Get-ChildItem $childPath) {
        Edit-FileCreatinTimeFromName -FilePath "$($f.FullName)"
    }
}
# FilePath is File
elseif (Test-Path -LiteralPath $FilePath) {
    Edit-FileCreatinTimeFromName -FilePath "$FilePath"
}
else {
    Write-Error "The file is not existing: `"$FilePath`""
    exit 1
}