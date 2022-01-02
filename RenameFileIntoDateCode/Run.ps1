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

Rename-FileIntoDateCode -FilePath "$FilePath" -DateFormat "$DateFormat" -OriginalName "$OriginalName"
