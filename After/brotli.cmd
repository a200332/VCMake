@echo off

set VCMakeRootPath=%1
set InstallSDKPath=%2
set SourceProjName=%3
set BuildPlatform_=%4
set BuildLanguageX=%5
set BuildHostX8664=%6
set BuildConfigure=%7

copy /Y "%InstallSDKPath%\lib\brotlicommon-static.lib" "%InstallSDKPath%\lib\brotlicommon.lib"
copy /Y "%InstallSDKPath%\lib\brotlidec-static.lib" "%InstallSDKPath%\lib\brotlidec.lib"
copy /Y "%InstallSDKPath%\lib\brotlienc-static.lib" "%InstallSDKPath%\lib\brotlienc.lib"
