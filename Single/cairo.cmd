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

:: ����Ŀ¼
set BuildcairoPath=%VCMakeRootPath%Build\%SourceCodeName%\%BuildHostX8664%

:: Դ����Ŀ¼
set "SourceFullPath=%VCMakeRootPath%Source\%SourceCodeName%"

:: ��ѹ
7z x %VCMakeRootPath%Single\cairo.7z -o"%BuildcairoPath%" -y
copy /Y "%BuildcairoPath%\src\cairo-features.h" "%SourceFullPath%\src\cairo-features.h" 

:: MSBuild ͷ�ļ������ļ�����·��
set "INCLUDE=%InstallSDKPath%\include;%InstallSDKPath%\include\pixman-1;%InstallSDKPath%\include\freetype2;%SourceFullPath%\src;%INCLUDE%"
set "LIB=%InstallSDKPath%\lib;%LIB%"
set "UseEnv=True"

:: VC ����̱��룻�ӿ�����ٶȣ�����������Ʋ���ȷ����Ӱ����룬ֻ�ǲ���ʹ�� VC �Ķ���̱��롣����̱������ܶ���̱��룬����󹤳�ʱ��������������Ӧ�ٶ�
MSBuild.exe %BuildcairoPath%\cairo.sln /nologo /consoleloggerparameters:Verbosity=minimal /maxcpucount /nodeReuse:true^
 /target:Build /property:Configuration=%BuildConfigure%;Platform=%BuildHostX8664%^
 /flp1:LogFile=%BuildcairoPath%\zerror.log;errorsonly;Verbosity=diagnostic^
 /flp2:LogFile=%BuildcairoPath%\zwarns.log;warningsonly;Verbosity=diagnostic

:: ��װ�ļ�
set "InstallPCPath=%InstallSDKPath:\=/%"
if not exist "%InstallSDKPath%\include\cairo" (
md "%InstallSDKPath%\include\cairo"
)
copy /Y "%BuildcairoPath%\%BuildConfigure%\cairo.lib" "%InstallSDKPath%\lib\cairo.lib"
copy /Y "%SourceFullPath%\src\cairo-deprecated.h" "%InstallSDKPath%\include\cairo\cairo-deprecated.h"
copy /Y "%SourceFullPath%\src\cairo-features.h" "%InstallSDKPath%\include\cairo\cairo-features.h"
copy /Y "%SourceFullPath%\src\cairo-ft.h" "%InstallSDKPath%\include\cairo\cairo-ft.h"
copy /Y "%SourceFullPath%\src\cairo-pdf.h" "%InstallSDKPath%\include\cairo\cairo-pdf.h"
copy /Y "%SourceFullPath%\src\cairo-ps.h" "%InstallSDKPath%\include\cairo\cairo-ps.h"
copy /Y "%SourceFullPath%\src\cairo-script.h" "%InstallSDKPath%\include\cairo\cairo-script.h"
copy /Y "%SourceFullPath%\src\cairo-svg.h" "%InstallSDKPath%\include\cairo\cairo-svg.h"
copy /Y "%SourceFullPath%\src\cairo-tee.h" "%InstallSDKPath%\include\cairo\cairo-tee.h"
copy /Y "%SourceFullPath%\src\cairo-win32.h"   "%InstallSDKPath%\include\cairo\cairo-win32.h"
copy /Y "%SourceFullPath%\src\cairo.h"         "%InstallSDKPath%\include\cairo\cairo.h"
copy /Y "%SourceFullPath%\cairo-version.h" "%InstallSDKPath%\include\cairo\cairo-version.h"
@echo prefix=%InstallPCPath%>%InstallSDKPath%\lib\pkgconfig\cairo.pc
@echo libdir=${exec_prefix}/lib>>%InstallSDKPath%\lib\pkgconfig\cairo.pc
@echo includedir=${prefix}/include>>%InstallSDKPath%\lib\pkgconfig\cairo.pc
@echo Name: cairo>>%InstallSDKPath%\lib\pkgconfig\cairo.pc
@echo Description: Multi-platform 2D graphics library>>%InstallSDKPath%\lib\pkgconfig\cairo.pc
@echo Version: 0.40.0>>%InstallSDKPath%\lib\pkgconfig\cairo.pc
@echo Libs: -L${libdir} -lcairo -lzlib -lfreetype -lfontconfig -llibpng16 >>%InstallSDKPath%\lib\pkgconfig\cairo.pc
@echo Libs.private: -lcairo -lzlib -lfreetype -lfontconfig -llibpng16>>%InstallSDKPath%\lib\pkgconfig\cairo.pc
@echo Cflags:-I${includedir}/cairo>>%InstallSDKPath%\lib\pkgconfig\cairo.pc

@echo prefix=%InstallPCPath%>%InstallSDKPath%\lib\pkgconfig\cairo-win32.pc
@echo exec_prefix=${prefix}>>%InstallSDKPath%\lib\pkgconfig\cairo-win32.pc
@echo libdir=${exec_prefix}/lib>>%InstallSDKPath%\lib\pkgconfig\cairo-win32.pc
@echo includedir=${prefix}/include>>%InstallSDKPath%\lib\pkgconfig\cairo-win32.pc
@echo Name: cairo-win32>>%InstallSDKPath%\lib\pkgconfig\cairo-win32.pc
@echo Description: Microsoft Windows surface backend for cairo graphics library>>%InstallSDKPath%\lib\pkgconfig\cairo-win32.pc
@echo Version: 1.16.0>>%InstallSDKPath%\lib\pkgconfig\cairo-win32.pc
@echo Requires: cairo >>%InstallSDKPath%\lib\pkgconfig\cairo-win32.pc
@echo Libs:  -L${libdir} -lcairo>>%InstallSDKPath%\lib\pkgconfig\cairo-win32.pc
@echo Cflags: -I${includedir}/cairo >>%InstallSDKPath%\lib\pkgconfig\cairo-win32.pc

:: ��� VC �����Ƿ��д���
if %ERRORLEVEL% NEQ 0 (
 echo ������ִ���ֹͣ����
 goto bEnd
)

:: Դ���뻹ԭ
cd /D "%SourceFullPath%"
git clean -d  -fx -f
git checkout .

:bEnd
