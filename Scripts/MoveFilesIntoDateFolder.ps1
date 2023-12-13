using module "..\Modules\MoveFileIntoDateFolder.psm1"

Param(
    [Parameter(Position = 0, Mandatory = $true)]
    [String] $FilePath,

    [Parameter(Position = 1)]
    [String] $SplitFormat = "yyyy/MM",

    [Parameter(Position = 2)]
    [String] $DestBaseDirPath,

    [Parameter(Position = 3)]
    [String] $MatchedName = "*.*"
)

$ErrorActionPreference = "Continue"
Set-StrictMode -Version 2.0

# FilePath is Foler
if ((Get-Item -LiteralPath $FilePath).PSIsContainer) {
    $childPath = Join-Path -Path $FilePath -ChildPath $MatchedName
    foreach ($f in Get-ChildItem $childPath) {
        try {
            Move-FileIntoDateFolder -FilePath $f.FullName -SplitFormat $SplitFormat -DestBaseDirPath $DestBaseDirPath
        }
        catch {
            Write-Error $_
        }
    }
}
# FilePath is File
elseif (Test-Path -LiteralPath $FilePath) {
    try {
        Move-FileIntoDateFolder -FilePath $FilePath -SplitFormat $SplitFormat -DestBaseDirPath $DestBaseDirPath
    }
    catch {
        Write-Error $_
    }
}
else {
    Write-Error "The file is not existing: `"$($FilePath)`""
    exit 1
}