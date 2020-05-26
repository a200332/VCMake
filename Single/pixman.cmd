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
set BuildPixmanPath=%VCMakeRootPath%Build\%SourceCodeName%\%BuildHostX8664%

:: Դ����Ŀ¼
set "PixmanSRC=%VCMakeRootPath%Source\%SourceCodeName%"

:: ����Ƿ��� patch �����ļ�
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

:: ��ѹ
7z x %VCMakeRootPath%Single\pixman.7z -o"%BuildPixmanPath%" -y
copy /Y "%BuildPixmanPath%\pixman-version.h" "%PixmanSRC%\Pixman" 

:: VC ����̱��룻�ӿ�����ٶȣ�����������Ʋ���ȷ����Ӱ����룬ֻ�ǲ���ʹ�� VC �Ķ���̱��롣����̱������ܶ���̱��룬����󹤳�ʱ��������������Ӧ�ٶ�
MSBuild.exe %BuildPixmanPath%\pixman.sln /nologo /consoleloggerparameters:Verbosity=minimal /maxcpucount /nodeReuse:true^
 /target:Build /property:Configuration=%BuildConfigure%;Platform=%BuildHostX8664%^
 /flp1:LogFile=%BuildPixmanPath%\zerror.log;errorsonly;Verbosity=diagnostic^
 /flp2:LogFile=%BuildPixmanPath%\zwarns.log;warningsonly;Verbosity=diagnostic

:: ��װ�ļ�
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

:: ��� VC �����Ƿ��д���
if %ERRORLEVEL% NEQ 0 (
 echo ������ִ���ֹͣ����
 goto bEnd
)

:: Դ���뻹ԭ
git clean -d  -fx -f %PixmanSRC%
git checkout %PixmanSRC%

:bEnd
