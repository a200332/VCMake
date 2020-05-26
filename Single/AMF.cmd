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

:: ����Ƿ��� patch �����ļ�
 if exist "%VCMakeRootPath%Patch\%SourceCodeName%.patch" (
   copy /Y "%VCMakeRootPath%Patch\%SourceCodeName%.patch" "%VCMakeRootPath%Source\%SourceCodeName%\%SourceCodeName%.patch"
   cd /D "%SourceFullPath%"
   git apply "%SourceCodeName%.patch"
   del "%VCMakeRootPath%Source\%SourceCodeName%\%SourceCodeName%.patch"
 )

:: MSBuild ͷ�ļ������ļ�����·��
set "INCLUDE=%InstallSDKPath%\include;%INCLUDE%"
set "LIB=%InstallSDKPath%\lib;%LIB%"
set "UseEnv=True"

:: VC ����̱��룻�ӿ�����ٶȣ�����������Ʋ���ȷ����Ӱ����룬ֻ�ǲ���ʹ�� VC �Ķ���̱��롣����̱������ܶ���̱��룬����󹤳�ʱ��������������Ӧ�ٶ�
MSBuild.exe %SourceFullPath%\amf\public\proj\vs2017\AmfMediaCommon.sln /nologo /consoleloggerparameters:Verbosity=minimal /maxcpucount /nodeReuse:true^
 /target:Build /property:Configuration=%BuildConfigure%;Platform=%BuildPlatform_%^
 /flp1:LogFile=%SourceFullPath%\zerror.log;errorsonly;Verbosity=diagnostic^
 /flp2:LogFile=%SourceFullPath%\zwarns.log;warningsonly;Verbosity=diagnostic

:: ��װ�ļ�
set "InstallPCPath=%InstallSDKPath:\=/%"
if not exist "%InstallSDKPath%\include\AMF" (
md "%InstallSDKPath%\include\AMF"
)

if %BuildLanguageX% == "Visual Studio 15 2017" (
  set Lang=vs2017
  ) else (
  set Lang=vs2019
)
  
if %BuildPlatform_% == Win32 (
  set wp=x32
  ) else (
 set wp=x64
)
 
xcopy /Y /E "%SourceFullPath%\amf\public\include\*.*" "%InstallSDKPath%\include\AMF\"
copy  /Y "%SourceFullPath%\amf\BIN\%Lang%%wp%%BuildConfigure%\AmfMediaCommon.lib" "%InstallSDKPath%\lib\AmfMediaCommon.lib"

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
