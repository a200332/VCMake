@echo off
setlocal EnableDelayedExpansion

set "BuildPath=%1"
set "SetupPath=%2"

set "TBBLibPath=%SetupPath%\lib\TBB.lib"
set "TwoTBBPath=%TBBLibPath:\=\\%"

set "strOld1=Qt5Core.lib;"
set "strNew1=Qt5Core.lib;userenv.lib;version.lib;zstd.lib;winmm.lib;netapi32.lib;"
set "strOld2=..\\..\\3rdparty\\lib\\Release\\ittnotify.lib;%TwoTBBPath%;"
set "strNew2=%TBBLibPath%;"

cd /D %BuildPath%

:: ×Ö·û´®ËÑË÷Ìæ»»
for /f %%i in ('dir /b /s /a:-d *.vcxproj') do (
  echo Ìæ»» %%i ÎÄ¼þ
  powershell -Command "(gc %%i) -replace '%strOld1%', '%strNew1%' | Out-File %%i"
  powershell -Command "(gc %%i) -replace '%strOld2%', '%strNew2%' | Out-File %%i"
)



