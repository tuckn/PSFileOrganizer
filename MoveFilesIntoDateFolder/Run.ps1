using module ".\MoveFilesIntoDateFolder.psm1"

Param(
    [Parameter(Position = 0, Mandatory = $true)]
    [String] $FilePath,

    [Parameter(Position = 1)]
    [String] $SplitFormat = "yyyy/MM",

    [Parameter(Position = 2)]
    [String] $DestBaseDirPath
)

$ErrorActionPreference = "Continue"
Set-StrictMode -Version 2.0

# FilePath is Foler
if ((Get-Item -LiteralPath $FilePath).PSIsContainer) {
    $childPath = Join-Path -Path "$FilePath" -ChildPath "*.*"
    foreach ($f in Get-ChildItem $childPath) {
        try {
            Move-FilesIntoDateFolder -FilePath "$($f.FullName)" -SplitFormat $SplitFormat -DestBaseDirPath $DestBaseDirPath
        }
        catch {
            Write-Error $_
        }
    }
}
# FilePath is File
elseif (Test-Path -LiteralPath $FilePath) {
    try {
        Move-FilesIntoDateFolder -FilePath "$FilePath" -SplitFormat $SplitFormat -DestBaseDirPath $DestBaseDirPath
    }
    catch {
        Write-Error $_
    }
}
else {
    Write-Error "The file is not existing: `"$FilePath`""
    exit 1
}