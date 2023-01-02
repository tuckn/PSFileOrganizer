@ECHO OFF

REM FIXME Can not read a path including "&"
REM SET FilePath=%~1
REM IF "%FilePath%"=="" (SET /P FilePath="Input the full path: ")

SET FilePath=%1
REM ECHO %FilePath%

SET PS1_PATH=%~dp0Run.ps1
@ECHO ON
powershell -ExecutionPolicy Bypass -File "%PS1_PATH%" -FilePath %FilePath% -DateFormat "yyyyMMddThhmmss+0900_" -OriginalName "Post"

@ECHO OFF
SET FilePath=
SET PS1_PATH=

@PAUSE
