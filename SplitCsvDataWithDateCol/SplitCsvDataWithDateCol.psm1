# using module "..\GetDateTimeFromFileName\GetDateTimeFromFileName.psm1"
using namespace System.Collections.Generic

<#
.Synopsis
Split CSV data with a date column and write a new CSV file into a date folder.

.Description


.Parameter FilePath
The CSV file path. It's need the file containing a date column.

.Parameter ColumnName
The column name in the CSV file. It's need date type.

.Parameter DestFolder
A folder path used as a destination for splited data.

.Example
PS> Split-CsvDataWithDateCol -FilePath "C:\data.csv"
...
..
PS >

#>
# $ErrorActionPreference = "Stop"
$ErrorActionPreference = "Continue"
Set-StrictMode -Version 2.0

function Split-CsvDataWithDateCol {
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
            $csvObj = Import-Csv -Path $FilePath -Encoding UTF8
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