$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0
# Import-Module -Name GetDateCodeFromFile -Verbose

function Set-FileTag {
<#
.SYNOPSIS
Adds, removes, or clears tags in a file name.

.DESCRIPTION
This function modifies the file name by adding a specified tag, removing it, or clearing all tags based on the provided arguments. Tags follow the format "_#xx" where "xx" is 2 or 3 characters.

.PARAMETER FilePath
Mandatory. The full path to the file to modify.

.PARAMETER Tag
Optional. The type of tag to add or modify. Supported tags:
- Star1 -> "_#s1"
- Star2 -> "_#s2"
- Star3 -> "_#s3"
- Star4 -> "_#s4"
- Star5 -> "_#s5"
- Fix -> "_#fx"
- FixFace -> "_#fc"

.PARAMETER ClearAllTags
Optional. If specified, all tags will be cleared from the file name.

.EXAMPLE
Set-FileTag -FilePath "C:\example.txt" -Tag "Star1"
Adds the "_#s1" tag to the file name.

.EXAMPLE
Set-FileTag -FilePath "C:\example_#s1.txt" -Tag "Star1"
Removes the "_#s1" tag from the file name.

.EXAMPLE
Set-FileTag -FilePath "C:\example_#s1.txt" -Tag "Star2"
Replaces "_#s1" with "_#s2".

.EXAMPLE
Set-FileTag -FilePath "C:\example_#s1_#fx.txt" -ClearAllTags
Removes all tags from the file name.
#>
    [CmdletBinding()]
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

    Process {
        # Define tag mappings
        $tagMap = @{
            "Star1" = "_#s1"
            "Star2" = "_#s2"
            "Star3" = "_#s3"
            "Star4" = "_#s4"
            "Star5" = "_#s5"
            "Fix" = "_#fx"
            "FixFace" = "_#fc"
        }

        # Extract file name components
        $directory = Split-Path -Path $FilePath -Parent
        $fileName = Split-Path -Path $FilePath -Leaf
        $baseName = [System.IO.Path]::GetFileNameWithoutExtension($fileName)
        $extension = [System.IO.Path]::GetExtension($fileName)

        # Regular expression to identify existing tags
        $tagPattern = "_#(s[1-5]|fx|fc)"

        # Clear all tags if -ClearAllTags is specified
        if ($ClearAllTags) {
            $newBaseName = $baseName -replace $tagPattern, ""
            $newFileName = "${newBaseName}${extension}"
            Rename-Item -Path $FilePath -NewName $newFileName
            Write-Output "All tags cleared. New file name: $newFileName"
            return
        }

        # Ensure the specified tag is valid and get its value
        if ($Tag) {
            $newTag = $tagMap[$Tag]

            # Remove any existing matching tags
            $baseName = $baseName -replace $tagPattern, ""

            # If the tag is "Star[1-5]", remove any existing "Star[1-5]" tags
            if ($newTag -match "_#s[1-5]") {
                $baseName = $baseName -replace "_#s[1-5]", ""
            }

            # Append the new tag
            $newBaseName = "${baseName}${newTag}"
            $newFileName = "${newBaseName}${extension}"
            Rename-Item -Path $FilePath -NewName $newFileName
            Write-Output "Tag applied. New file name: $newFileName"
            return
        }
    }
}
Export-ModuleMember -Function Set-FileTag
