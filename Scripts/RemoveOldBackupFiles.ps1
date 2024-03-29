﻿using module "..\Modules\RemoveOldBackupFiles.psm1"

Param(
    [Parameter(Position = 0, Mandatory = $true)]
    [ValidateScript({ Test-Path -LiteralPath $_ })]
    [String] $DirPath,

    [Parameter(Position = 1, Mandatory = $true)]
    [String] $FileRegExp,

    [Parameter(Position = 2, Mandatory = $true)]
    [Int] $StockQuantity
)

Remove-OldBackupFiles -DirPath $DirPath -FileRegExp $FileRegExp -StockQuantity $StockQuantity
