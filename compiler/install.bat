@echo off

echo Initializing Elypso Compiler Installer...
echo.

if NOT "%~1"=="" if NOT "%~1"=="skipwait" (
    echo [ERROR] Invalid first parameter! Leave empty or use 'skipwait'.
    pause
    exit /b 1
)

:: Root paths
set "origin=%~dp0"
set "input=Elypso-compiler-x64-release-windows"
set "output=Elypso-compiler-x64-release-windows.7z"

:: Assigned paths
set "release_compiler=%origin%\..\..\Elypso-compiler\out\build\x64-release"
set "changes=%origin%\..\..\Elypso-compiler\CHANGES.txt"

:: Resolve paths before checking if they are valid
for /f "delims=" %%i in ("%release_compiler%") do set "release_compiler=%%~fi"
for /f "delims=" %%i in ("%changes%") do set "changes=%%~fi"

:: Check if assigned paths are valid
if not exist "%release_compiler%" (
	echo Error: Elypso compiler release path '%release_compiler%' is not a valid path!
	pause
	exit /b 1
) else (
	echo Success: Found Elypso compiler release path!
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

:: Paste elypso compiler content into target
xcopy "%release_compiler%" ".\" /E /I /Y >nul
echo Copied elypso compiler release files to 'target'.

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

:: Rename target to Elypso-compiler-x64-release-windows
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