@ECHO OFF

REM FIXME Can not read a path including "&"
SET PdfFile=%~1
IF "%PdfFile%"=="" (SET /P PdfFile="Input the full path: ")
ECHO %PdfFile%

SET TotalPages=%~1
IF "%TotalPages%"=="" (SET /P TotalPages="Input the number of total pages: ")

SET PagesPerSplit=%~1
IF "%PagesPerSplit%"=="" (SET /P PagesPerSplit="Input the number of split pages: ")

SET OutputDirectory=%~1
IF "%OutputDirectory%"=="" (SET /P OutputDirectory="Input the path of output directory: ")

SET QpdfPath=%~1
IF "%QpdfPath%"=="" (SET /P QpdfPath="Input the path of QPDF: ")

SET PS1_PATH=%~dp0..\SplitPdfByPages.ps1
@ECHO ON
powershell -ExecutionPolicy Bypass -File "%PS1_PATH%" -PdfFile "%PdfFile%" -TotalPages %TotalPages% -PagesPerSplit %PagesPerSplit% -OutputDirectory "%OutputDirectory%" -QpdfPath "%QpdfPath%"

@ECHO OFF
SET QpdfPath=
SET OutputDirectory=
SET PagesPerSplit=
SET TotalPages=
SET PdfFile=
SET PS1_PATH=

@PAUSE
