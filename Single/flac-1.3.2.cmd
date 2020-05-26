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

:: 源代码目录
set "flacSRC=%VCMakeRootPath%Source\%SourceCodeName%"

:: MSBuild 头文件、库文件搜索路径
set "INCLUDE=%InstallSDKPath%\include;%InstallSDKPath%\include\pixman-1;%InstallSDKPath%\include\freetype2;%INCLUDE%"
set "LIB=%InstallSDKPath%\lib;%LIB%"
set "UseEnv=True"

:: 解压
7z x %VCMakeRootPath%Single\%SourceCodeName%.7z -o"%flacSRC%" -y

:: VC 多进程编译；加快编译速度；如果工程名称不正确，不影响编译，只是不能使用 VC 的多进程编译。多进程编译会起很多进程编译，编译大工程时，会拖慢机器相应速度
MSBuild.exe %flacSRC%\flac.sln /nologo /consoleloggerparameters:Verbosity=minimal /maxcpucount /nodeReuse:true^
 /target:Build /property:Configuration=%BuildConfigure%;Platform=%BuildPlatform_%^
 /flp1:LogFile=%flacSRC%\zerror.log;errorsonly;Verbosity=diagnostic^
 /flp2:LogFile=%flacSRC%\zwarns.log;warningsonly;Verbosity=diagnostic

:: 安装文件
set "InstallPCPath=%InstallSDKPath:\=/%"
if not exist "%InstallSDKPath%\include\flac" (
md "%InstallSDKPath%\include\flac")
if not exist "%InstallSDKPath%\include\flac++" (
md "%InstallSDKPath%\include\flac++")
copy /Y "%flacSRC%\objs\%BuildConfigure%\lib\libFLAC_static.lib"     "%InstallSDKPath%\lib\libFLAC_static.lib"
copy /Y "%flacSRC%\objs\%BuildConfigure%\lib\libFLAC_static.lib"     "%InstallSDKPath%\lib\libFLAC.lib"
copy /Y "%flacSRC%\objs\%BuildConfigure%\lib\libFLAC++_static.lib"   "%InstallSDKPath%\lib\libFLAC++_static.lib"
copy /Y "%flacSRC%\objs\%BuildConfigure%\lib\libFLAC++_static.lib"   "%InstallSDKPath%\lib\libFLAC++.lib"

copy /Y "%flacSRC%\include\flac\all.h"            "%InstallSDKPath%\include\flac\all.h"
copy /Y "%flacSRC%\include\flac\assert.h"         "%InstallSDKPath%\include\flac\assert.h"
copy /Y "%flacSRC%\include\flac\callback.h"       "%InstallSDKPath%\include\flac\callback.h"
copy /Y "%flacSRC%\include\flac\export.h"         "%InstallSDKPath%\include\flac\export.h"
copy /Y "%flacSRC%\include\flac\format.h"        "%InstallSDKPath%\include\flac\format.h"
copy /Y "%flacSRC%\include\flac\metadata.h"       "%InstallSDKPath%\include\flac\metadata.h"
copy /Y "%flacSRC%\include\flac\ordinals.h"       "%InstallSDKPath%\include\flac\ordinals.h"
copy /Y "%flacSRC%\include\flac\stream_decoder.h" "%InstallSDKPath%\include\flac\stream_decoder.h"
copy /Y "%flacSRC%\include\flac\stream_encoder.h" "%InstallSDKPath%\include\flac\stream_encoder.h"

copy /Y "%flacSRC%\include\FLAC++\all.h"          "%InstallSDKPath%\include\FLAC++\all.h"
copy /Y "%flacSRC%\include\FLAC++\decoder.h"      "%InstallSDKPath%\include\FLAC++\decoder.h"
copy /Y "%flacSRC%\include\FLAC++\encoder.h"      "%InstallSDKPath%\include\FLAC++\encoder.h"
copy /Y "%flacSRC%\include\FLAC++\export.h"       "%InstallSDKPath%\include\FLAC++\export.h"
copy /Y "%flacSRC%\include\FLAC++\metadata.h"     "%InstallSDKPath%\include\FLAC++\metadata.h"

@echo prefix=%InstallPCPath%>%InstallSDKPath%\lib\pkgconfig\flac.pc
@echo libdir=${exec_prefix}/lib>>%InstallSDKPath%\lib\pkgconfig\flac.pc
@echo includedir=${prefix}/include>>%InstallSDKPath%\lib\pkgconfig\flac.pc
@echo Name: FLAC>>%InstallSDKPath%\lib\pkgconfig\flac.pc
@echo Description: Free Lossless Audio Codec Library>>%InstallSDKPath%\lib\pkgconfig\flac.pc
@echo Version: 1.3.2>>%InstallSDKPath%\lib\pkgconfig\flac.pc
@echo Requires.private: ogg>>%InstallSDKPath%\lib\pkgconfig\flac.pc
@echo Libs: -L${libdir} -lflac -logg >>%InstallSDKPath%\lib\pkgconfig\flac.pc
@echo Libs.private: -lflac -logg>>%InstallSDKPath%\lib\pkgconfig\flac.pc
@echo Cflags:-I${includedir}>>%InstallSDKPath%\lib\pkgconfig\flac.pc

@echo prefix=%InstallPCPath%>%InstallSDKPath%\lib\pkgconfig\flac++.pc
@echo libdir=${exec_prefix}/lib>>%InstallSDKPath%\lib\pkgconfig\flac++.pc
@echo includedir=${prefix}/include>>%InstallSDKPath%\lib\pkgconfig\flac++.pc
@echo Name: FLAC++>>%InstallSDKPath%\lib\pkgconfig\flac++.pc
@echo Description: Free Lossless Audio Codec Library (C++ API)>>%InstallSDKPath%\lib\pkgconfig\flac++.pc
@echo Version: 1.3.2>>%InstallSDKPath%\lib\pkgconfig\flac++.pc
@echo Requires.private: ogg flac>>%InstallSDKPath%\lib\pkgconfig\flac++.pc
@echo Libs: -L${libdir} -lFLAC++ -logg >>%InstallSDKPath%\lib\pkgconfig\flac++.pc
@echo Libs.private: -lFLAC++ -logg>>%InstallSDKPath%\lib\pkgconfig\flac++.pc
@echo Cflags:-I${includedir}>>%InstallSDKPath%\lib\pkgconfig\flac++.pc

:: 删除临时文件 
if exist "%VCMakeRootPath%%SourceCodeName%.tar.bz2" del "%VCMakeRootPath%%SourceCodeName%.tar.bz2"
if exist "%VCMakeRootPath%%SourceCodeName%.tar.xz"  del "%VCMakeRootPath%%SourceCodeName%.tar.xz"
if exist "%VCMakeRootPath%%SourceCodeName%.tar.gz"  del "%VCMakeRootPath%%SourceCodeName%.tar.gz"
if exist "%VCMakeRootPath%%SourceCodeName%.tar"     del "%VCMakeRootPath%%SourceCodeName%.tar"
if exist "%VCMakeRootPath%%SourceCodeName%.zip"     del "%VCMakeRootPath%%SourceCodeName%.zip"

:bEnd
