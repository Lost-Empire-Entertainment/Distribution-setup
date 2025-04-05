@echo off

echo Initializing Full Installer...
echo.

set "origin=%~dp0"
set "engine=%origin%\engine\install.bat"
set "hub=%origin%\hub\install.bat"

:: Resolve paths before checking if they are valid
for /f "delims=" %%i in ("%engine%") do set "engine=%%~fi"
for /f "delims=" %%i in ("%hub%") do set "hub=%%~fi"

:: Check if assigned paths are valid
if not exist "%engine%" (
	echo Error: Engine installer path '%engine%' is not a valid path!
	pause
	exit /b 1
) else (
	echo Success: Found engine installer!
)
if not exist "%hub%" (
	echo Error: Hub installer path '%hub%' is not a valid path!
	pause
	exit /b 1
) else (
	echo Success: Found hub installer!
)

echo.
echo ====================================================
echo Initialize succeeded!
echo ====================================================
echo.

:: Install engine
call "%engine%" skipwait
if %errorlevel% neq 0 (
    echo Error: Engine installation failed!
	pause
    exit /b %errorlevel%
)

:: Install hub
call "%hub%" skipwait
if %errorlevel% neq 0 (
    echo Error: Hub installation failed!
	pause
    exit /b %errorlevel%
)

echo.
echo ====================================================
echo Full install succeeded!
echo ====================================================
echo.

pause
exit /b 0