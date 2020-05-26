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
set "SourceFullPath=%VCMakeRootPath%Source\%SourceCodeName%"

:: ��ѹ
7z x %VCMakeRootPath%Single\TBB.7z -o"%SourceFullPath%\build" -y

:: MSBuild ͷ�ļ������ļ�����·��
set "INCLUDE=%InstallSDKPath%\include;%INCLUDE%"
set "LIB=%InstallSDKPath%\lib;%LIB%"
set "UseEnv=True"

:: VC ����̱��룻�ӿ�����ٶȣ�����������Ʋ���ȷ����Ӱ����룬ֻ�ǲ���ʹ�� VC �Ķ���̱��롣����̱������ܶ���̱��룬����󹤳�ʱ��������������Ӧ�ٶ�
MSBuild.exe %SourceFullPath%\build\VS2017\makefile.sln /nologo /consoleloggerparameters:Verbosity=minimal /maxcpucount /nodeReuse:true^
 /target:Build /property:Configuration=%BuildConfigure%-MT;Platform=%BuildPlatform_%^
 /flp1:LogFile=%SourceFullPath%\build\VS2017\zerror.log;errorsonly;Verbosity=diagnostic^
 /flp2:LogFile=%SourceFullPath%\build\VS2017\zwarns.log;warningsonly;Verbosity=diagnostic

:: ��װ�ļ�
set "InstallPCPath=%InstallSDKPath:\=/%"
if not exist "%InstallSDKPath%\include\TBB" (
md "%InstallSDKPath%\include\TBB"
)
copy  /Y "%SourceFullPath%\build\VS2017\%BuildPlatform_%\%BuildConfigure%-MT\TBB.lib" "%InstallSDKPath%\lib\TBB.lib"
copy  /Y "%SourceFullPath%\build\VS2017\%BuildPlatform_%\%BuildConfigure%-MT\tbbmalloc.lib" "%InstallSDKPath%\lib\tbbmalloc.lib"
copy  /Y "%SourceFullPath%\build\VS2017\%BuildPlatform_%\%BuildConfigure%-MT\tbbmalloc_proxy.lib" "%InstallSDKPath%\lib\tbbmalloc_proxy.lib"
xcopy /Y /E "%SourceFullPath%\include\*.*" "%InstallSDKPath%\include\TBB\"

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
