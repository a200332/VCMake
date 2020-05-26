@echo off

set VCMakeRootPath=%1
set InstallSDKPath=%2
set SourceProjName=%3
set BuildPlatform_=%4
set BuildLanguageX=%5
set BuildHostX8664=%6
set BuildConfigure=%7

del  /Q "%InstallSDKPath%\lib\zlib.lib"
copy /Y "%InstallSDKPath%\lib\zlibstatic.lib" "%InstallSDKPath%\lib\zlib.lib"
del  /Q "%InstallSDKPath%\bin\zlib.dll"

:: 安装 PC 文件
set "InstallPCPath=%InstallSDKPath:\=/%"
@echo prefix=%InstallPCPath%>%InstallSDKPath%\lib\pkgconfig\zlib.pc
@echo exec_prefix=${prefix}>>%InstallSDKPath%\lib\pkgconfig\zlib.pc
@echo libdir=${exec_prefix}/lib>>%InstallSDKPath%\lib\pkgconfig\zlib.pc
@echo sharedlibdir=${exec_prefix}/bin>>%InstallSDKPath%\lib\pkgconfig\zlib.pc
@echo includedir=${prefix}/include>>%InstallSDKPath%\lib\pkgconfig\zlib.pc
@echo Name: zlib>>%InstallSDKPath%\lib\pkgconfig\zlib.pc
@echo Description: zlib compression library>>%InstallSDKPath%\lib\pkgconfig\zlib.pc
@echo Version: 1.2.11>>%InstallSDKPath%\lib\pkgconfig\zlib.pc
@echo Requires:>>%InstallSDKPath%\lib\pkgconfig\zlib.pc
@echo Libs: -L${libdir} -lzlib>>%InstallSDKPath%\lib\pkgconfig\zlib.pc
@echo Cflags: -I${includedir}>>%InstallSDKPath%\lib\pkgconfig\zlib.pc
