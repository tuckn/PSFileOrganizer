@ECHO OFF

SET FilePath=%~1
IF "%FilePath%"=="" (SET /P FilePath="Input the full path: ")

SET PS1_PATH=%~dp0\Run.ps1
@ECHO ON
powershell -ExecutionPolicy Bypass -File "%PS1_PATH%" -FilePath "%FilePath%"

@ECHO OFF
SET FilePath=
SET PS1_PATH=

@PAUSE
