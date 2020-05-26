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

:: Դ����Ŀ¼
set "libtheoraSRC=%VCMakeRootPath%Source\%SourceCodeName%"

:: MSBuild ͷ�ļ������ļ�����·��
set "INCLUDE=%InstallSDKPath%\include;%InstallSDKPath%\include\pixman-1;%InstallSDKPath%\include\freetype2;%INCLUDE%"
set "LIB=%InstallSDKPath%\lib;%LIB%"
set "UseEnv=True"

:: ��ѹ
7z x %VCMakeRootPath%Single\%SourceCodeName%.7z -o"%libtheoraSRC%\Win32" -y

:: VC ����̱��룻�ӿ�����ٶȣ�����������Ʋ���ȷ����Ӱ����룬ֻ�ǲ���ʹ�� VC �Ķ���̱��롣����̱������ܶ���̱��룬����󹤳�ʱ��������������Ӧ�ٶ�
MSBuild.exe %libtheoraSRC%\Win32\VS2017\libtheora_static.sln /nologo /consoleloggerparameters:Verbosity=minimal /maxcpucount /nodeReuse:true^
 /target:Build /property:Configuration=%BuildConfigure%_SSE2;Platform=%BuildPlatform_%^
 /flp1:LogFile=%libtheoraSRC%\zerror.log;errorsonly;Verbosity=diagnostic^
 /flp2:LogFile=%libtheoraSRC%\zwarns.log;warningsonly;Verbosity=diagnostic

:: ��װ�ļ�
set "InstallPCPath=%InstallSDKPath:\=/%"
if not exist "%InstallSDKPath%\include\theora" (
md "%InstallSDKPath%\include\theora"
)
copy /Y "%libtheoraSRC%\Win32\VS2017\%BuildPlatform_%\%BuildConfigure%_SSE2\libtheora_static.lib"     "%InstallSDKPath%\lib\libtheora_static.lib"
copy /Y "%libtheoraSRC%\Win32\VS2017\%BuildPlatform_%\%BuildConfigure%_SSE2\libtheora_static.lib"     "%InstallSDKPath%\lib\libtheora.lib"
copy /Y "%libtheoraSRC%\Win32\VS2017\%BuildPlatform_%\%BuildConfigure%_SSE2\libtheora_static.lib"     "%InstallSDKPath%\lib\libtheoradec.lib"
copy /Y "%libtheoraSRC%\Win32\VS2017\%BuildPlatform_%\%BuildConfigure%_SSE2\libtheora_static.lib"     "%InstallSDKPath%\lib\libtheoraenc.lib"
copy /Y "%libtheoraSRC%\include\theora\codec.h"          "%InstallSDKPath%\include\theora\codec.h"
copy /Y "%libtheoraSRC%\include\theora\theora.h"         "%InstallSDKPath%\include\theora\theora.h"
copy /Y "%libtheoraSRC%\include\theora\theoraenc.h"      "%InstallSDKPath%\include\theora\theoraenc.h"
copy /Y "%libtheoraSRC%\include\theora\theoradec.h"     "%InstallSDKPath%\include\theora\theoradec.h"

@echo prefix=%InstallPCPath%>%InstallSDKPath%\lib\pkgconfig\theora.pc
@echo libdir=${exec_prefix}/lib>>%InstallSDKPath%\lib\pkgconfig\theora.pc
@echo includedir=${prefix}/include>>%InstallSDKPath%\lib\pkgconfig\theora.pc
@echo Name: theora>>%InstallSDKPath%\lib\pkgconfig\theora.pc
@echo Description: Theora video codec>>%InstallSDKPath%\lib\pkgconfig\theora.pc
@echo Version: 1.1.1>>%InstallSDKPath%\lib\pkgconfig\theora.pc
@echo Requires.private: ogg>>%InstallSDKPath%\lib\pkgconfig\theora.pc
@echo Libs: -L${libdir} -ltheora -logg >>%InstallSDKPath%\lib\pkgconfig\theora.pc
@echo Libs.private: -ltheora -logg>>%InstallSDKPath%\lib\pkgconfig\theora.pc
@echo Cflags:-I${includedir}>>%InstallSDKPath%\lib\pkgconfig\theora.pc

@echo prefix=%InstallPCPath%>%InstallSDKPath%\lib\pkgconfig\theoraenc.pc
@echo libdir=${exec_prefix}/lib>>%InstallSDKPath%\lib\pkgconfig\theoraenc.pc
@echo includedir=${prefix}/include>>%InstallSDKPath%\lib\pkgconfig\theoraenc.pc
@echo Name: theoraenc>>%InstallSDKPath%\lib\pkgconfig\theoraenc.pc
@echo Description: Theora video codec (encoder)>>%InstallSDKPath%\lib\pkgconfig\theoraenc.pc
@echo Version: 1.1.1>>%InstallSDKPath%\lib\pkgconfig\theoraenc.pc
@echo Requires.private: ogg>>%InstallSDKPath%\lib\pkgconfig\theoraenc.pc
@echo Libs: -L${libdir} -ltheoraenc -logg >>%InstallSDKPath%\lib\pkgconfig\theoraenc.pc
@echo Libs.private: -ltheora -logg>>%InstallSDKPath%\lib\pkgconfig\theoraenc.pc
@echo Cflags:-I${includedir}>>%InstallSDKPath%\lib\pkgconfig\theoraenc.pc

@echo prefix=%InstallPCPath%>%InstallSDKPath%\lib\pkgconfig\theoradec.pc
@echo libdir=${exec_prefix}/lib>>%InstallSDKPath%\lib\pkgconfig\theoradec.pc
@echo includedir=${prefix}/include>>%InstallSDKPath%\lib\pkgconfig\theoradec.pc
@echo Name: theoradec>>%InstallSDKPath%\lib\pkgconfig\theoradec.pc
@echo Description: Theora video codec (decoder)>>%InstallSDKPath%\lib\pkgconfig\theoradec.pc
@echo Version: 1.1.1>>%InstallSDKPath%\lib\pkgconfig\theoradec.pc
@echo Requires.private: ogg>>%InstallSDKPath%\lib\pkgconfig\theoradec.pc
@echo Libs: -L${libdir} -ltheoradec -logg >>%InstallSDKPath%\lib\pkgconfig\theoradec.pc
@echo Libs.private: -ltheoradec -logg>>%InstallSDKPath%\lib\pkgconfig\theoradec.pc
@echo Cflags:-I${includedir}>>%InstallSDKPath%\lib\pkgconfig\theoradec.pc

:: ɾ����ʱ�ļ� 
if exist "%VCMakeRootPath%%SourceCodeName%.tar.bz2" del "%VCMakeRootPath%%SourceCodeName%.tar.bz2"
if exist "%VCMakeRootPath%%SourceCodeName%.tar.gz"  del "%VCMakeRootPath%%SourceCodeName%.tar.gz"
if exist "%VCMakeRootPath%%SourceCodeName%.tar"     del "%VCMakeRootPath%%SourceCodeName%.tar"
if exist "%VCMakeRootPath%%SourceCodeName%.zip"     del "%VCMakeRootPath%%SourceCodeName%.zip"

:bEnd
