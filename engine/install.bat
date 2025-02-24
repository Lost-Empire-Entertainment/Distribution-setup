@echo off

echo Initializing Elypso Engine Installer...
echo.

if NOT "%~1"=="" if NOT "%~1"=="skipwait" (
    echo [ERROR] Invalid first parameter! Leave empty or use 'skipwait'.
    pause
    exit /b 1
)

:: Root paths
set "origin=%~dp0"
set "input=Elypso-engine-x64-release-windows"
set "output=Elypso-engine-x64-release-windows.7z"

:: Assigned paths
set "engine=%origin%\..\..\Elypso-engine\Engine"
set "engine_lib=%engine%\..\Engine library\out\build\x64-release\Elypso engine.lib"
set "external_shared=%engine%\..\_external_shared"
set "include=%engine%\include"
set "release_engine=%engine%\out\build\x64-release"
set "release_hub=%origin%\..\..\Elypso-hub\out\build\x64-release"
set "source_game=%origin%\..\..\Elypso-engine\Game"

:: Individual files
set "win_prerequisites_txt=%engine%\..\Windows_prerequisites.txt"
set "win_prerequisites_7z=%engine%\..\Windows_prerequisites.7z"
set "readme=%engine%\..\README.md"
set "license=%engine%\..\LICENSE.md"
set "libraries=%engine%\..\LIBRARIES.md"
set "security=%engine%\..\SECURITY.md"
set "changes=%engine%\..\CHANGES.txt"

:: Resolve paths before checking if they are valid
for /f "delims=" %%i in ("%engine%") do set "engine=%%~fi"
for /f "delims=" %%i in ("%engine_lib%") do set "engine_lib=%%~fi"
for /f "delims=" %%i in ("%external_shared%") do set "external_shared=%%~fi"
for /f "delims=" %%i in ("%include%") do set "include=%%~fi"
for /f "delims=" %%i in ("%release_engine%") do set "release_engine=%%~fi"
for /f "delims=" %%i in ("%release_hub%") do set "release_hub=%%~fi"
for /f "delims=" %%i in ("%source_game%") do set "source_game=%%~fi"

for /f "delims=" %%i in ("%win_prerequisites_txt%") do set "win_prerequisites_txt=%%~fi"
for /f "delims=" %%i in ("%win_prerequisites_7z%") do set "win_prerequisites_7z=%%~fi"
for /f "delims=" %%i in ("%readme%") do set "readme=%%~fi"
for /f "delims=" %%i in ("%license%") do set "license=%%~fi"
for /f "delims=" %%i in ("%libraries%") do set "libraries=%%~fi"
for /f "delims=" %%i in ("%security%") do set "security=%%~fi"
for /f "delims=" %%i in ("%changes%") do set "changes=%%~fi"

:: Check if assigned paths are valid
if not exist "%engine%" (
	echo Error: Engine folder path '%engine%' is not a valid path!
	pause
	exit /b 1
) else (
	echo Success: Found engine path!
)
if not exist "%engine_lib%" (
	echo Error: Engine library path '%engine_lib%' is not a valid path!
	pause
	exit /b 1
) else (
	echo Success: Found engine library path!
)
if not exist "%external_shared%" (
	echo Error: External shared folder path '%external_shared%' is not a valid path!
	pause
	exit /b 1
) else (
	echo Success: Found external shared path!
)
if not exist "%include%" (
	echo Error: Include folder path '%include%' is not a valid path!
	pause
	exit /b 1
) else (
	echo Success: Found include path!
)
if not exist "%release_engine%" (
	echo Error: Engine release folder path '%release_engine%' is not a valid path!
	pause
	exit /b 1
) else (
	echo Success: Found engine release path!
)
if not exist "%release_hub%" (
	echo Error: Hub release folder path '%release_hub%' is not a valid path!
	pause
	exit /b 1
) else (
	echo Success: Found hub release path!
)
if not exist "%source_game%" (
	echo Error: Game source folder path '%source_game%' is not a valid path!
	pause
	exit /b 1
) else (
	echo Success: Found game source path!
)

