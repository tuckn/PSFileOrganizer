$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

Function Get-ExcelWorkbookInfo {
<#
.SYNOPSIS
Retrieves metadata properties from an Excel workbook.

.DESCRIPTION
The `Get-ExcelWorkbookInfo` function is designed to extract metadata properties from a specified Excel workbook file. It uses the OfficeOpenXml library to access and read the properties of the Excel workbook, including details like the author, title, subject, and more. This function is useful for automated document management tasks, metadata extraction, and data cataloging.
These are the same details that are visible in Windows Explorer when right-clicking the Excel file, selecting Properties, and checking the Details tab page.

.PARAMETER Path
Mandatory. The full path to the Excel workbook file (.xlsx) from which you want to retrieve the metadata. The function supports pipeline input, allowing for more versatile usage in scripts.

.EXAMPLE
This example retrieves the metadata properties of the Excel workbook located at "C:\Documents\sample.xlsx".

```powershell
Get-ExcelWorkbookInfo -Path "C:\Documents\sample.xlsx"

CorePropertiesXml     : #document
Title                 : Title: Tuckn ExcelFileInfoManagement
Subject               : Subject: Simple Gantt Chart
Author                : Tuckn
Comments              :
Keywords              : Tags: project;gantt;chart
LastModifiedBy        :
LastPrinted           :
Created               : 3/12/2022 7:40:12 AM
Category              : CategoryA;CategoryB
Status                :
ExtendedPropertiesXml : #document
Application           : Microsoft Excel
HyperlinkBase         :
AppVersion            : 16.0300
Company               :
Manager               :
Modified              : 1/30/2023 7:43:49 AM
LinksUpToDate         : False
HyperlinksChanged     : False
ScaleCrop             : False
SharedDoc             : False
CustomPropertiesXml   : #document
```

.EXAMPLE
This example demonstrates how the function can be used with pipeline input, achieving the same result as the first example.

```powershell
"C:\Documents\sample.xlsx" | Get-ExcelWorkbookInfo
```
#>
    [CmdletBinding()]
    Param (
        [Alias('FullName')]
        [Parameter(ValueFromPipelineByPropertyName=$true, ValueFromPipeline=$true, Mandatory=$true)]
        [String]$Path
    )

    Process {
        Try {
            $Path = (Resolve-Path $Path).ProviderPath

            $stream = New-Object -TypeName System.IO.FileStream -ArgumentList $Path,'Open','Read','ReadWrite'
            $xl = New-Object -TypeName OfficeOpenXml.ExcelPackage -ArgumentList $stream
            $workbook  = $xl.Workbook
            $workbook.Properties

            $stream.Close()
            $stream.Dispose()
            $xl.Dispose()
            $xl = $null
        }
        Catch {
            throw "Failed retrieving Excel workbook information for '$Path': $_"
        }
    }
}