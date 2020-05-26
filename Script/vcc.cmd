@echo off

set VCMakeRootPath=%1
set BuildLanguageX=%2
set BuildPlatform1=%3
set BuildPlatform2=%4
set BuildConfigure=%5
set InstallSDKPath=%6

set "mfxlibInc=F:\Green\Language\Intel\MSDK2018\SDK\include"
set "mfxlibLib=F:\Green\Language\Intel\MSDK2018\SDK\lib\%BuildPlatform1%"
set "PYTHON2_EXECUTABLE=%VCMakeRootPath%Tools\Python\2.7.16\%BuildPlatform2%\python.exe"

:: 设置 pkgconfig 目录 
set "TMP_CONFIG_PATH=%InstallSDKPath%\lib\pkgconfig"
set "PKG_CONFIG_PATH=%TMP_CONFIG_PATH:\=/%"

:: 设置系统搜索路径；工具、第三方库都放在搜索路径中；也可以放在系统搜索路径中；但最好放在文件中，因为 WINDOWS 系统的系统搜索路径有字符串长度限制；
set "sFile=%VCMakeRootPath%Script\p%BuildPlatform2%.txt"
set "sPath="
for /f "tokens=*" %%I in (%sFile%) do (set "sPath=!sPath!;%%I")
set "Path=%VCMakeRootPath%Tools\CMake\bin;%VCMakeRootPath%Tools\jom_1_1_3;%VCMakeRootPath%Tools\Meson;%VCMakeRootPath%Tools\bison\bin;%VCMakeRootPath%Tools\Perl\bin;%VCMakeRootPath%Tools\Perl\site\bin;%VCMakeRootPath%Tools\flex\bin;%VCMakeRootPath%Tools\Python\3.7.4\%BuildPlatform2%;%VCMakeRootPath%Tools\Python\3.7.4\%BuildPlatform2%\libs;%VCMakeRootPath%Tools\Python\3.7.4\%BuildPlatform2%\Scripts;%InstallSDKPath%\bin;%InstallSDKPath%\QT5\static\lib\cmake;%sPath%;%Path%"

:: 编译语言
if %BuildLanguageX% == VS2017 (
  set CMakeLang="Visual Studio 15 2017"
  set "VSWHERE="%VCMakeRootPath%Tools\CMake\bin\vswhere.exe" -property installationPath -requires Microsoft.Component.MSBuild Microsoft.VisualStudio.Component.VC.ATLMFC Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -version [15.0,16.0^)"
  for /f "delims=" %%A IN ('!VSWHERE!') DO call "%%A\Common7\Tools\vsdevcmd.bat" -no_logo -arch=%BuildPlatform2%
) else (
  set CMakeLang="Visual Studio 16 2019"
  set "VSWHERE="%VCMakeRootPath%Tools\CMake\bin\vswhere.exe" -property installationPath -requires Microsoft.Component.MSBuild Microsoft.VisualStudio.Component.VC.ATLMFC Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -version [16.0,17.0^)"
  for /f "delims=" %%A IN ('!VSWHERE!') DO call "%%A\Common7\Tools\vsdevcmd.bat" -no_logo -arch=%BuildPlatform2%
)

:: MSBuild 头文件、库文件搜索路径
set "INCLUDE=%InstallSDKPath%\include;%InstallSDKPath%\include\TBB;%InstallSDKPath%\include\harfbuzz;%InstallSDKPath%\QT5\static\include;%mfxlibInc%;%INCLUDE%"
set "LIB=%InstallSDKPath%\lib;%InstallSDKPath%\QT5\static\lib;%mfxlibLib%;%LIB%"
set "UseEnv=True"

:: 编译源码
"%VCMakeRootPath%vca.cmd" %VCMakeRootPath% %CMakeLang% %BuildPlatform1% %BuildPlatform2% %BuildConfigure% %InstallSDKPath%
