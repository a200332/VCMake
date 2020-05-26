@echo off
SETLOCAL EnableDelayedExpansion

set VCMakeRootPath=%1
set InstallSDKPath=%2
set SourceCodeName=%3
set BuildPlatformX=%4
set BuildLanguageX=%5

:: QT5 安装目录
set QT5InstallPath=%InstallSDKPath%\QT5\static

:: LLVM 安装目录
set LLVM_INSTALL_DIR=%InstallSDKPath%

:: 源代码目录
set "QTSRC=%VCMakeRootPath%Source\%SourceCodeName%"
set "SRCDisk=%QTSRC:~0,2%"
set "SRCPath=%QTSRC:~3%"
cd\
%SRCDisk%
cd\
cd "%SRCPath%"

:: 给 QT 5.14.2 打补丁
7z x "%VCMakeRootPath%\Single\%SourceCodeName%.7z" -y

:: 编译 <webengine 无法编译为 MT 静态库，所以要去除掉>
call configure -confirm-license -opensource -platform win32-msvc -mp -release -static -prefix "%QT5InstallPath%" -nomake examples  -nomake tests -skip qtwebengine
call jom
call jom install

:: 删除临时文件 
if exist "%VCMakeRootPath%%SourceCodeName%.tar.bz2" del "%VCMakeRootPath%%SourceCodeName%.tar.bz2"
if exist "%VCMakeRootPath%%SourceCodeName%.tar.gz"  del "%VCMakeRootPath%%SourceCodeName%.tar.gz"
if exist "%VCMakeRootPath%%SourceCodeName%.tar"     del "%VCMakeRootPath%%SourceCodeName%.tar"
if exist "%VCMakeRootPath%%SourceCodeName%.zip"     del "%VCMakeRootPath%%SourceCodeName%.zip"
