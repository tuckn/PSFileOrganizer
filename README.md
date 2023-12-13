# PowerShell File Management Utilities

This repository contains a collection of PowerShell cmdlets designed to streamline various file management tasks. These utilities offer a wide range of functionality, from modifying file properties based on their names to organizing files in a more structured manner. Whether you're dealing with routine file organization or need to automate complex file operations, these cmdlets are here to simplify your workflow.

## Modules

### Get-DateCodeFromFile

Generates a date code from a file's creation or last write time.

```powershell
Get-DateCodeFromFile -FilePath "C:\path\to\file.png"
Created:  2018/11/15 19:44:01
Modified: 2021/12/31 18:22:21
20181115T194401
```

This example generates a date code for the specified file using the default date format ("yyyyMMddTHHmmss").

You can display help with the following command.

```powershell
Get-Help -Name Get-DateCodeFromFile -Full
```

### Get-DateTimeFromStr

Extracts a datetime object from a string based on specific formatting patterns.

```powershell
Get-DateTimeFromStr -Str "20181115T194401_myphoto.jpg"
yyyy: 2018
MM: 11
dd: 15
hh: 19
mm: 44
ss: 01
[OK] It's the correct date string

2018年11月15日 19:44:01
```

You can display help with the following command.

```powershell
Get-Help -Name Get-DateTimeFromStr -Full
```

### Get-DateTimeFromFileName

Extracts a datetime object from a file's name.

```powershell
Get-DateTimeFromFileName -FilePath "C:\path\to\file_20210123.txt" -UnknownDayAs "01" -UnknownTimeAs "00:00"
yyyy: 2021
MM: 01
dd: 23
hh: 00
mm: 00
ss: 00
[OK] It's the correct date string

2021年01月23日 00:00:00
```

In this example, the function is used to extract the date and time from the file name "file_20210101.txt". If the day or time portions are missing or unclear, it defaults them to the first day of the month and midnight, respectively.

You can display help with the following command.

```powershell
Get-Help -Name Get-DateTimeFromFileName -Full
```

### Edit-FileCreationTimeFromName

Edits the creation time of a file based on its name.

```powershell
(Get-Item -LiteralPath "C:\path\to\20181115T194401_myphoto.jpg").CreationTime
2021年1月1日 11:15:14

Edit-FileCreationTimeFromName -FilePath "C:path\to\20181115T194401_myphoto.jpg"
...
..
(Get-Item -LiteralPath "C:path\to\20181115T194401_myphoto.jpg").CreationTime
2018年11月15日 19:44:01
```

In this example, the function takes the file located at "C:\path\to\20181115T194401_myphoto.jpg", extracts the date from the file name, and sets that date as the file's creation time.

You can display help with the following command.

```powershell
Get-Help -Name Edit-FileCreationTimeFromName -Full
```

### Get-ExcelWorkbookInfo

Retrieves metadata properties from an Excel workbook.

```powershell
Get-ExcelWorkbookInfo -Path "C:\Documents\Simple Gantt Chart1.xlsx"

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

You can display help with the following command.

```powershell
Get-Help -Name Get-ExcelWorkbookInfo -Full
```

### Get-FirstMatchedFile

Gets the first file in a specified folder that matches a given regular expression pattern.

```powershell
Get-FirstMatchedFile -FolderPath "C:\Documents" -RegExpPattern "^Report.*\.txt$"
```

This example searches the "C:\Documents" folder for the first file whose name starts with "Report" and ends with ".txt", and then returns this file object.

You can display help with the following command.

```powershell
Get-Help -Name Get-FirstMatchedFile -Full
```

### Move-FileIntoDateFolder

Automatically moves files into folders based on a date extracted from their file names.

```powershell
Move-FileIntoDateFolder -FilePath "C:\Documents\Report_20210601.xlsx" -SplitFormat "yyyy/MM" -DestBaseDirPath "C:\ArchivedReports"
```

This example moves the file named "Report_20210601.xlsx" from "C:\Documents" to a new or existing folder within "C:\ArchivedReports\2021\06". The folder name is derived from the date in the file's name, using the specified split format.

You can display help with the following command.

```powershell
Get-Help -Name Move-FileIntoDateFolder -Full
```

If you want to apply this process to multiple files in a folder at once, please refer to `.\Scripts\MoveFilesIntoDateFolder.ps1` etc.

```powershell
Move-FileIntoDateFolder -FilePath "C:\YourFolder" -MatchedName "*.png"
```

### Remove-OldBackupFiles

Removes backup files from a specified directory based on a regular expression and retention count.

```powershell
Remove-OldBackupFiles -DirPath "C:\MyBackupDir" -FileRegExp "^backup_\d{8}\.zip" -StockQuantity 5
```

In this example, the function will process files in the "C:\MyBackupDir" directory. It will retain the five most recent files (based on creation time) that match the regular expression `backup_\d{8}\.zip` (which corresponds to files named like "backup_YYYYMMDD.zip") and will delete any additional files matching the pattern.

You can display help with the following command.

```powershell
Get-Help -Name Remove-OldBackupFiles -Full
```

### Rename-FileWithDateCode

Renames a file by incorporating a date code into its name.

```powershell
Rename-FileWithDateCode -FilePath "C:\myphoto.jpg"
# Rename myphoto.jpg to 20181115T194401_myphoto.jpg
```

```powershell
Rename-FileWithDateCode -FilePath "C:\myphoto.jpg" -DateFormat "[yyyy-MM-dd] " -OriginalName "Post"
# Reneme myphoto.jpg to [2018-11-15] myphoto.jpg
```

You can display help with the following command.

```powershell
Get-Help -Name Rename-FileWithDateCode -Full
```

### Set-FileDateCodeToClipboard

Copies a date code generated from a file's timestamp to the clipboard.

This example generates a date code from the specified file's timestamp using the default date format ("yyyyMMddTHHmmss") and copies the date code to the clipboard.

```powershell
Set-FileDateCodeToClipboard -FilePath "C:\path\to\file.txt"
```

You can display help with the following command.

```powershell
Get-Help -Name Set-FileDateCodeToClipboard -Full
```

### Split-CsvDataWithDateCol

Splits a CSV file into multiple files based on a specified date column.

```powershell
Split-CsvDataWithDateCol -FilePath "C:\Data\sales_data.csv" -ColumnName "SaleDate"
```

This example takes a CSV file "sales_data.csv" and splits its contents into multiple CSV files based on the "SaleDate" column. Each resulting file contains data for a specific month and year and is saved in the same directory as the source file.

You can display help with the following command.

```powershell
Get-Help -Name Split-CsvDataWithDateCol -Full
```

## How to use

(1) Download this repository as ZIP and extract it to your preferred folder, or clone it using the command below.

```powershell
git clone https://github.com/tuckn/PSFileOrganizer.git
```

(2) Execute the following command in PowerShell to import this module.

```powershell
Import-Module -Name
"C:\Path\To\PSFileOrganizer\PSFileOrganizer.psm1" -Verbose
````

If an error occurs, run the following command and try the `Import-Module` cmdlet again.

```powershell
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
````

(3) Now you can use the various Modules cmdlets of PSFileOrganizer.

You can also run scripts directly from `.ps1` files in the `.\Scripts` folder without using `Import-Module`.

In environments where ps1 script execution is restricted, you can run it from the `.cmd` file in the `.\Scripts\cmd` folder.

Furthermore, by registering this command in the registry, you can call it from right-click on Explorer.
A sample `.reg` for registry registration is in the `.\Scripts\reg` folder.
