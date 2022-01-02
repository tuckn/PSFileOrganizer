using module ".\EditFileCreationTimeFromName.psm1"

Param(
    [Parameter(Position = 0, Mandatory = $true)]
    [String] $FilePath
)
Edit-FileCreatinTimeFromName -FilePath "$FilePath"
