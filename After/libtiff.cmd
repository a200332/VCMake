@echo off

set VCMakeRootPath=%1
set InstallSDKPath=%2
set SourceProjName=%3
set BuildPlatform_=%4
set BuildLanguageX=%5
set BuildHostX8664=%6
set BuildConfigure=%7

set "PKGInstallSDKPath=%InstallSDKPath:\=/%"
>%VCMakeRootPath%\after\libtiff-4.pc  echo prefix=%PKGInstallSDKPath%
>>%VCMakeRootPath%\after\libtiff-4.pc echo exec_prefix=%PKGInstallSDKPath%
>>%VCMakeRootPath%\after\libtiff-4.pc echo libdir=%PKGInstallSDKPath%/lib
>>%VCMakeRootPath%\after\libtiff-4.pc echo includedir=%PKGInstallSDKPath%/include

>>%VCMakeRootPath%\after\libtiff-4.pc echo Name: libtiff
>>%VCMakeRootPath%\after\libtiff-4.pc echo Description:  Tag Image File Format (TIFF) library.
>>%VCMakeRootPath%\after\libtiff-4.pc echo Version: 4.1.0
>>%VCMakeRootPath%\after\libtiff-4.pc echo Libs: -L%PKGInstallSDKPath%/lib -ltiff -lzlib -llzma -lzstd
>>%VCMakeRootPath%\after\libtiff-4.pc echo Libs.private:  -ltiff -lzlib -llzma -lzstd
>>%VCMakeRootPath%\after\libtiff-4.pc echo Cflags: -I%PKGInstallSDKPath%/include

copy /Y "%VCMakeRootPath%\after\libtiff-4.pc" "%InstallSDKPath%\lib\pkgconfig\libtiff-4.pc"
del  /Q "%VCMakeRootPath%\after\libtiff-4.pc"
