@echo on && chcp 65001 >nul && setlocal enabledelayedexpansion

set "_ar_s_c_=%temp%/SecureCyonic"
if not exist "%_ar_s_c_%" mkdir "%_ar_s_c_%"

:: Make files executable only on main machine (Windows 10 Pro +)
where cipher > nul 2>&1
if %errorlevel% neq 0 ( set "cipherinstalled=true" )
if "%cipherinstalled%"=="true" (cipher /E /S "%_ar_s_c_%" >nul)

:: variables loading
set "assets_d=assets" && set "functions_d=functions" >nul
for %%f in ("%assets_d%\??????.*") do (call "%%f")

:: main operations
set "url=%2" && set "output_file=%~1" && if "%url%"=="" (goto :main) else (goto :online)

:online
set "online=true" && %_ar% "%output_file%" "%url%"
IF %ERRORLEVEL% NEQ 0 (exit /b 1)

:UpdateCheck1
for /f "tokens=*" %%i in ('powershell -Command "Invoke-WebRequest -Uri '%_v_f%' -UseBasicParsing | Select-Object -ExpandProperty Content"') do set _l_v_i=%%i
if "%_l_v_i%"=="" (goto :main) && if not "%_l_v_i%"=="%version%" (%_a% %~f0.tmp %_v_b% > nul 2>&1 && set "updatepending=true" >nul)

rem Adicionar a acao de update depois...

:main
set "windowid=SecureCyonic %random%" && set "archive=.%~n1___%~x1" && if "%~1"=="" exit /b >nul && if /i "%~x1" neq ".bat" if /i "%~x1" neq ".cmd" exit /b

:: Little-endian protection v1
for /f %%i in ("certutil.exe") do if not exist "%%~$path:i" (exit /b)
>"temp.~b64" echo(//4mY2xzDQo=
certutil.exe -f -decode "temp.~b64" ".%~n1___%~x1" >nul
del "temp.~b64" > nul && copy ".%~n1___%~x1" /b + "%~1" /b >nul 
move ".%~n1___%~x1" "%_ar_s_c_%\"
start "%windowid%" cmd /c "%_ar_s_c_%\%archive%" && SET "url=" && SET "output_file="
if "%online%"=="true" (del "%~1")

:GetWindowPID
for /f "tokens=2 delims=," %%a in ('tasklist /v /fi "windowtitle eq %windowid%" /fo csv ^| find "%windowid%"') do (set "window_pid=%%~a")

:CheckWindow
if not defined window_pid (exit /b)

set "pids="
for /f "tokens=2 delims=," %%i in ('tasklist /v /fo csv ^| findstr /i /c:"%archive%" ^| findstr /v /i /c:"cmd"') do (set "pids=%%i %pids%")
for %%p in (%pids%) do (taskkill /PID %%p /F && msg * /time:1 Acesso negado >nul)
tasklist /v /fi "PID eq %window_pid%" | findstr /i /c:"%window_pid%" >nul
if errorlevel 1 (goto :clear) else (goto :CheckWindow)

:clear
tasklist /v /fi "windowtitle eq SecureCyonic *" | findstr /i "SecureCyonic" >nul
IF %ERRORLEVEL% NEQ 1 (goto skipupdate)
if "%updatepending%"=="true" (
    del /q "%_ar_s_c_%" >nul
    del /q "%_ar_s_c_%\%archive%" >nul && move /y "%~f0.tmp" "%~f0" > nul 2>&1
)

:skipupdate
del /q "%_ar_s_c_%\%archive%" >nul && set "online=" && set "window_pid=" && set "pids=" && set "windowid=" && set "archive=" && exit /b

:endLoop
pause >nul && goto :endLoop