if not exist "%win_prerequisites_txt%" (
	echo Error: Windows prerequisites txt path '%win_prerequisites_txt%' is not a valid path!
	pause
	exit /b 1
) else (
	echo Success: Found windows prerequisites txt file!
)
if not exist "%win_prerequisites_7z%" (
	echo Error: Windows prerequisites 7z path '%win_prerequisites_7z%' is not a valid path!
	pause
	exit /b 1
) else (
	echo Success: Found windows prerequisites 7z file!
)
if not exist "%readme%" (
	echo Error: Readme path '%readme%' is not a valid path!
	pause
	exit /b 1
) else (
	echo Success: Found readme file!
)
if not exist "%license%" (
	echo Error: License path '%license%' is not a valid path!
	pause
	exit /b 1
) else (
	echo Success: Found license file!
)
if not exist "%libraries%" (
	echo Error: Libraries path '%libraries%' is not a valid path!
	pause
	exit /b 1
) else (
	echo Success: Found libraries file!
)
if not exist "%security%" (
	echo Error: Security path '%security%' is not a valid path!
	pause
	exit /b 1
) else (
	echo Success: Found security file!
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

:: Paste Windows_prerequisites.7z and .txt into target
copy "%win_prerequisites_7z%" ".\" /Y >nul
echo Copied windows prerequisites 7z to 'target'.
copy "%win_prerequisites_txt%" ".\" /Y >nul
echo Copied windows prerequisites txt to 'target'.

:: Paste readme, license, libraries and security into target
copy "%readme%" ".\" /Y >nul
echo Copied readme to 'target'.
copy "%license%" ".\" /Y >nul
echo Copied license to 'target'.
copy "%libraries%" ".\" /Y >nul
echo Copied libraries to 'target'.
copy "%security%" ".\" /Y >nul
echo Copied security to 'target'.

:: Paste changes file into target
copy "%changes%" ".\" /Y >nul
echo Copied changes file to 'target'.

echo. 

:: Create _external_shared and paste content into it
mkdir "_external_shared"
cd /d "_external_shared"
xcopy "%external_shared%" ".\" /E /I /Y >nul
echo Copied external shared libraries to '_external_shared'.

echo.

cd /d ..\

:: Create Engine folder and paste content into it
mkdir "Engine"
cd /d "Engine"
xcopy "%release_engine%" ".\" /E /I /Y >nul
echo Copied engine release files to 'Engine'.

:: Paste engine library into Engine folder
copy "%engine_lib%" ".\" /Y >nul
echo Copied engine library to 'Engine'.

:: Create include folder and paste content into it
mkdir "include"
cd /d "include"
xcopy "%include%" ".\" /E /I /Y >nul
echo Copied include files to 'include'.

cd /d ..\

:: Delete useless files from Engine folder
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
echo Cleaned up 'Engine'.

echo.

cd /d ..\

:: Create Hub folder and paste content into it
mkdir "Hub"
cd /d "Hub"
xcopy "%release_hub%" ".\" /E /I /Y >nul
echo Copied hub release files to 'Hub'.

:: Delete useless files from Hub folder
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
echo Cleaned up 'Hub'.

echo.

cd /d ..\

:: Create Game folder and paste content into it
mkdir "Game"
cd /d "Game"
xcopy "%source_game%" ".\" /E /I /Y >nul
echo Copied game source files to 'Game'.

:: Delete useless files from Game folder
if exist "out" (
	rmdir /s /q "out"
)
if exist "Elypso engine.lib" (
	del /f /q "Elypso engine.lib"
)
if exist "Elypso engineD.lib" (
	del /f /q "Elypso engineD.lib"
)
echo Cleaned up 'Game'.

echo.

cd /d ..\..\

:: Rename target to Elypso-engine-x64-release-windows
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