$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

function Remove-OldBackupFiles {
<#
.SYNOPSIS
Removes backup files from a specified directory based on a regular expression and retention count.

.DESCRIPTION
The `Remove-OldBackupFiles` function is designed to manage backup files within a specified directory. It identifies files that match a given regular expression and retains a specified number of the most recent files, deleting the rest. This function is particularly useful for maintaining a clean backup directory by ensuring only a certain number of the most recent backup files are kept based on their creation time.

.PARAMETER DirPath
Mandatory. Specifies the directory path where the backup files are located. The script verifies that the provided path is a valid directory.

.PARAMETER FileRegExp
Mandatory. A regular expression pattern to match the backup file names. Only files whose names match this pattern are considered for deletion or retention.

.PARAMETER StockQuantity
Mandatory. The number of recent files to retain in the directory. Files exceeding this count, and matching the regular expression, are deleted.

.Example
```powershell
Remove-OldBackupFiles -DirPath "C:\MyBackupDir" -FileRegExp "^backup_\d{8}\.zip" -StockQuantity 5
```

In this example, the function will process files in the "C:\MyBackupDir" directory. It will retain the five most recent files (based on creation time) that match the regular expression `backup_\d{8}\.zip` (which corresponds to files named like "backup_YYYYMMDD.zip") and will delete any additional files matching the pattern.
#>
    [CmdletBinding()]
    Param(
        [Parameter(Position = 0, Mandatory = $true)]
        [ValidateScript({ Test-Path -LiteralPath $_ })]
        [ValidateScript({ (Get-Item $_).PSIsContainer })]
        [String] $DirPath,

        [Parameter(Position = 1, Mandatory = $true)]
        [String] $FileRegExp,

        [Parameter(Position = 2, Mandatory = $true)]
        [Int] $StockQuantity
    )
    Process {
        $d = $null
        try {
            $d = Get-Item -LiteralPath $DirPath
        }
        catch {
            Write-Error $_
            exit 1
        }

        # Get files and sort by CreationTime
        $fs = Get-ChildItem -LiteralPath $DirPath | Sort-Object -Property CreationTime -Descending

        $reserveCount = 0

        foreach ($f in $fs) {
            if ($f.Name -match $FileRegExp) {
                if ($reserveCount -lt $StockQuantity) {
                    $reserveCount++
                }
                else {
                    try {
                        Write-Output "Remove ""$($f.FullName)"""
                        $f.Delete()
                    }
                    catch {
                        Write-Error $_
                    }
                }
            }
        }

        return
    }
}
Export-ModuleMember -Function Remove-OldBackupFiles