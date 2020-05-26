@echo off
SETLOCAL EnableDelayedExpansion

set VCMakeRootPath=%1
set InstallSDKPath=%2
set SourceCodeName=%3
set BuildPlatform_=%4
set BuildLanguageX=%5
set BuildHostX8664=%6
set BuildConfigure=%7
set BuildLLVMPathX=%VCMakeRootPath%Build\llvm\%BuildHostX8664%
set BuildCLANGPath=%VCMakeRootPath%Build\clang\%BuildHostX8664%

:: ���� CMake �������
set "sFile=%VCMakeRootPath%Script\vcp.txt"
set "sPara="
for /f "tokens=*" %%I in (%sFile%) do (set "sPara=!sPara! %%I")
set "Bpara=%sPara% %Bpara%"

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

:: ���� llvm
cmake %sPara% -DCMAKE_INSTALL_PREFIX=%InstallSDKPath% -Thost=%BuildHostX8664% -B %BuildLLVMPathX% -G %BuildLanguageX% -A %BuildPlatform_% %VCMakeRootPath%\Source\%SourceCodeName%\llvm
cmake %BuildLLVMPathX%

:: VC ����̱��룻�ӿ�����ٶȣ�����������Ʋ���ȷ����Ӱ����룬ֻ�ǲ���ʹ�� VC �Ķ���̱��롣����̱������ܶ���̱��룬����󹤳�ʱ��������������Ӧ�ٶ�
	MSBuild.exe %BuildLLVMPathX%\llvm.sln /nologo /consoleloggerparameters:Verbosity=minimal /maxcpucount /nodeReuse:true^
 /target:Build /property:Configuration=%BuildConfigure%;Platform=%BuildPlatform_%^
 /flp1:LogFile=%BuildLLVMPathX%\zerror.log;errorsonly;Verbosity=diagnostic^
 /flp2:LogFile=%BuildLLVMPathX%\zwarns.log;warningsonly;Verbosity=diagnostic

:: ��� VC �����Ƿ��д���
  if %ERRORLEVEL% NEQ 0 (
  echo ������ִ���ֹͣ����
  goto bEnd
  )
  
:: ������� VC ����̱���û���κ����⣬����Ͳ����ٱ����ˣ�ֱ�Ӱ�װ��
	CMake --build "%BuildLLVMPathX%" --config %BuildConfigure% --target install
	
:: ��� CMake �����Ƿ��д���
  if %ERRORLEVEL% NEQ 0 (
  echo ������ִ���ֹͣ����
  goto bEnd
  )

echo ���� LLVM ��ɺ�MSBUILD.EXE ���̲�����ȫ���رյ�����ɱ�� MSBUILD.EXE ���̣��ſ��Խ��� CLANG �ı���
tskill msbuild.exe
tskill msbuild.exe
tskill msbuild.exe
tskill msbuild.exe
tskill msbuild.exe
tskill msbuild.exe
tskill msbuild.exe
tskill msbuild.exe
tskill msbuild.exe
tskill msbuild.exe


:: ���� clang
echo  ���� llvm - clang
title ���� llvm - clang
cmake %sPara% -DCMAKE_INSTALL_PREFIX=%InstallSDKPath% -Thost=%BuildHostX8664% -B %BuildCLANGPath% -G %BuildLanguageX% -A %BuildPlatform_% %VCMakeRootPath%\Source\%SourceCodeName%\clang
cmake %BuildCLANGPath%

echo ��� CMake Clang ����������ʹ�� CMakeGUI �� Clang ����Ŀ¼������ CMake һ�¡��ɹ����ٴ�ִ�б���
pause

:: VC ����̱��룻�ӿ�����ٶȣ�����������Ʋ���ȷ����Ӱ����룬ֻ�ǲ���ʹ�� VC �Ķ���̱��롣����̱������ܶ���̱��룬����󹤳�ʱ��������������Ӧ�ٶ�
	MSBuild.exe %BuildCLANGPath%\clang.sln /nologo /consoleloggerparameters:Verbosity=minimal /maxcpucount /nodeReuse:true^
 /target:Build /property:Configuration=%BuildConfigure%;Platform=%BuildPlatform_%^
 /flp1:LogFile=%BuildCLANGPath%\zerror.log;errorsonly;Verbosity=diagnostic^
 /flp2:LogFile=%BuildCLANGPath%\zwarns.log;warningsonly;Verbosity=diagnostic

:: ��� VC �����Ƿ��д���
  if %ERRORLEVEL% NEQ 0 (
  echo ������ִ���ֹͣ����
  goto bEnd
  )
  
:: ������� VC ����̱���û���κ����⣬����Ͳ����ٱ����ˣ�ֱ�Ӱ�װ��
	CMake --build "%BuildCLANGPath%" --config %BuildConfigure% --target install
	
:: ��� CMake �����Ƿ��д���
  if %ERRORLEVEL% NEQ 0 (
  echo ������ִ���ֹͣ����
  goto bEnd
  )

:: Դ���뻹ԭ
set "SRCFullPath=%VCMakeRootPath%Source\%SourceCodeName%"
git clean -d  -fx -f %SRCFullPath%
git checkout %SRCFullPath%

:bEnd
