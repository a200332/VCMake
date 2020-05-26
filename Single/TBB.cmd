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

:: 解压
7z x %VCMakeRootPath%Single\TBB.7z -o"%SourceFullPath%\build" -y

:: MSBuild 头文件、库文件搜索路径
set "INCLUDE=%InstallSDKPath%\include;%INCLUDE%"
set "LIB=%InstallSDKPath%\lib;%LIB%"
set "UseEnv=True"

:: VC 多进程编译；加快编译速度；如果工程名称不正确，不影响编译，只是不能使用 VC 的多进程编译。多进程编译会起很多进程编译，编译大工程时，会拖慢机器相应速度
MSBuild.exe %SourceFullPath%\build\VS2017\makefile.sln /nologo /consoleloggerparameters:Verbosity=minimal /maxcpucount /nodeReuse:true^
 /target:Build /property:Configuration=%BuildConfigure%-MT;Platform=%BuildPlatform_%^
 /flp1:LogFile=%SourceFullPath%\build\VS2017\zerror.log;errorsonly;Verbosity=diagnostic^
 /flp2:LogFile=%SourceFullPath%\build\VS2017\zwarns.log;warningsonly;Verbosity=diagnostic

:: 安装文件
set "InstallPCPath=%InstallSDKPath:\=/%"
if not exist "%InstallSDKPath%\include\TBB" (
md "%InstallSDKPath%\include\TBB"
)
copy  /Y "%SourceFullPath%\build\VS2017\%BuildPlatform_%\%BuildConfigure%-MT\TBB.lib" "%InstallSDKPath%\lib\TBB.lib"
copy  /Y "%SourceFullPath%\build\VS2017\%BuildPlatform_%\%BuildConfigure%-MT\tbbmalloc.lib" "%InstallSDKPath%\lib\tbbmalloc.lib"
copy  /Y "%SourceFullPath%\build\VS2017\%BuildPlatform_%\%BuildConfigure%-MT\tbbmalloc_proxy.lib" "%InstallSDKPath%\lib\tbbmalloc_proxy.lib"
xcopy /Y /E "%SourceFullPath%\include\*.*" "%InstallSDKPath%\include\TBB\"

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
