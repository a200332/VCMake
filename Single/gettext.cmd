@echo off
SETLOCAL EnableDelayedExpansion

set VCMakeRootPath=%1
set InstallSDKPath=%2
set SourceCodeName=%3
set BuildPlatform_=%4
set BuildLanguage_=%5
set BuildHostX8664=%6
set BuildConfigure=%7

:: ����Ƿ��� patch �����ļ�
 if exist "%VCMakeRootPath%Patch\%SourceCodeName%.patch" (
   copy /Y "%VCMakeRootPath%Patch\%SourceCodeName%.patch" "%VCMakeRootPath%Source\%SourceCodeName%\%SourceCodeName%.patch"
   set "SRCFullPath=%VCMakeRootPath%Source\%SourceCodeName%"
   set "SRCDisk=%SRCFullPath:~0,2%"
   set "SRCPath=%SRCFullPath:~3%"
   cd\
   %SRCDisk%
   cd\
   cd "%SRCPath%"
   git apply "%SourceCodeName%.patch"
   del "%VCMakeRootPath%Source\%SourceCodeName%\%SourceCodeName%.patch"
 )

:: VC ����̱��룻�ӿ�����ٶȣ�����������Ʋ���ȷ����Ӱ����룬ֻ�ǲ���ʹ�� VC �Ķ���̱��롣����̱������ܶ���̱��룬����󹤳�ʱ��������������Ӧ�ٶ�
	MSBuild.exe %VCMakeRootPath%Source\%SourceCodeName%\MSVC15\%SourceCodeName%.sln /nologo /consoleloggerparameters:Verbosity=minimal /maxcpucount /nodeReuse:true^
 /target:Build /property:Configuration=%BuildConfigure%;Platform=%BuildPlatform_%^
 /flp1:LogFile=%VCMakeRootPath%Source\%SourceCodeName%\MSVC15\zerror.log;errorsonly;Verbosity=diagnostic^
 /flp2:LogFile=%VCMakeRootPath%Source\%SourceCodeName%\MSVC15\zwarns.log;warningsonly;Verbosity=diagnostic

:: �����ļ�
copy /Y "%VCMakeRootPath%Source\%SourceCodeName%\MSVC15\libintl_static\Release\libintl_a.lib" "%InstallSDKPath%\lib\libintl.lib"
copy /Y "%VCMakeRootPath%Source\%SourceCodeName%\source\gettext-runtime\intl\libgnuintl.h"    "%InstallSDKPath%\include\libintl.h"

:: ��� VC �����Ƿ��д���
  if %ERRORLEVEL% NEQ 0 (
  echo ������ִ���ֹͣ����
  goto bEnd
  )

echo  ���� %Bname% ��ɣ�������ʱ�ļ�
title ���� %Bname% ��ɣ�������ʱ�ļ�
:: Դ���뻹ԭ
  if exist "%VCMakeRootPath%Source\%SourceCodeName%\.git\" (
    set "SRCFullPath=%VCMakeRootPath%Source\%SourceCodeName%"
    git clean -d  -fx -f %SRCFullPath%
    git checkout %SRCFullPath%
  )


:bEnd