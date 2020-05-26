@echo off
SETLOCAL EnableDelayedExpansion

set SourceCodePath=%1
set InstallSDKPath=%2
set BuildPlatform_=%3
set BuildLanguageX=%4
set BakupCurrentCD=%5
set SourceProjName=%6

cd %SourceCodePath%

set "SourceCodePathLine=%SourceCodePath:\=/%"

:: 下载子模块
bash --login -i -c "./CloneRepositories.sh https://github.com/ImageMagick full"

:: 检查是否有 patch 补丁文件
 if exist "%BakupCurrentCD%\Patch\%SourceProjName%.patch" (
   copy /Y "%BakupCurrentCD%\Patch\%SourceProjName%.patch" "%BakupCurrentCD%\Source\%SourceProjName%\%SourceProjName%.patch"
   cd "%BakupCurrentCD%\Source\%SourceProjName%"
   git apply "%SourceProjName%.patch"
   del "%BakupCurrentCD%\Source\%SourceProjName%\%SourceProjName%.patch"
 )

MSBuild.exe ".\VisualMagick\configure\configure.sln"^
 /nologo /consoleloggerparameters:Verbosity=minimal /maxcpucount /nodeReuse:true^
 /target:Build /property:Configuration=Release;Platform=%BuildPlatform_%^
 /flp1:LogFile=zxerror.log;errorsonly;Verbosity=diagnostic^
 /flp2:LogFile=zxwarns.log;warningsonly;Verbosity=diagnostic

cd "VisualMagick\configure"
call configure.exe

MSBuild.exe %SourceCodePath%\VisualMagick\VisualStaticMT.sln^
 /nologo /consoleloggerparameters:Verbosity=minimal /maxcpucount /nodeReuse:true^
 /target:Build /property:Configuration=Release;Platform=%BuildPlatform_%^
 /flp1:LogFile=zxerror.log;errorsonly;Verbosity=diagnostic^
 /flp2:LogFile=zxwarns.log;warningsonly;Verbosity=diagnostic
