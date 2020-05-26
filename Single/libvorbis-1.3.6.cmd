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
set "libvorbisSRC=%VCMakeRootPath%Source\%SourceCodeName%"

:: MSBuild 头文件、库文件搜索路径
set "INCLUDE=%InstallSDKPath%\include;%InstallSDKPath%\include\pixman-1;%InstallSDKPath%\include\freetype2;%INCLUDE%"
set "LIB=%InstallSDKPath%\lib;%LIB%"
set "UseEnv=True"

:: 解压
7z x %VCMakeRootPath%Single\%SourceCodeName%.7z -o"%libvorbisSRC%\Win32" -y

:: VC 多进程编译；加快编译速度；如果工程名称不正确，不影响编译，只是不能使用 VC 的多进程编译。多进程编译会起很多进程编译，编译大工程时，会拖慢机器相应速度
MSBuild.exe %libvorbisSRC%\Win32\VS2017\vorbis_static.sln /nologo /consoleloggerparameters:Verbosity=minimal /maxcpucount /nodeReuse:true^
 /target:Build /property:Configuration=%BuildConfigure%;Platform=%BuildPlatform_%^
 /flp1:LogFile=%libvorbisSRC%\zerror.log;errorsonly;Verbosity=diagnostic^
 /flp2:LogFile=%libvorbisSRC%\zwarns.log;warningsonly;Verbosity=diagnostic

:: 安装文件
set "InstallPCPath=%InstallSDKPath:\=/%"
if not exist "%InstallSDKPath%\include\vorbis" (
md "%InstallSDKPath%\include\vorbis"
)
copy /Y "%libvorbisSRC%\Win32\VS2017\%BuildPlatform_%\%BuildConfigure%\libvorbis_static.lib"     "%InstallSDKPath%\lib\libvorbis_static.lib"
copy /Y "%libvorbisSRC%\Win32\VS2017\%BuildPlatform_%\%BuildConfigure%\libvorbis_static.lib"     "%InstallSDKPath%\lib\libvorbis.lib"
copy /Y "%libvorbisSRC%\Win32\VS2017\%BuildPlatform_%\%BuildConfigure%\libvorbisfile_static.lib" "%InstallSDKPath%\lib\libvorbisfile_static.lib"
copy /Y "%libvorbisSRC%\Win32\VS2017\%BuildPlatform_%\%BuildConfigure%\libvorbisfile_static.lib" "%InstallSDKPath%\lib\libvorbisfile.lib"
copy /Y "%libvorbisSRC%\Win32\VS2017\%BuildPlatform_%\%BuildConfigure%\vorbisdec_static.exe"     "%InstallSDKPath%\bin\vorbisdec.exe"
copy /Y "%libvorbisSRC%\Win32\VS2017\%BuildPlatform_%\%BuildConfigure%\vorbisenc_static.exe"     "%InstallSDKPath%\bin\vorbisenc.exe"
copy /Y "%libvorbisSRC%\include\vorbis\codec.h"          "%InstallSDKPath%\include\vorbis\codec.h"
copy /Y "%libvorbisSRC%\include\vorbis\vorbisenc.h"      "%InstallSDKPath%\include\vorbis\vorbisenc.h"
copy /Y "%libvorbisSRC%\include\vorbis\vorbisfile.h"     "%InstallSDKPath%\include\vorbis\vorbisfile.h"

