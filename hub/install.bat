@echo off

echo Initializing Elypso Hub Installer...
echo.

if NOT "%~1"=="" if NOT "%~1"=="skipwait" (
    echo [ERROR] Invalid first parameter! Leave empty or use 'skipwait'.
    pause
    exit /b 1
)

:: Root paths
set "origin=%~dp0"
set "input=Elypso-hub-x64-release-windows"
set "output=Elypso-hub-x64-release-windows.7z"

:: Assigned paths
set "release_hub=%origin%\..\..\Elypso-hub\build-release"
set "changes=%origin%\..\..\Elypso-hub\CHANGES.txt"

:: Resolve paths before checking if they are valid
for /f "delims=" %%i in ("%release_hub%") do set "release_hub=%%~fi"
for /f "delims=" %%i in ("%changes%") do set "changes=%%~fi"

:: Check if assigned paths are valid
if not exist "%release_hub%" (
	echo Error: Elypso hub release path '%release_hub%' is not a valid path!
	pause
	exit /b 1
) else (
	echo Success: Found Elypso hub release path!
)
if not exist "%changes%" (
	echo Error: Changes file path '%changes%' is not a valid path!
	pause
	exit /b 1
) else (
	echo Success: Found changes file!
)

echo.
echo ====================================================
echo Initialize succeeded!
echo ====================================================
echo.

cd /d "%origin%"

if exist "%output%" (
	del /f /q "%output%"
	echo Deleted old 7z package.
	echo.
)

:: Delete old target and create new one
if exist "target" (
	rd /s /q "target"
	echo Removed folder 'target'.
)
mkdir "target"

echo.

cd /d "target"

:: Paste elypso hub content into target
xcopy "%release_hub%" ".\" /E /I /Y >nul
echo Copied elypso hub release files to 'target'.

:: Paste changes file into target
copy "%changes%" ".\" /Y >nul
echo Copied changes file to 'target'.

:: Delete useless files from target folder
if exist "CMakeFiles" (
	rmdir /s /q "CMakeFiles"
)
if exist ".ninja_deps" (
	del /f /q ".ninja_deps"
)
if exist ".ninja_log" (
	del /f /q ".ninja_log"
)
if exist "build.ninja" (
	del /f /q "build.ninja"
)
if exist "cmake_install.cmake" (
	del /f /q "cmake_install.cmake"
)
if exist "CMakeCache.txt" (
	del /f /q "CMakeCache.txt"
)
if exist "CPackConfig.cmake" (
	del /f /q "CPackConfig.cmake"
)
if exist "CPackSourceConfig.cmake" (
	del /f /q "CPackSourceConfig.cmake"
)
echo Cleaned up 'target'.

echo.

cd /d ..\

:: Rename target to Elypso-hub-x64-release-windows
ren "target" "%input%"
echo Renamed 'target' to '%input%'.
 
echo.
echo ====================================================
echo Setup succeeded!
echo ====================================================
echo.

echo Starting to compress '%input%'.
echo.
"7z.exe" a -t7z "%output%" "%input%" -mx9

rmdir /s /q "%input%"

echo.
echo ====================================================
echo Folder successfully compressed to 7z file!
echo ====================================================
echo.

if not "%~1"=="skipwait" pause
exit /b 0