@ECHO OFF

SET DirPath=%1
REM ECHO %DirPath%

SET FileRegExp=%2
SET StockQuantity=%3

SET PS1_PATH=%~dp0..\RemoveOldBackupFiles.ps1
@ECHO ON
powershell -ExecutionPolicy Bypass -File "%PS1_PATH%" -DirPath %DirPath% -FileRegExp FileRegExp -StockQuantity StockQuantity

@ECHO OFF
SET DirPath=
SET FileRegExp=
SET StockQuantity=
SET PS1_PATH=

@PAUSE
