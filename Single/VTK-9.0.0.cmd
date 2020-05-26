@echo off
SETLOCAL EnableDelayedExpansion

set VCMakeRootPath=%1
set InstallSDKPath=%2
set SourceCodeName=%3
set BuildPlatform_=%4
set BuildLanguageX=%5
set BuildHostX8664=%6
set BuildConfigure=%7
set BuildVCProject=%8
set BuildVTKPath=%VCMakeRootPath%Build\%SourceCodeName%\%BuildHostX8664%

:: ���� CMake �������
set "sFile=%VCMakeRootPath%Script\vcp.txt"
set "sPara="
for /f "tokens=*" %%I in (%sFile%) do (set "sPara=!sPara! %%I")
set "Bpara=%sPara% %Bpara%"

:: ���� vtk <WITH QT5.14.2>
cmake %sPara% -DVTK_ENABLE_Group_Qt=ON -DQt5_DIR=%InstallSDKPath%\qt5\static\lib\cmake\Qt5 -DCMAKE_INSTALL_PREFIX=%InstallSDKPath% -Thost=%BuildHostX8664% -B %BuildVTKPath% -G %BuildLanguageX% -A %BuildPlatform_% %VCMakeRootPath%\Source\%SourceCodeName%
cmake %BuildVTKPath%

:: VC ����̱��룻�ӿ�����ٶȣ�����������Ʋ���ȷ����Ӱ����룬ֻ�ǲ���ʹ�� VC �Ķ���̱��롣����̱������ܶ���̱��룬����󹤳�ʱ��������������Ӧ�ٶ�
MSBuild.exe %BuildVTKPath%\%BuildVCProject% /nologo /consoleloggerparameters:Verbosity=minimal /maxcpucount /nodeReuse:true^
 /target:Build /property:Configuration=%BuildConfigure%;Platform=%BuildPlatform_%^
 /flp1:LogFile=%BuildVTKPath%\zerror.log;errorsonly;Verbosity=diagnostic^
 /flp2:LogFile=%BuildVTKPath%\zwarns.log;warningsonly;Verbosity=diagnostic

:: ��� VC �����Ƿ��д���
if %ERRORLEVEL% NEQ 0 (
 echo ������ִ���ֹͣ����
 goto bEnd
)
  
:: ������� VC ����̱���û���κ����⣬����Ͳ����ٱ����ˣ�ֱ�Ӱ�װ��
CMake --build "%BuildVTKPath%" --config %BuildConfigure% --target install
  
:: Դ���뻹ԭ
echo  ���� %SourceCodeName% ��ɣ�������ʱ�ļ�
title ���� %SourceCodeName% ��ɣ�������ʱ�ļ�
cd "%VCMakeRootPath%Source\%SourceCodeName%"
if exist "%VCMakeRootPath%Source\%SourceCodeName%\.git\" (
  set "SRCFullPath=%VCMakeRootPath%Source\%SourceCodeName%"
  git clean -d  -fx -f %SRCFullPath%
  git checkout %SRCFullPath%

  :: ɾ����ʱ�ļ� 
  if exist "%VCMakeRootPath%%SourceCodeName%.tar.bz2" del "%VCMakeRootPath%%SourceCodeName%.tar.bz2"
  if exist "%VCMakeRootPath%%SourceCodeName%.tar.gz"  del "%VCMakeRootPath%%SourceCodeName%.tar.gz"
  if exist "%VCMakeRootPath%%SourceCodeName%.tar"     del "%VCMakeRootPath%%SourceCodeName%.tar"
  if exist "%VCMakeRootPath%%SourceCodeName%.zip"     del "%VCMakeRootPath%%SourceCodeName%.zip"
)

:bEnd
