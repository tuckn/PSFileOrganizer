$ErrorActionPreference = "Continue"
Set-StrictMode -Version 2.0

function Split-PdfByPages {
<#
.SYNOPSIS
Splits a PDF file into multiple smaller PDF files, each containing a specified number of pages.

.DESCRIPTION
This function takes a large PDF file and splits it into smaller PDF files, each containing the specified number of pages. It uses QPDF for the splitting process. The function allows specifying an input PDF file, the total number of pages, the number of pages to include in each split file, the output directory, and the path to the QPDF executable. If no output directory is specified, the current directory is used. If no QPDF path is specified, the function assumes that QPDF is available in the system's PATH.

.PARAMETER PdfFile
The path to the input PDF file that needs to be split.

.PARAMETER TotalPages
The total number of pages in the PDF file.

.PARAMETER PagesPerSplit
The number of pages to include in each split PDF file.

.PARAMETER OutputDirectory
(Optional) The directory where the split PDF files will be saved. If not specified, the current directory is used.

.PARAMETER QpdfPath
(Optional) The path to the QPDF executable. If not specified, the function assumes that QPDF is available in the system's PATH.

.EXAMPLE
Split-PdfByPages -PdfFile "input.pdf" -TotalPages 442 -PagesPerSplit 2 -OutputDirectory "C:\output" -QpdfPath "C:\Program Files\qpdf\bin\qpdf.exe"

Splits the "input.pdf" file into multiple PDF files, each containing 2 pages, and saves them in the "C:\output" directory.

#>
    [CmdletBinding()]
    Param(
        [Parameter(Position = 0, Mandatory = $true)]
        [ValidateScript({ Test-Path -LiteralPath $_ })]
        [String] $PdfFile,

        [Parameter(Position = 1, Mandatory = $true)]
        [int] $TotalPages,

        [Parameter(Position = 2, Mandatory = $true)]
        [int] $PagesPerSplit,

        [Parameter(Position = 3)]
        [String] $OutputDirectory = (Get-Location),

        [Parameter(Position = 4)]
        [String] $QpdfPath = "qpdf"
    )
    Process {
        # # Debug
        # Write-Output "PdfFile: $PdfFile"
        # Write-Output "TotalPages: $TotalPages"
        # Write-Output "PagesPerSplit: $PagesPerSplit"
        # Write-Output "OutputDirectory: $OutputDirectory"
        # Write-Output "QpdfPath: $QpdfPath"

        if (-not (Test-Path -LiteralPath $OutputDirectory)) {
            New-Item -ItemType Directory -Path $OutputDirectory
        }

        for ($i = 1; $i -le $TotalPages; $i += $PagesPerSplit) {
            $outputFile = Join-Path -Path $OutputDirectory -ChildPath "split_$((($i - 1) / $PagesPerSplit) + 1).pdf"
            $endPage = [math]::Min($i + $PagesPerSplit - 1, $TotalPages)

            $arguments = @(
                $PdfFile
                "--pages"
                "."
                "$i-$endPage"
                "--"
                $outputFile
            )

            try {
                Start-Process -FilePath $QpdfPath -ArgumentList $arguments -NoNewWindow -Wait
                Write-Output "Created: $outputFile"
            }
            catch {
                Write-Error "Failed to split PDF file: $($_.Exception.Message)"
                exit 1
            }
        }
    }
}

Export-ModuleMember -Function Split-PdfByPages