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

:: 源代码目录
set "SourceFullPath=%VCMakeRootPath%Source\%SourceCodeName%"

:: 检查是否有 patch 补丁文件
 if exist "%VCMakeRootPath%Patch\%SourceCodeName%.patch" (
   copy /Y "%VCMakeRootPath%Patch\%SourceCodeName%.patch" "%VCMakeRootPath%Source\%SourceCodeName%\%SourceCodeName%.patch"
   cd /D "%SourceFullPath%"
   git apply "%SourceCodeName%.patch"
   del "%VCMakeRootPath%Source\%SourceCodeName%\%SourceCodeName%.patch"
 )

:: MSBuild 头文件、库文件搜索路径
set "INCLUDE=%InstallSDKPath%\include;%INCLUDE%"
set "LIB=%InstallSDKPath%\lib;%LIB%"
set "UseEnv=True"

:: VC 多进程编译；加快编译速度；如果工程名称不正确，不影响编译，只是不能使用 VC 的多进程编译。多进程编译会起很多进程编译，编译大工程时，会拖慢机器相应速度
MSBuild.exe %SourceFullPath%\amf\public\proj\vs2017\AmfMediaCommon.sln /nologo /consoleloggerparameters:Verbosity=minimal /maxcpucount /nodeReuse:true^
 /target:Build /property:Configuration=%BuildConfigure%;Platform=%BuildPlatform_%^
 /flp1:LogFile=%SourceFullPath%\zerror.log;errorsonly;Verbosity=diagnostic^
 /flp2:LogFile=%SourceFullPath%\zwarns.log;warningsonly;Verbosity=diagnostic

:: 安装文件
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

:: 检查 VC 编译是否有错误
if %ERRORLEVEL% NEQ 0 (
 echo 编译出现错误，停止编译
 goto bEnd
)

:: 源代码还原
cd /D "%SourceFullPath%"
git clean -d  -fx -f
git checkout .

:bEnd
