@echo off

set "Bname=%1"
set "Bhttp=%2"
set "Bpath=%3"
set "Bulid=%4 %5 %6 %7 %8 %9"

if exist "%Bpath%Source\%Bname%"   goto Compile

:: svn ��������������·�� px86.txt/px64.txt ��,Ҳ������ϵͳ�����У�������Ҫ����ϵͳ����·���У���Ϊϵͳ����·���г�������
echo  ���� %Bname%
title ���� %Bname%
  svn checkout %Bhttp% %Bpath%Source\%Bname%
  
:Compile
echo  ���� %Bname%
title ���� %Bname%
 "%Bpath%Script\vcm" %Bpath% %Bname% %Bulid%