@echo prefix=%InstallPCPath%>%InstallSDKPath%\lib\pkgconfig\vorbis.pc
@echo libdir=${exec_prefix}/lib>>%InstallSDKPath%\lib\pkgconfig\vorbis.pc
@echo includedir=${prefix}/include>>%InstallSDKPath%\lib\pkgconfig\vorbis.pc
@echo Name: vorbis>>%InstallSDKPath%\lib\pkgconfig\vorbis.pc
@echo Description: vorbis is the primary Ogg Vorbis library>>%InstallSDKPath%\lib\pkgconfig\vorbis.pc
@echo Version: 1.3.6>>%InstallSDKPath%\lib\pkgconfig\vorbis.pc
@echo Requires.private: ogg>>%InstallSDKPath%\lib\pkgconfig\vorbis.pc
@echo Libs: -L${libdir} -lvorbis -logg >>%InstallSDKPath%\lib\pkgconfig\vorbis.pc
@echo Libs.private: -lvorbis -logg>>%InstallSDKPath%\lib\pkgconfig\vorbis.pc
@echo Cflags:-I${includedir}>>%InstallSDKPath%\lib\pkgconfig\vorbis.pc

@echo prefix=%InstallPCPath%>%InstallSDKPath%\lib\pkgconfig\vorbisenc.pc
@echo libdir=${exec_prefix}/lib>>%InstallSDKPath%\lib\pkgconfig\vorbisenc.pc
@echo includedir=${prefix}/include>>%InstallSDKPath%\lib\pkgconfig\vorbisenc.pc
@echo Name: vorbisenc>>%InstallSDKPath%\lib\pkgconfig\vorbisenc.pc
@echo Description: vorbisenc is a library that provides a convenient API for setting up an encoding environment using libvorbis>>%InstallSDKPath%\lib\pkgconfig\vorbisenc.pc
@echo Version: 1.3.6>>%InstallSDKPath%\lib\pkgconfig\vorbisenc.pc
@echo Requires.private: ogg vorbis>>%InstallSDKPath%\lib\pkgconfig\vorbisenc.pc
@echo Libs: -L${libdir} -lvorbis -logg >>%InstallSDKPath%\lib\pkgconfig\vorbisenc.pc
@echo Libs.private: -lvorbis -logg>>%InstallSDKPath%\lib\pkgconfig\vorbisenc.pc
@echo Cflags:-I${includedir}>>%InstallSDKPath%\lib\pkgconfig\vorbisenc.pc

@echo prefix=%InstallPCPath%>%InstallSDKPath%\lib\pkgconfig\vorbisfile.pc
@echo libdir=${exec_prefix}/lib>>%InstallSDKPath%\lib\pkgconfig\vorbisfile.pc
@echo includedir=${prefix}/include>>%InstallSDKPath%\lib\pkgconfig\vorbisfile.pc
@echo Name: vorbisfile>>%InstallSDKPath%\lib\pkgconfig\vorbisfile.pc
@echo Description: vorbisfile is a library that provides a convenient high-level API for decoding and basic manipulation of all Vorbis I audio streams>>%InstallSDKPath%\lib\pkgconfig\vorbisfile.pc
@echo Version: 1.3.6>>%InstallSDKPath%\lib\pkgconfig\vorbisfile.pc
@echo Requires.private: ogg vorbis>>%InstallSDKPath%\lib\pkgconfig\vorbisfile.pc
@echo Libs: -L${libdir} -lvorbisfile -lvorbis -logg >>%InstallSDKPath%\lib\pkgconfig\vorbisfile.pc
@echo Libs.private: -lvorbisfile -lvorbis -logg>>%InstallSDKPath%\lib\pkgconfig\vorbisfile.pc
@echo Cflags:-I${includedir}>>%InstallSDKPath%\lib\pkgconfig\vorbisfile.pc

:: 删除临时文件 
if exist "%VCMakeRootPath%%SourceCodeName%.tar.bz2" del "%VCMakeRootPath%%SourceCodeName%.tar.bz2"
if exist "%VCMakeRootPath%%SourceCodeName%.tar.gz"  del "%VCMakeRootPath%%SourceCodeName%.tar.gz"
if exist "%VCMakeRootPath%%SourceCodeName%.tar"     del "%VCMakeRootPath%%SourceCodeName%.tar"
if exist "%VCMakeRootPath%%SourceCodeName%.zip"     del "%VCMakeRootPath%%SourceCodeName%.zip"

:bEnd
