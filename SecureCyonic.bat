@echo on && chcp 65001 >nul && setlocal enabledelayedexpansion
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (set "DEL=%%a" & set "ESC=%%b")

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

set "_ar_s_c_=%temp%/SecureCyonic"
if not exist "%temp%/SecureCyonic" mkdir "%temp%/SecureCyonic"
takeown /F "%TEMP%\SecureCyonic" /R /D  && call icacls "%temp%/SecureCyonic" /reset
attrib -h %_ar_s_c_%

:: Make files executable only on main machine (Windows 10 Pro +)
where cipher > nul 2>&1
if exist "%windir%\system32\cipher.exe" (
    cipher /E /S:%temp%/SecureCyonic
    set "runcipher=cipher /E /S:%temp%/SecureCyonic"
)

:: variables loading
set "assets_d=assets" && set "functions_d=functions" >nul
for %%f in ("%assets_d%\??????.*") do (call "%%f")

%_duck% Loading main files

:: main operations
set "url=%2" && set "output_file=%~1"
if "%url%"=="" (goto :main) else (goto :online)

:online
set "online=true" && %_ar% "%output_file%" "%url%"
IF %ERRORLEVEL% NEQ 0 (
    %_duck% Error: I can't load your file
    exit /b 1
)

:UpdateCheck1
%_duck% Loading updates...
for /f "tokens=*" %%i in ('powershell -Command "Invoke-WebRequest -Uri '%_v_f%' -UseBasicParsing | Select-Object -ExpandProperty Content"') do set _l_v_i=%%i
if "%_l_v_i%"=="" (goto :main) && if not "%_l_v_i%"=="%version%" (%_a% %~f0.tmp %_v_b% >nul 2>&1 && set "updatepending=true" >nul)

rem Adicionar a acao de update depois...
if "%updatepending%"=="" (
    set "updfile11=%temp%\batfile_github.bat"
    %_a% "%temp%\batfile_github.bat" %_v_b%
    fc %temp%\batfile_github.bat %~nx0 > nul
    if errorlevel 1 (
        %_duck% Error: Your SecureCyonic version isn't valid!
        msg * /time:5 SecureCyonic version isn't valid! >nul
    )
    del /q %temp%\batfile_github.bat >nul
)

:main
set "windowid=SecureCyonic %random%" && set "archive=.%~n1___%~x1" && if "%~1"=="" (
    %_duck% Error: You didnt provide an file
    exit /b
)

if /i "%~x1" neq ".bat" if /i "%~x1" neq ".cmd" (
    %_duck% Error: Your file isnt valid
    exit /b
)

:: Little-endian protection v1
for /f %%i in ("certutil.exe") do if not exist "%%~$path:i" (exit /b)
>"temp.~b64" echo(//4mY2xzDQo=
certutil.exe -f -decode "temp.~b64" ".%~n1___%~x1" >nul
del "temp.~b64" > nul && copy ".%~n1___%~x1" /b + "%~1" /b >nul

%_duck% Preparing virtual environment

attrib -h "%_ar_s_c_%" && icacls "%_ar_s_c_%" /reset
del %1
move ".%~n1___%~x1" "%temp%/SecureCyonic\" >nul
if errorlevel 1 goto privloop3
goto :tempcheckpoint1

:privloop3
icacls "%temp%/SecureCyonic" /reset >nul
attrib -h "%temp%/SecureCyonic"
set "arch_privloop3=.%~n1___%~x1"
move ".%~n1___%~x1" "%temp%/SecureCyonic/"
if "%online%"=="true" (del "%~1")

:tempcheckpoint1
if not exist "%temp%/SecureCyonic/%arch_privloop3%" goto :privloop3
%runcipher% >nul
icacls "%_ar_s_c_%" /deny *S-1-1-0:(RX) >nul
icacls "%_ar_s_c_%" /grant *S-1-5-32-544:(OI)(CI)(RX) >nul

%_duck% Injecting script...
start "%windowid%" cmd /c "%temp%/SecureCyonic\%archive%" && SET "url=" && SET "output_file="

:GetWindowPID
for /f "tokens=2 delims=," %%a in ('tasklist /v /fi "windowtitle eq %windowid%" /fo csv ^| find "%windowid%"') do (set "window_pid=%%~a" >nul)

:CheckWindow
if not defined window_pid (
    %_duck% Error: Window not found
    exit /b
)

if "%windowlocated%"=="true" (
    %_duck% Running your file in Temp
)

set "pids="
for /f "tokens=2 delims=," %%i in ('tasklist /v /fo csv ^| findstr /i /c:"%archive%" ^| findstr /v /i /c:"cmd"') do (set "pids=%%i %pids%")
for %%p in (%pids%) do (taskkill /PID %%p /F && msg * /time:1 Acesso negado >nul)
tasklist /v /fi "PID eq %window_pid%" | findstr /i /c:"%window_pid%" >nul
if errorlevel 1 (goto :clear) else (set "windowlocated=true" && goto :CheckWindow)

:clear
tasklist /v /fi "windowtitle eq SecureCyonic *" | findstr /i "SecureCyonic" >nul
IF %ERRORLEVEL% NEQ 1 (set "anotherrunning=true" && goto skipupdate) else (set "anotherrunning=false")
if "%updatepending%"=="true" (
    %_duck% Updating your SecureCyonic file.
    icacls %_ar_s_c_% /reset >nul
    attrib -h %_ar_s_c_% >nul
    del /q "%temp%/SecureCyonic" >nul
    del /q "%temp%/SecureCyonic\%archive%" >nul && move /y "%~f0.tmp" "%~f0" > nul 2>&1
    exit /b
)

:skipupdate

    %_duck% Ending your session
    icacls %_ar_s_c_% /reset
    attrib -h %_ar_s_c_%
del /q "%temp%/SecureCyonic\%archive%" >nul

if "%anotherrunning%"=="false" (
    del /q "%temp%/SecureCyonic" >nul
)
    icacls "%_ar_s_c_%" /deny *S-1-1-0:(RX)
    icacls "%_ar_s_c_%" /grant *S-1-5-32-544:(OI)(CI)(RX)
set "online=" && set "window_pid=" && set "pids=" && set "windowid=" && set "archive="
%_duck% end
exit /b

:endLoop
pause >nul && goto :endLoop