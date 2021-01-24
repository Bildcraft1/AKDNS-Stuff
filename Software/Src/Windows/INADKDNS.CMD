@ECHO OFF

REM | One-click Windows DNS applier script
REM | Copyright (C) 2021, AdKillerDNS.eu

TITLE AdKillerDNS.eu DNS applier
MODE 45,13
SET ServerPrimary=194.15.36.210

REM <-- Check for admin privileges, prompt for elevation if necessary -->
NET SESSION > NUL 2>&1
IF %ERRORLEVEL% EQU 0 (
    GOTO GotAdmin
) ELSE (
    GOTO AskAdmin
)

REM <-- Prompt for privilege elevation -->
:AskAdmin
    CLS
    ECHO.
    ECHO.
    ECHO        ###############################
    ECHO          AdKillerDNS.eu  DNS Applier
    ECHO        ###############################
    ECHO.
    ECHO.
    ECHO    Prompting to get privilege elevation...

    REM --> https://stackoverflow.com/questions/1894967/how-to-request-administrator-access-inside-a-batch-file#10052222
    ECHO Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    SET params= %*
    ECHO UAC.ShellExecute "CMD.EXE", "/C ""%~s0"" %params:"=""%", "", "runas", 1 >> "%TEMP%\getadmin.vbs"
    "%TEMP%\getadmin.vbs"
    DEL "%TEMP%\getadmin.vbs"
    EXIT /B

REM <-- Main program routine, only running when admin privileges are granted -->
:GotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
    CLS
    ECHO.
    ECHO.
    ECHO        ###############################
    ECHO          AdKillerDNS.eu  DNS Applier
    ECHO        ###############################
    ECHO.
    ECHO.
    ECHO   Applying DNS to all network interfaces...

    REM --> https://stackoverflow.com/questions/42653754/how-to-get-and-use-network-adapter-name#42654438
    FOR /F "skip=3 tokens=1,2,3* delims= " %%G in ('NETSH INTERFACE SHOW INTERFACE') DO (
        NETSH INTERFACE IPV4 SET DNSSERVERS "%%J" STATIC %ServerPrimary% PRIMARY NO > NUL 2>&1
        NETSH INTERFACE IPV6 DELETE DNSSERVERS "%%J" ALL > NUL 2>&1
    )

    ECHO.
    ECHO                     DONE!
    ECHO           Press any key to close...
    PAUSE > NUL
    DEL "%TEMP%\INADKDNS.CMD"
    EXIT /B
