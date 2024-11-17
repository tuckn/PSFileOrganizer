@ECHO OFF

REM FIXME Can not read a path including "&"
SET FilePath=%~1
IF "%FilePath%"=="" (SET /P FilePath="Input the full path: ")

SET PS1_PATH=%~dp0..\ManageFileTags.ps1
@ECHO ON
powershell -ExecutionPolicy Bypass -File "%PS1_PATH%" -FilePath "%FilePath%" -ClearAllTags

@ECHO OFF
SET FilePath=
SET PS1_PATH=

@PAUSE
