@echo off
SETLOCAL EnableDelayedExpansion

set "VCMakeRootPath=%1"
set "SourceCodeName=%2"
set "BuildLanguageX=%3"
set "BuildPlatformX=%4"
set "BuildHostX8664=%5"
set "BuildConfigure=%6"
set "InstallSDKPath=%7"
set "BuildVCProject=%8"
set "Btemp=%VCMakeRootPath%Build\%SourceCodeName%\%BuildHostX8664%"
set "SourceFullPath=%VCMakeRootPath%Source\%SourceCodeName%"

:: ������ڶ������룬��ʹ�ö������룻���� CMake ��֧�ֵ���Ŀ���磺boost, QT ��
if exist "%VCMakeRootPath%Single\%SourceCodeName%.cmd" (
   call "%VCMakeRootPath%Single\%SourceCodeName%.cmd" %VCMakeRootPath% %InstallSDKPath% %SourceCodeName% %BuildPlatformX% %BuildLanguageX% %BuildHostX8664% %BuildConfigure% %BuildVCProject%
   goto bEnd
)

:: ����Ƿ��� patch �����ļ�
 if exist "%VCMakeRootPath%Patch\%SourceCodeName%.patch" (
   copy /Y "%VCMakeRootPath%Patch\%SourceCodeName%.patch" "%VCMakeRootPath%Source\%SourceCodeName%\%SourceCodeName%.patch"
   cd "%VCMakeRootPath%Source\%SourceCodeName%"
   git apply "%SourceCodeName%.patch"
   del "%VCMakeRootPath%Source\%SourceCodeName%\%SourceCodeName%.patch"
)

:: ���� CMake �������
set "sFile=%VCMakeRootPath%Script\vcp.txt"
set "sPara="
for /f "tokens=*" %%I in (%sFile%) do (set "sPara=!sPara! %%I")
set "Bpara=%sPara% %Bpara%"

:: ���� patch Ŀ¼���Ƿ���ͬ��Ŀ���Ƶ� txt �ı�����������ƹ�������������Ϊ CMakelists.txt
 if exist "%VCMakeRootPath%Patch\%SourceCodeName%.txt" (
   copy /Y "%VCMakeRootPath%Patch\%SourceCodeName%.txt" "%VCMakeRootPath%Source\%SourceCodeName%\CMakelists.txt" 
)

:: ����Ƿ��� CMakeLists.txt �ļ������û�У��˳�����
if not exist "%VCMakeRootPath%Source\%SourceCodeName%\CMakelists.txt" (
   echo û�� CMakelists.txt �ļ�����֧�ֱ���
   goto bEnd
) 

:: ��ʼ CMake ����
if exist "%VCMakeRootPath%Source\%SourceCodeName%" (
	CMake  %Bpara% -DMFX_INCLUDE_DIRS="F:/Green/Language/Intel/MSDK2018/SDK/include/mfx" -DMFX_LIBRARIES="F:/Green/Language/Intel/MSDK2018/SDK/lib/Win32/libmfx_vs2015.lib"  -DCMAKE_INSTALL_PREFIX=%InstallSDKPath% -Thost=%BuildHostX8664% -B "%Btemp%" -G %BuildLanguageX% -A %BuildPlatformX% %VCMakeRootPath%Source\%SourceCodeName%
	CMake "%Btemp%"

  :: VC ����֮ǰ������Ƿ��й����ļ���Ҫ�޸ĵĲ���������������ļ��򲹶� (xz ���������⣬���ܱ��� MT ����)
  if exist "%VCMakeRootPath%Patch\%SourceCodeName%_sln.cmd" (
    call "%VCMakeRootPath%Patch\%SourceCodeName%_sln.cmd" %Btemp% %InstallSDKPath%
  )

  :: VC ����̱��룻�ӿ�����ٶȣ�����������Ʋ���ȷ����Ӱ����룬ֻ�ǲ���ʹ�� VC �Ķ���̱��롣����̱������ܶ���̱��룬����󹤳�ʱ��������������Ӧ�ٶ�
	MSBuild.exe %Btemp%\%BuildVCProject% /nologo /consoleloggerparameters:Verbosity=minimal /maxcpucount /nodeReuse:true^
  /target:Build /property:Configuration=%BuildConfigure%;Platform=%BuildPlatformX%^
  /flp1:LogFile=%Btemp%\zerror.log;errorsonly;Verbosity=diagnostic^
  /flp2:LogFile=%Btemp%\zwarns.log;warningsonly;Verbosity=diagnostic

  :: ��� VC �����Ƿ��д���
  if %ERRORLEVEL% NEQ 0 (
  echo ������ִ���ֹͣ����
  goto bEnd
  )
  
  :: ������� VC ����̱���û���κ����⣬����Ͳ����ٱ����ˣ�ֱ�Ӱ�װ��
	CMake --build "%Btemp%" --config %BuildConfigure% --target install
	
  :: ��װ֮���Ƿ����Զ���Ķ���
  if exist "%VCMakeRootPath%After\%SourceCodeName%.cmd" (
  call "%VCMakeRootPath%After\%SourceCodeName%.cmd"  %VCMakeRootPath% %InstallSDKPath% %SourceCodeName% %BuildPlatformX% %BuildLanguageX% %BuildHostX8664% %BuildConfigure%
  )

  :: ��� CMake �����Ƿ��д���
  if %ERRORLEVEL% NEQ 0 (
  echo ������ִ���ֹͣ����
  goto bEnd
  )
  
  :: Դ���뻹ԭ
  echo  ���� %SourceCodeName% ��ɣ�������ʱ�ļ�
  title ���� %SourceCodeName% ��ɣ�������ʱ�ļ�
  if exist "%SourceFullPath%\.git\" (
  cd /D "%SourceFullPath%"
  git clean -d  -fx -f 
  git checkout .
  )

  :: ɾ����ʱ�ļ� 
  if exist "%VCMakeRootPath%%SourceCodeName%.tar.bz2" del "%VCMakeRootPath%%SourceCodeName%.tar.bz2"
  if exist "%VCMakeRootPath%%SourceCodeName%.tar.gz"  del "%VCMakeRootPath%%SourceCodeName%.tar.gz"
  if exist "%VCMakeRootPath%%SourceCodeName%.tar.xz"  del "%VCMakeRootPath%%SourceCodeName%.tar.xz"
  if exist "%VCMakeRootPath%%SourceCodeName%.tar"     del "%VCMakeRootPath%%SourceCodeName%.tar"
  if exist "%VCMakeRootPath%%SourceCodeName%.zip"     del "%VCMakeRootPath%%SourceCodeName%.zip"
)

:bEnd
