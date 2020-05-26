@echo off
SETLOCAL EnableDelayedExpansion

set VCMakeRootPath=%1
set InstallSDKPath=%2
set SourceProjName=%3
set BuildPlatform_=%4
set BuildLanguageX=%5
set BuildHostX8664=%6
set BuildConfigure=%7

:: Դ����Ŀ¼
set "OpenSSLSRC=%VCMakeRootPath%Source\%SourceProjName%"
set "SRCDisk=%OpenSSLSRC:~0,2%"
set "SRCPath=%OpenSSLSRC:~3%"
cd\
%SRCDisk%
cd\
cd "%SRCPath%"

:: ����ƽ̨
if %BuildPlatform_%==Win32 ( 
  set bp=VC-WIN32 
) else (
  set bp=VC-WIN64A 
)

:: ����
perl Configure %bp% no-shared --prefix="%InstallSDKPath%"
nmake
nmake install

:: ����֤��
xcopy /Y /E "%ProgramFiles(x86)%\Common Files\SSL\*.*" "%InstallSDKPath%\CA\SSL\"

:: ��װ PC �ļ�
set "InstallPCPath=%InstallSDKPath:\=/%"

@echo prefix=%InstallPCPath%>%InstallSDKPath%\lib\pkgconfig\openssl.pc
@echo exec_prefix=${prefix}>>%InstallSDKPath%\lib\pkgconfig\openssl.pc
@echo libdir=${exec_prefix}/lib>>%InstallSDKPath%\lib\pkgconfig\openssl.pc
@echo includedir=${prefix}/include>>%InstallSDKPath%\lib\pkgconfig\openssl.pc
@echo Name: OpenSSL>>%InstallSDKPath%\lib\pkgconfig\openssl.pc
@echo Description: Secure Sockets Layer and cryptography libraries and tools>>%InstallSDKPath%\lib\pkgconfig\openssl.pc
@echo Version: 3.0>>%InstallSDKPath%\lib\pkgconfig\openssl.pc
@echo Requires: libssl libcrypto>>%InstallSDKPath%\lib\pkgconfig\openssl.pc

@echo prefix=%InstallPCPath%>%InstallSDKPath%\lib\pkgconfig\libcrypto.pc
@echo exec_prefix=${prefix}>>%InstallSDKPath%\lib\pkgconfig\libcrypto.pc
@echo libdir=${exec_prefix}/lib>>%InstallSDKPath%\lib\pkgconfig\libcrypto.pc
@echo includedir=${prefix}/include>>%InstallSDKPath%\lib\pkgconfig\libcrypto.pc
@echo enginesdir=${libdir}/engines-1_1>>%InstallSDKPath%\lib\pkgconfig\libcrypto.pc
@echo Name: OpenSSL-libcrypto>>%InstallSDKPath%\lib\pkgconfig\libcrypto.pc
@echo Description: OpenSSL cryptography library>>%InstallSDKPath%\lib\pkgconfig\libcrypto.pc
@echo Version: 3.0>>%InstallSDKPath%\lib\pkgconfig\libcrypto.pc
@echo Libs: -L${libdir} -lcrypto>>%InstallSDKPath%\lib\pkgconfig\libcrypto.pc
@echo Libs.private: -lws2_32 -lgdi32 -lcrypt32 >>%InstallSDKPath%\lib\pkgconfig\libcrypto.pc
@echo Cflags: -I${includedir}>>%InstallSDKPath%\lib\pkgconfig\libcrypto.pc

@echo prefix=%InstallPCPath%>%InstallSDKPath%\lib\pkgconfig\libssl.pc
@echo exec_prefix=${prefix}>>%InstallSDKPath%\lib\pkgconfig\libssl.pc
@echo libdir=${exec_prefix}/lib>>%InstallSDKPath%\lib\pkgconfig\libssl.pc
@echo includedir=${prefix}/include>>%InstallSDKPath%\lib\pkgconfig\libssl.pc
@echo Name: OpenSSL-libssl>>%InstallSDKPath%\lib\pkgconfig\libssl.pc
@echo Description: Secure Sockets Layer and cryptography libraries>>%InstallSDKPath%\lib\pkgconfig\libssl.pc
@echo Version: 3.0>>%InstallSDKPath%\lib\pkgconfig\libssl.pc
@echo Requires.private: libcrypto>>%InstallSDKPath%\lib\pkgconfig\libssl.pc
@echo Libs: -L${libdir} -lssl>>%InstallSDKPath%\lib\pkgconfig\libssl.pc
@echo Cflags: -I${includedir}>>%InstallSDKPath%\lib\pkgconfig\libssl.pc

:: ���밲װ��ϣ�������ʱ�ļ�
nmake clean
