@ECHO OFF

REM | One-click Windows DNS applier script
REM | Copyright (C) 2021, AdKillerDNS.eu

TITLE AdKillerDNS.eu DNS applier
MODE 45,13

COPY INADKDNS.CMD "%TEMP%\INADKDNS.CMD"
CALL "%TEMP%\INADKDNS.CMD"
EXIT /B