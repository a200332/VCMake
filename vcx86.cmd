@echo off
Color A
setlocal EnableDelayedExpansion
  
:: 设置网络代理；如果没有网络代理，可以注释掉这两行代码；
set http_proxy=http://127.0.0.1:41081
set https_proxy=http://127.0.0.1:41081

:: 设置当前目录
set "VCMakeRootPath=%~dp0"

:: 编译参数
set "BuildLang=VS2017"
set "Platform1=Win32"
set "Platform2=x86"
set "Configure=Release"
set "SetupPath=%VCMakeRootPath%VSSDK\%Platform2%"
  
"%VCMakeRootPath%\Script\vcc.cmd" %VCMakeRootPath% %BuildLang% %Platform1% %Platform2% %Configure% %SetupPath% 
