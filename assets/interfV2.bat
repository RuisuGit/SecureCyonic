@echo off && chcp 65001 >nul && setlocal enabledelayedexpansion
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (set "DEL=%%a" & set "ESC=%%b")
mode 55,10
cls

::────────────────────────────────────────────────── CORES ──────────────────────────────────────────────────::


REM Formatação de texto
SET [Underline]=%ESC%[4m 
SET [Reset]=%ESC%[0m
SET [Bold]=%ESC%[1m

REM Cores escuras
SET [Vermelho]=%ESC%[31m
SET [Amarelo]=%ESC%[33m
SET [Branco]=%ESC%[37m
SET [Preto]=%ESC%[30m
SET [Verde]=%ESC%[32m
SET [Ciano]=%ESC%[36m
SET [Cinza]=%ESC%[90m
SET [Azul]=%ESC%[34m
SET [Roxo]=%ESC%[35m

REM Cores claras
SET [VermelhoCL]=%ESC%[91m
SET [AmareloCL]=%ESC%[93m
SET [BrancoCL]=%ESC%[97m
SET [VerdeCL]=%ESC%[92m
SET [CianoCL]=%ESC%[96m
SET [AzulCL]=%ESC%[94m
SET [RoxoCL]=%ESC%[95m


::────────────────────────────────────────────────── CARREGAMENTO ──────────────────────────────────────────────────::                                    

set "o_msg=%*"

if "%1"=="Error:" (
    goto :errormsg
)

if "%1"=="end" (
    goto :endfile
)

                                            :: credits for NightBox Duck

echo.
echo         %[Branco]%Quack!
echo       %[Amarelo]%_ %[Branco]%/
echo     %[Amarelo]%^>(%[Branco]%·%[Amarelo]%)___   %[Reset]% %[VerdeCL]%Running SecureCyonic %[Reset]%
echo      %[Amarelo]%(____/   [+] %o_msg%
echo. %[Reset]%
exit /b

:errormsg
echo.
echo         %[Branco]%Quack!
echo       %[Amarelo]%_ %[Branco]%/
echo     %[Amarelo]%^>(%[Branco]%·%[Amarelo]%)___   %[Reset]% %[Vermelho]%SecureCyonic Stopped! %[Reset]%
echo      %[Amarelo]%(____/   [-] %o_msg%
echo. %[Reset]%
timeout -t 2 /nobreak >nul
exit /b

:endfile
echo.
echo         %[Branco]%Quack!
echo       %[Amarelo]%_ %[Branco]%/
echo     %[Amarelo]%^>(%[Branco]%·%[Amarelo]%)___   %[Reset]% %[Vermelho]%       SecureCyonic Stopped! %[Reset]%
echo      %[Amarelo]%(____/   [-] Your session got ended by host 
echo                 %[Underline]%Thanks for using SecureCyonic %[Reset]%
echo. %[Reset]%
timeout -t 2 /nobreak >nul
exit /b