@echo off

echo.
echo ==================================================
echo INITIALIZING ENGINE INSTALLER
echo ==================================================
echo.

set "rootDir=%~dp0"
set "target=%rootDir%\target"

set "engineRootFolder=%rootDir%\..\..\Elypso-engine"
set "hubRootFolder=%rootDir%\..\..\Elypso-hub"

set "engineReleaseFolder=%engineRootFolder%\Engine\out\build\x64-release"
set "engineLibReleaseFolder=%engineRootFolder%\Engine library\out\build\x64-release"
set "gameSourceFolder=%engineRootFolder%\Game"

set "hubReleaseFolder=%hubRootFolder%\out\build\x64-release"

set "externalShared=%engineRootFolder%\_external_shared"

set "engineLibPath=%engineRootFolder%\Engine\Elypso engine.lib"

set "include=%engineRootFolder%\Engine\include"

if not exist "%engineRootFolder%" (
	echo Error: Engine root folder does not exist!
	pause
	exit /b 1
) else (
	echo Found Engine root folder!
)
if not exist "%hubRootFolder%" (
	echo Error: Hub root folder does not exist!
	pause
	exit /b 1
) else (
	echo Found Hub root folder!
)

if not exist "%engineReleaseFolder%" (
	echo Error: Engine release folder does not exist!
	pause
	exit /b 1
) else (
	echo Found Engine release folder!
)
if not exist "%engineLibReleaseFolder%" (
	echo Error: Engine library release folder does not exist!
	pause
	exit /b 1
) else (
	echo Found Engine library release folder!
)
if not exist "%gameSourceFolder%" (
	echo Error: Game source folder does not exist!
	pause
	exit /b 1
) else (
	echo Found Game source folder!
)

if not exist "%hubReleaseFolder%" (
	echo Error: Hub release folder does not exist!
	pause
	exit /b 1
) else (
	echo Found Hub release folder!
)

if not exist "%externalShared%" (
	echo Error: External shared folder does not exist!
	pause
	exit /b 1
) else (
	echo Found External shared folder!
)

if not exist "%engineLibPath%" (
	echo Error: Engine library file path does not exist!
	pause
	exit /b 1
) else (
	echo Found Engine library file path!
)

if not exist "%include%" (
	echo Error: Engine include folder does not exist!
	pause
	exit /b 1
) else (
	echo Found Engine include folder!
)

echo.
echo ==================================================
echo ENGINE INSTALLER INITIALIZATION COMPLETED
echo ==================================================
echo.

cd "%rootDir%"

:: Create new empty target folder
if exist target (
	rmdir /S /Q target
)
mkdir target
echo Created new folder 'target'

cd target

:: Copy engine release folder
mkdir Engine
cd Engine
xcopy "%engineReleaseFolder%\*" ".\" /E /H /Y >nul 2>&1
cd ..
echo Copied 'Engine' release folder to 'Engine'

:: Copy game source folder
mkdir Game
cd Game
xcopy "%gameSourceFolder%\*" ".\" /E /H /Y >nul 2>&1
cd..
echo Copied 'Game' source folder to 'Game'

:: Copy hub source folder
mkdir Hub
cd Hub
xcopy "%hubReleaseFolder%\*" ".\" /E /H /Y >nul 2>&1
cd ..
echo Copied 'Hub' release folder to 'Hub'

:: Copy external shared folder
mkdir _external_shared
cd _external_shared
xcopy "%externalShared%\*" ".\" /E /H /Y >nul 2>&1
cd ..
echo Copied '_external_shared' root folder to '_external_shared'

:: Copy elypso library file
cd Game
copy "%engineLibPath%" ".\" >nul 2>&1
cd ..
echo Copied 'Elypso engine.lib' file to 'Game'

:: Copy elypso include folder
cd Engine
mkdir include
cd include
xcopy "%include%\*" ".\" /E /H /Y >nul 2>&1
cd ..\..
echo Copied 'include' folder to 'Engine'

:: Set new paths for engine root files
set "changes=%engineRootFolder%\CHANGES.txt"
set "libraries=%engineRootFolder%\LIBRARIES.md"
set "license=%engineRootFolder%\LICENSE.md"
set "readme=%engineRootFolder%\README.md"
set "security=%engineRootFolder%\SECURITY.md"
set "win7z=%engineRootFolder%\Windows_prerequisites.7z"
set "wintxt=%engineRootFolder%\Windows_prerequisites.txt"

