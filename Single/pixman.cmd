@echo off
SETLOCAL EnableDelayedExpansion

set VCMakeRootPath=%1
set InstallSDKPath=%2
set SourceCodeName=%3
set BuildPlatform_=%4
set BuildLanguageX=%5
set BuildHostX8664=%6
set BuildConfigure=%7
set "PKG_CONFIG_PATH=%InstallSDKPath%\lib\pkgconfig"

:: 编译目录
set BuildPixmanPath=%VCMakeRootPath%Build\%SourceCodeName%\%BuildHostX8664%

:: 源代码目录
set "PixmanSRC=%VCMakeRootPath%Source\%SourceCodeName%"

:: 检查是否有 patch 补丁文件
 if exist "%VCMakeRootPath%Patch\%SourceCodeName%.patch" (
   copy /Y "%VCMakeRootPath%Patch\%SourceCodeName%.patch" "%VCMakeRootPath%Source\%SourceCodeName%\%SourceCodeName%.patch"
   set "SRCDisk=%PixmanSRC:~0,2%"
   set "SRCPath=%PixmanSRC:~3%"
   cd\
   %SRCDisk%
   cd\
   cd "%SRCPath%"
   git apply "%SourceCodeName%.patch"
   del "%VCMakeRootPath%Source\%SourceCodeName%\%SourceCodeName%.patch"
 )

:: 解压
7z x %VCMakeRootPath%Single\pixman.7z -o"%BuildPixmanPath%" -y
copy /Y "%BuildPixmanPath%\pixman-version.h" "%PixmanSRC%\Pixman" 

:: VC 多进程编译；加快编译速度；如果工程名称不正确，不影响编译，只是不能使用 VC 的多进程编译。多进程编译会起很多进程编译，编译大工程时，会拖慢机器相应速度
MSBuild.exe %BuildPixmanPath%\pixman.sln /nologo /consoleloggerparameters:Verbosity=minimal /maxcpucount /nodeReuse:true^
 /target:Build /property:Configuration=%BuildConfigure%;Platform=%BuildHostX8664%^
 /flp1:LogFile=%BuildPixmanPath%\zerror.log;errorsonly;Verbosity=diagnostic^
 /flp2:LogFile=%BuildPixmanPath%\zwarns.log;warningsonly;Verbosity=diagnostic

:: 安装文件
set "InstallPCPath=%InstallSDKPath:\=/%"
if not exist "%InstallSDKPath%\include\pixman-1" (
md "%InstallSDKPath%\include\pixman-1"
)

copy /Y "%BuildPixmanPath%\%BuildConfigure%\pixman.lib" "%InstallSDKPath%\lib\pixman.lib"
copy /Y "%PixmanSRC%\pixman\pixman.h"         "%InstallSDKPath%\include\pixman-1\pixman.h"
copy /Y "%PixmanSRC%\pixman\pixman-version.h" "%InstallSDKPath%\include\pixman-1\pixman-version.h"
@echo prefix=%InstallPCPath%>%InstallSDKPath%\lib\pkgconfig\pixman-1.pc
@echo libdir=${exec_prefix}/lib>>%InstallSDKPath%\lib\pkgconfig\pixman-1.pc
@echo includedir=${prefix}/include>>%InstallSDKPath%\lib\pkgconfig\pixman-1.pc
@echo Name: Pixman>>%InstallSDKPath%\lib\pkgconfig\pixman-1.pc
@echo Description: The pixman library (version 1)>>%InstallSDKPath%\lib\pkgconfig\pixman-1.pc
@echo Version: 0.40.0>>%InstallSDKPath%\lib\pkgconfig\pixman-1.pc
@echo Libs: -L${libdir} -lpixman-1>>%InstallSDKPath%\lib\pkgconfig\pixman-1.pc
@echo Libs.private: -lm -pthread>>%InstallSDKPath%\lib\pkgconfig\pixman-1.pc
@echo Cflags:-I${includedir}/pixman-1>>%InstallSDKPath%\lib\pkgconfig\pixman-1.pc

:: 检查 VC 编译是否有错误
if %ERRORLEVEL% NEQ 0 (
 echo 编译出现错误，停止编译
 goto bEnd
)

:: 源代码还原
git clean -d  -fx -f %PixmanSRC%
git checkout %PixmanSRC%

:bEnd
