using module ".\RenameFileIntoDateCode.psm1"

Param(
    [Parameter(Position = 0, Mandatory = $true)]
    [String] $FilePath,

    [Parameter(Position = 1)]
    [String] $DateFormat = "yyyyMMddTHHmmss_",

    [Parameter(Position = 2)]
    [ValidateSet("", "Pre", "Post")]
    [String] $OriginalName = "Post"
)

$ErrorActionPreference = "Continue"
Set-StrictMode -Version 2.0

# FilePath is Foler
if ((Get-Item -LiteralPath $FilePath).PSIsContainer) {
    $childPath = Join-Path -Path "$FilePath" -ChildPath "*.*"
    foreach ($f in Get-ChildItem $childPath) {
        try {
            Rename-FileIntoDateCode -FilePath "$($f.FullName)" -DateFormat "$DateFormat" -OriginalName "$OriginalName"
        }
        catch {
            Write-Error $_
        }
    }
}
# FilePath is File
elseif (Test-Path -LiteralPath $FilePath) {
    try {
        Rename-FileIntoDateCode -FilePath "$FilePath" -DateFormat "$DateFormat" -OriginalName "$OriginalName"
    }
    catch {
        Write-Error $_
    }
}
else {
    Write-Error "The file is not existing: `"$FilePath`""
    exit 1
}
