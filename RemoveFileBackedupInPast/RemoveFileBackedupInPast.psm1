<#
.Synopsis
Remove files backed up in past.

.Description
Remove files backed up in past.

.Parameter DirPath
The directory path containning files to be deleted.

.Parameter FileRegExp
The regular expression of file names to be deleted.

.Parameter StockQuantity
The number of files to be stocked.

.Example
PS> Remove-FileBackedupInPast -DirPath "C:\myBackupDir" -FileRegExp "^node_modules_\d{8}" -StockQuantity 3
#>
$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

function Remove-FileBackedupInPast {
    [CmdletBinding()]
    Param(
        [Parameter(Position = 0, Mandatory = $true)]
        [ValidateScript({ Test-Path -LiteralPath $_ })]
        [String] $DirPath,

        [Parameter(Position = 1, Mandatory = $true)]
        [String] $FileRegExp,

        [Parameter(Position = 2, Mandatory = $true)]
        [Int] $StockQuantity
    )
    Process {
        $d = $null
        try {
            $d = Get-Item -LiteralPath "$DirPath"
        }
        catch {
            Write-Error $_
            exit 1
        }

        if (-not($d.PSIsContainer)) {
            Write-Error "$DirPath is not directory."
            exit 1
        }

        # Get files and sort by CreationTime
        $fs = Get-ChildItem -LiteralPath "$DirPath" | Sort-Object -Property CreationTime -Descending

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
Export-ModuleMember -Function Remove-FileBackedupInPast