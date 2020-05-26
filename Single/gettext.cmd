@echo off
SETLOCAL EnableDelayedExpansion

set VCMakeRootPath=%1
set InstallSDKPath=%2
set SourceCodeName=%3
set BuildPlatform_=%4
set BuildLanguage_=%5
set BuildHostX8664=%6
set BuildConfigure=%7

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

:: VC 多进程编译；加快编译速度；如果工程名称不正确，不影响编译，只是不能使用 VC 的多进程编译。多进程编译会起很多进程编译，编译大工程时，会拖慢机器相应速度
	MSBuild.exe %VCMakeRootPath%Source\%SourceCodeName%\MSVC15\%SourceCodeName%.sln /nologo /consoleloggerparameters:Verbosity=minimal /maxcpucount /nodeReuse:true^
 /target:Build /property:Configuration=%BuildConfigure%;Platform=%BuildPlatform_%^
 /flp1:LogFile=%VCMakeRootPath%Source\%SourceCodeName%\MSVC15\zerror.log;errorsonly;Verbosity=diagnostic^
 /flp2:LogFile=%VCMakeRootPath%Source\%SourceCodeName%\MSVC15\zwarns.log;warningsonly;Verbosity=diagnostic

:: 复制文件
copy /Y "%VCMakeRootPath%Source\%SourceCodeName%\MSVC15\libintl_static\Release\libintl_a.lib" "%InstallSDKPath%\lib\libintl.lib"
copy /Y "%VCMakeRootPath%Source\%SourceCodeName%\source\gettext-runtime\intl\libgnuintl.h"    "%InstallSDKPath%\include\libintl.h"

:: 检查 VC 编译是否有错误
  if %ERRORLEVEL% NEQ 0 (
  echo 编译出现错误，停止编译
  goto bEnd
  )

echo  编译 %Bname% 完成，清理临时文件
title 编译 %Bname% 完成，清理临时文件
:: 源代码还原
  if exist "%VCMakeRootPath%Source\%SourceCodeName%\.git\" (
    set "SRCFullPath=%VCMakeRootPath%Source\%SourceCodeName%"
    git clean -d  -fx -f %SRCFullPath%
    git checkout %SRCFullPath%
  )


:bEnd