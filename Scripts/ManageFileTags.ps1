using module "..\Modules\ManageFileTags.psm1"

Param(
    [Parameter(Position = 0, Mandatory = $true)]
    [ValidateScript({ Test-Path -LiteralPath $_ })]
    [String]$FilePath,

    [Parameter(Position = 1)]
    [ValidateSet("Star1", "Star2", "Star3", "Star4", "Star5", "Fix", "FixFace")]
    [String]$Tag,

    [Parameter(Position = 2)]
    [Switch]$ClearAllTags
)

$ErrorActionPreference = "Continue"
Set-StrictMode -Version 2.0

# FilePath is Foler
if ((Get-Item -LiteralPath $FilePath).PSIsContainer) {
    $childPath = Join-Path -Path $FilePath -ChildPath "*.*"
    foreach ($f in Get-ChildItem $childPath) {
        try {
            if ($ClearAllTags) {
                Set-FileTag -FilePath $f.FullName -ClearAllTags
            }
            else {
                Set-FileTag -FilePath $f.FullName -Tag $Tag
            }
        }
        catch {
            Write-Error $_
        }
    }
}
# FilePath is File
elseif (Test-Path -LiteralPath $FilePath) {
    try {
        if ($ClearAllTags) {
            Set-FileTag -FilePath $FilePath -ClearAllTags
        }
        else {
            Set-FileTag -FilePath $FilePath -Tag $Tag
        }
    }
    catch {
        Write-Error $_
    }
}
else {
    Write-Error "The file is not existing: `"$FilePath`""
    exit 1
}
