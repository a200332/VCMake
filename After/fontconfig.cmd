@echo off

set VCMakeRootPath=%1
set InstallSDKPath=%2
set SourceProjName=%3
set BuildPlatform_=%4
set BuildLanguageX=%5
set BuildHostX8664=%6
set BuildConfigure=%7

set "BuildFontConfigPath=%VCMakeRootPath%Build\%SourceProjName%\%BuildHostX8664%"
set "InstallInclude=%InstallSDKPath%\include\fontconfig"
md %InstallInclude%

echo 安装文件
copy /Y "%BuildFontConfigPath%\Release\fontconfig-static.lib" "%InstallSDKPath%\lib\fontconfig.lib"
copy /Y "%VCMakeRootPath%Source\%SourceProjName%\fontconfig\fcfreetype.h" "%InstallInclude%\fcfreetype.h"
copy /Y "%VCMakeRootPath%Source\%SourceProjName%\fontconfig\fcprivate.h"  "%InstallInclude%\fcprivate.h"
copy /Y "%VCMakeRootPath%Source\%SourceProjName%\fontconfig\fontconfig.h" "%InstallInclude%\fontconfig.h"
