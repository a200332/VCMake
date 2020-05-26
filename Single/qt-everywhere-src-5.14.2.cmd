@echo off
SETLOCAL EnableDelayedExpansion

set VCMakeRootPath=%1
set InstallSDKPath=%2
set SourceCodeName=%3
set BuildPlatformX=%4
set BuildLanguageX=%5

:: QT5 ��װĿ¼
set QT5InstallPath=%InstallSDKPath%\QT5\static

:: LLVM ��װĿ¼
set LLVM_INSTALL_DIR=%InstallSDKPath%

:: Դ����Ŀ¼
set "QTSRC=%VCMakeRootPath%Source\%SourceCodeName%"
set "SRCDisk=%QTSRC:~0,2%"
set "SRCPath=%QTSRC:~3%"
cd\
%SRCDisk%
cd\
cd "%SRCPath%"

:: �� QT 5.14.2 �򲹶�
7z x "%VCMakeRootPath%\Single\%SourceCodeName%.7z" -y

:: ���� <webengine �޷�����Ϊ MT ��̬�⣬����Ҫȥ����>
call configure -confirm-license -opensource -platform win32-msvc -mp -release -static -prefix "%QT5InstallPath%" -nomake examples  -nomake tests -skip qtwebengine
call jom
call jom install

:: ɾ����ʱ�ļ� 
if exist "%VCMakeRootPath%%SourceCodeName%.tar.bz2" del "%VCMakeRootPath%%SourceCodeName%.tar.bz2"
if exist "%VCMakeRootPath%%SourceCodeName%.tar.gz"  del "%VCMakeRootPath%%SourceCodeName%.tar.gz"
if exist "%VCMakeRootPath%%SourceCodeName%.tar"     del "%VCMakeRootPath%%SourceCodeName%.tar"
if exist "%VCMakeRootPath%%SourceCodeName%.zip"     del "%VCMakeRootPath%%SourceCodeName%.zip"
