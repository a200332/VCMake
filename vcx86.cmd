@echo off
Color A
setlocal EnableDelayedExpansion
  
:: ��������������û�������������ע�͵������д��룻
set http_proxy=http://127.0.0.1:41081
set https_proxy=http://127.0.0.1:41081

:: ���õ�ǰĿ¼
set "VCMakeRootPath=%~dp0"

:: �������
set "BuildLang=VS2017"
set "Platform1=Win32"
set "Platform2=x86"
set "Configure=Release"
set "SetupPath=%VCMakeRootPath%VSSDK\%Platform2%"
  
"%VCMakeRootPath%\Script\vcc.cmd" %VCMakeRootPath% %BuildLang% %Platform1% %Platform2% %Configure% %SetupPath% 
