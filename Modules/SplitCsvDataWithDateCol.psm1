# using module "..\GetDateTimeFromFileName\GetDateTimeFromFileName.psm1"
using namespace System.Collections.Generic # PowerShell 5

# $ErrorActionPreference = "Stop"
$ErrorActionPreference = "Continue"
Set-StrictMode -Version 2.0

function Split-CsvDataWithDateCol {
<#
.SYNOPSIS
Splits a CSV file into multiple files based on a specified date column.

.DESCRIPTION
The `Split-CsvDataWithDateCol` function is designed to process a CSV file and split its data into separate CSV files based on the values in a specified date column. This function is particularly useful for organizing large CSV files into smaller, date-segmented files for easier analysis and management. Each output file is named with the date segment and saved in a designated destination folder.

.PARAMETER FilePath
Mandatory. Specifies the full path of the CSV file that needs to be split. The script checks if the file exists at this path.

.PARAMETER ColumnName
Mandatory. The name of the column in the CSV file which contains date information. This column is used as the basis for splitting the data.

.PARAMETER DestFolder
Optional. The destination folder where the split CSV files will be saved. If not specified, the files are saved in the same folder as the source CSV file.

.EXAMPLE
```powershell
Split-CsvDataWithDateCol -FilePath "C:\Data\sales_data.csv" -ColumnName "SaleDate"
```

This example takes a CSV file "sales_data.csv" and splits its contents into multiple CSV files based on the "SaleDate" column. Each resulting file contains data for a specific month and year, and is saved in the same directory as the source file.
#>
    [CmdletBinding()]
    Param(
        [Parameter(Position = 0, Mandatory = $true)]
        [ValidateScript({ Test-Path -LiteralPath $_ })]
        [String] $FilePath,

        [Parameter(Position = 1, Mandatory = $true)]
        [String] $ColumnName,

        [Parameter(Position = 2)]
        [String] $DestFolder = (Split-Path -Parent $FilePath)
    )
    Process {
        Write-Host $FilePath
        Write-Host $ColumnName

        # Raad the CSV file
        $csvObj = $null
        try {
            $csvObj = Import-Csv -LiteralPath $FilePath -Encoding UTF8
            # $csvObj | Format-Table # debug
        }
        catch {
            Write-Error $_
            exit 1
        }

        # Split with date column
        $splitedObj = @{}

        foreach ($row in $csvObj) {
            try {
                $dateStr = $row.$ColumnName
                if ($dateStr -match '(\d{4})/(\d{2})') {
                    $yearMonth = $Matches[1] + $Matches[2]

                    if (-not($splitedObj.ContainsKey($yearMonth))) {
                        $splitedObj.$yearMonth = [List[PSCustomObject]]::new()
                    }

                    $splitedObj.$yearMonth.Add($row)
                }
                else {
                    Write-Error "$dateStr is not matched with (\d{4})/(\d{2})"
                }
            }
            catch {
                Write-Error $_
            }
        }

        # Write splited data into file
        foreach ($keyName in $splitedObj.Keys) {
            try {
                # Create destination folder
                $yearDir = Join-Path -Path $DestFolder -ChildPath $keyName.Substring(0, 4)
                [System.IO.Directory]::CreateDirectory($yearDir)

                $csvPath = Join-Path -Path $yearDir -ChildPath "$keyName.csv"
                $splitedObj.$keyName | Export-Csv -NoTypeInformation $csvPath -Encoding UTF8
            }
            catch {
                Write-Error $_
            }
        }

        return
    }
}
Export-ModuleMember -Function Split-CsvDataWithDateCol