:: Copy over engine root files
if exist "%changes%" (
	copy "%changes%" ".\" >nul 2>&1
)
if exist "%libraries%" (
	copy "%libraries%" ".\" >nul 2>&1
)
if exist "%license%" (
	copy "%license%" ".\" >nul 2>&1
)
if exist "%readme%" (
	copy "%readme%" ".\" >nul 2>&1
)
if exist "%security%" (
	copy "%security%" ".\" >nul 2>&1
)
if exist "%win7z%" (
	copy "%win7z%" ".\" >nul 2>&1
)
if exist "%wintxt%" (
	copy "%wintxt%" ".\" >nul 2>&1
)

echo Copied over engine root individual files

:: Set new paths for unnecessary engine release folder files and folders
set "engineReleaseTarget=%target%\Engine"
set "engineCMakeFolder=%engineReleaseTarget%\CMakeFiles"
set "engineNinjaDeps=%engineReleaseFolder%\.ninja_deps"
set "engineNinjaLog=%engineReleaseFolder%\.ninja_log"
set "engineBuildNinja=%engineReleaseFolder%\build.ninja"
set "engineCMakeInstall=%engineReleaseFolder%\cmake_install.cmake"
set "engineCMakeCache=%engineReleaseFolder%\CMakeCache.txt"
set "engineCPackConfig=%engineReleaseFolder%\CPackConfig.cmake"
set "engineCPackSourceConfig=%engineReleaseFolder%\CPackSourceConfig.cmake"

:: Remove unnecesary engine release folder files and folders
cd Engine
if exist "%engineCMakeFolder%" (
	rmdir /S /Q "%engineCMakeFolder%"
)
if exist "%engineNinjaDeps%" (
	del /F /Q "%engineNinjaDeps%"
)
if exist "%engineNinjaLog%" (
	del /F /Q "%engineNinjaLog%"
)
if exist "%engineBuildNinja%" (
	del /F /Q "%engineBuildNinja%"
)
if exist "%engineCMakeInstall%" (
	del /F /Q "%engineCMakeInstall%"
)
if exist "%engineCMakeCache%" (
	del /F /Q "%engineCMakeCache%"
)
if exist "%engineCPackConfig%" (
	del /F /Q "%engineCPackConfig%"
)
if exist "%engineCPackSourceConfig%" (
	del /F /Q "%engineCPackSourceConfig%"
)
cd ..

echo Deleted unnecessary engine release folder files and folders

:: Set new paths for unnecessary hub release folder files and folders
set "hubReleaseTarget=%target%\Hub"
set "hubCMakeFolder=%hubReleaseTarget%\CMakeFiles"
set "hubNinjaDeps=%hubReleaseTarget%\.ninja_deps"
set "hubNinjaLog=%hubReleaseTarget%\.ninja_log"
set "hubBuildNinja=%hubReleaseTarget%\build.ninja"
set "hubCMakeInstall=%hubReleaseTarget%\cmake_install.cmake"
set "hubCMakeCache=%hubReleaseTarget%\CMakeCache.txt"
set "hubCPackConfig=%hubReleaseTarget%\CPackConfig.cmake"
set "hubCPackSourceConfig=%hubReleaseTarget%\CPackSourceConfig.cmake"

:: Remove unnecesary hub release folder files and folders
cd Engine
if exist "%hubCMakeFolder%" (
	rmdir /S /Q "%hubCMakeFolder%"
)
if exist "%hubNinjaDeps%" (
	del /F /Q "%hubNinjaDeps%"
)
if exist "%hubNinjaLog%" (
	del /F /Q "%hubNinjaLog%"
)
if exist "%hubBuildNinja%" (
	del /F /Q "%hubBuildNinja%"
)
if exist "%hubCMakeInstall%" (
	del /F /Q "%hubCMakeInstall%"
)
if exist "%hubCMakeCache%" (
	del /F /Q "%hubCMakeCache%"
)
if exist "%hubCPackConfig%" (
	del /F /Q "%hubCPackConfig%"
)
if exist "%hubCPackSourceConfig%" (
	del /F /Q "%hubCPackSourceConfig%"
)
cd ..

echo Deleted unnecessary hub release folder files and folders

echo.
echo ==================================================
echo COMPRESSING INTO ZIP FILE
echo ==================================================
echo.

cd "%root%"
7z a -t7z -mx=9 -mmt=on "%target%\Elypso-engine-x64-release-windows.7z" "%target%"

echo.
echo ==================================================
echo SUCCESS: INSTALLATION COMPLETED
echo ==================================================
echo.

pause
exit /b 0