@echo off
SETLOCAL EnableDelayedExpansion

set VCMakeRootPath=%1
set InstallSDKPath=%2
set SourceProjName=%3
set BuildPlatform_=%4
set BuildLanguageX=%5
set BuildHostX8664=%6
set BuildConfigure=%7
set BuildlmdbPath=%VCMakeRootPath%Build\%SourceProjName%\%BuildHostX8664%

:: ���� CMake �������
set "sFile=%VCMakeRootPath%Script\vcp.txt"
set "sPara="
for /f "tokens=*" %%I in (%sFile%) do (set "sPara=!sPara! %%I")
set "Bpara=%sPara% %Bpara%"

:: ���� liblmdb
cmake %sPara% -DCMAKE_INSTALL_PREFIX=%InstallSDKPath% -Thost=%BuildHostX8664% -B %BuildlmdbPath% -G %BuildLanguageX% -A %BuildPlatform_% %VCMakeRootPath%\Source\%SourceProjName%\libraries\liblmdb\cmake
cmake %BuildlmdbPath%

:: VC ����̱��룻�ӿ�����ٶȣ�����������Ʋ���ȷ����Ӱ����룬ֻ�ǲ���ʹ�� VC �Ķ���̱��롣����̱������ܶ���̱��룬����󹤳�ʱ��������������Ӧ�ٶ�
	MSBuild.exe %BuildlmdbPath%\lmdb.sln /nologo /consoleloggerparameters:Verbosity=minimal /maxcpucount /nodeReuse:true^
 /target:Build /property:Configuration=%BuildConfigure%;Platform=%BuildPlatform_%^
 /flp1:LogFile=%BuildlmdbPath%\zerror.log;errorsonly;Verbosity=diagnostic^
 /flp2:LogFile=%BuildlmdbPath%\zwarns.log;warningsonly;Verbosity=diagnostic

:: ��� VC �����Ƿ��д���
  if %ERRORLEVEL% NEQ 0 (
  echo ������ִ���ֹͣ����
  goto bEnd
  )
  
:: ������� VC ����̱���û���κ����⣬����Ͳ����ٱ����ˣ�ֱ�Ӱ�װ��
	CMake --build "%BuildlmdbPath%" --config %BuildConfigure% --target install

  Copy /Y "%InstallSDKPath%\lib\liblmdbMT.lib" "%InstallSDKPath%\lib\liblmdb.lib"
  
  
:bEnd
