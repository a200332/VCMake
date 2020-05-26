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

:: 设置 CMake 编译参数
set "sFile=%VCMakeRootPath%Script\vcp.txt"
set "sPara="
for /f "tokens=*" %%I in (%sFile%) do (set "sPara=!sPara! %%I")
set "Bpara=%sPara% %Bpara%"

:: 检查是否有 patch 补丁文件
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

:: 编译 llvm
cmake %sPara% -DCMAKE_INSTALL_PREFIX=%InstallSDKPath% -Thost=%BuildHostX8664% -B %BuildLLVMPathX% -G %BuildLanguageX% -A %BuildPlatform_% %VCMakeRootPath%\Source\%SourceCodeName%\llvm
cmake %BuildLLVMPathX%

:: VC 多进程编译；加快编译速度；如果工程名称不正确，不影响编译，只是不能使用 VC 的多进程编译。多进程编译会起很多进程编译，编译大工程时，会拖慢机器相应速度
	MSBuild.exe %BuildLLVMPathX%\llvm.sln /nologo /consoleloggerparameters:Verbosity=minimal /maxcpucount /nodeReuse:true^
 /target:Build /property:Configuration=%BuildConfigure%;Platform=%BuildPlatform_%^
 /flp1:LogFile=%BuildLLVMPathX%\zerror.log;errorsonly;Verbosity=diagnostic^
 /flp2:LogFile=%BuildLLVMPathX%\zwarns.log;warningsonly;Verbosity=diagnostic

:: 检查 VC 编译是否有错误
  if %ERRORLEVEL% NEQ 0 (
  echo 编译出现错误，停止编译
  goto bEnd
  )
  
:: 如果上面 VC 多进程编译没有任何问题，这里就不会再编译了，直接安装了
	CMake --build "%BuildLLVMPathX%" --config %BuildConfigure% --target install
	
:: 检查 CMake 编译是否有错误
  if %ERRORLEVEL% NEQ 0 (
  echo 编译出现错误，停止编译
  goto bEnd
  )

echo 编译 LLVM 完成后，MSBUILD.EXE 进程并不会全部关闭掉，需杀死 MSBUILD.EXE 进程，才可以进行 CLANG 的编译
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


:: 编译 clang
echo  编译 llvm - clang
title 编译 llvm - clang
cmake %sPara% -DCMAKE_INSTALL_PREFIX=%InstallSDKPath% -Thost=%BuildHostX8664% -B %BuildCLANGPath% -G %BuildLanguageX% -A %BuildPlatform_% %VCMakeRootPath%\Source\%SourceCodeName%\clang
cmake %BuildCLANGPath%

echo 如果 CMake Clang 发生错误，请使用 CMakeGUI 打开 Clang 编译目录，重新 CMake 一下。成功后，再次执行编译
pause

:: VC 多进程编译；加快编译速度；如果工程名称不正确，不影响编译，只是不能使用 VC 的多进程编译。多进程编译会起很多进程编译，编译大工程时，会拖慢机器相应速度
	MSBuild.exe %BuildCLANGPath%\clang.sln /nologo /consoleloggerparameters:Verbosity=minimal /maxcpucount /nodeReuse:true^
 /target:Build /property:Configuration=%BuildConfigure%;Platform=%BuildPlatform_%^
 /flp1:LogFile=%BuildCLANGPath%\zerror.log;errorsonly;Verbosity=diagnostic^
 /flp2:LogFile=%BuildCLANGPath%\zwarns.log;warningsonly;Verbosity=diagnostic

:: 检查 VC 编译是否有错误
  if %ERRORLEVEL% NEQ 0 (
  echo 编译出现错误，停止编译
  goto bEnd
  )
  
:: 如果上面 VC 多进程编译没有任何问题，这里就不会再编译了，直接安装了
	CMake --build "%BuildCLANGPath%" --config %BuildConfigure% --target install
	
:: 检查 CMake 编译是否有错误
  if %ERRORLEVEL% NEQ 0 (
  echo 编译出现错误，停止编译
  goto bEnd
  )

:: 源代码还原
set "SRCFullPath=%VCMakeRootPath%Source\%SourceCodeName%"
git clean -d  -fx -f %SRCFullPath%
git checkout %SRCFullPath%

:bEnd
