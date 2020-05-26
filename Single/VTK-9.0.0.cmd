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

:: 设置 CMake 编译参数
set "sFile=%VCMakeRootPath%Script\vcp.txt"
set "sPara="
for /f "tokens=*" %%I in (%sFile%) do (set "sPara=!sPara! %%I")
set "Bpara=%sPara% %Bpara%"

:: 编译 vtk <WITH QT5.14.2>
cmake %sPara% -DVTK_ENABLE_Group_Qt=ON -DQt5_DIR=%InstallSDKPath%\qt5\static\lib\cmake\Qt5 -DCMAKE_INSTALL_PREFIX=%InstallSDKPath% -Thost=%BuildHostX8664% -B %BuildVTKPath% -G %BuildLanguageX% -A %BuildPlatform_% %VCMakeRootPath%\Source\%SourceCodeName%
cmake %BuildVTKPath%

:: VC 多进程编译；加快编译速度；如果工程名称不正确，不影响编译，只是不能使用 VC 的多进程编译。多进程编译会起很多进程编译，编译大工程时，会拖慢机器相应速度
MSBuild.exe %BuildVTKPath%\%BuildVCProject% /nologo /consoleloggerparameters:Verbosity=minimal /maxcpucount /nodeReuse:true^
 /target:Build /property:Configuration=%BuildConfigure%;Platform=%BuildPlatform_%^
 /flp1:LogFile=%BuildVTKPath%\zerror.log;errorsonly;Verbosity=diagnostic^
 /flp2:LogFile=%BuildVTKPath%\zwarns.log;warningsonly;Verbosity=diagnostic

:: 检查 VC 编译是否有错误
if %ERRORLEVEL% NEQ 0 (
 echo 编译出现错误，停止编译
 goto bEnd
)
  
:: 如果上面 VC 多进程编译没有任何问题，这里就不会再编译了，直接安装了
CMake --build "%BuildVTKPath%" --config %BuildConfigure% --target install
  
:: 源代码还原
echo  编译 %SourceCodeName% 完成，清理临时文件
title 编译 %SourceCodeName% 完成，清理临时文件
cd "%VCMakeRootPath%Source\%SourceCodeName%"
if exist "%VCMakeRootPath%Source\%SourceCodeName%\.git\" (
  set "SRCFullPath=%VCMakeRootPath%Source\%SourceCodeName%"
  git clean -d  -fx -f %SRCFullPath%
  git checkout %SRCFullPath%

  :: 删除临时文件 
  if exist "%VCMakeRootPath%%SourceCodeName%.tar.bz2" del "%VCMakeRootPath%%SourceCodeName%.tar.bz2"
  if exist "%VCMakeRootPath%%SourceCodeName%.tar.gz"  del "%VCMakeRootPath%%SourceCodeName%.tar.gz"
  if exist "%VCMakeRootPath%%SourceCodeName%.tar"     del "%VCMakeRootPath%%SourceCodeName%.tar"
  if exist "%VCMakeRootPath%%SourceCodeName%.zip"     del "%VCMakeRootPath%%SourceCodeName%.zip"
)

:bEnd
