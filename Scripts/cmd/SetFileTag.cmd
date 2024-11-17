@ECHO OFF

REM FIXME Can not read a path including "&"
SET FilePath=%~1
IF "%FilePath%"=="" (SET /P FilePath="Input the full path: ")

SET Tag=%~1
IF "%Tag%"=="" (SET /P Tag="Input a tag: ")

SET PS1_PATH=%~dp0..\ManageFileTags.ps1
@ECHO ON
powershell -ExecutionPolicy Bypass -File "%PS1_PATH%" -FilePath "%FilePath%" -Tag "%Tag%"

@ECHO OFF
SET FilePath=
SET PS1_PATH=

@PAUSE
