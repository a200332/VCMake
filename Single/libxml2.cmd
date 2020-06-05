@echo off
SETLOCAL EnableDelayedExpansion

set VCMakeRootPath=%1
set InstallSDKPath=%2
set SourceCodeName=%3
set BuildPlatform_=%4
set BuildLanguageX=%5
set BuildHostX8664=%6
set BuildConfigure=%7
set "libxml2SRC=%VCMakeRootPath%Source\%SourceCodeName%"

:: 检查是否有 patch 补丁文件
 if exist "%VCMakeRootPath%Patch\%SourceCodeName%.patch" (
   copy /Y "%VCMakeRootPath%Patch\%SourceCodeName%.patch" "%VCMakeRootPath%Source\%SourceCodeName%\%SourceCodeName%.patch"
	 set "SRCDisk=%libxml2SRC:~0,2%"
	 set "SRCPath=%libxml2SRC:~3%"
	 cd\
	 %SRCDisk%
	 cd\
	 cd "%SRCPath%"
   git apply "%SourceCodeName%.patch"
   del "%VCMakeRootPath%Source\%SourceCodeName%\%SourceCodeName%.patch"
 )

:: 进入目录，编译
set "SRCDisk=%libxml2SRC:~0,2%"
set "SRCPath=%libxml2SRC:~3%"
cd\
%SRCDisk%
cd\
cd "%SRCPath%\win32"
cscript configure.js compiler=msvc
nmake -f Makefile.msvc

copy /Y "bin.msvc\%SourceCodeName%_a.lib" "%InstallSDKPath%\lib\libxml2.lib"
md "%InstallSDKPath%\include\libxml2"
copy /Y "%VCMakeRootPath%Source\%SourceCodeName%\include\libxml\c14n.h"              "%InstallSDKPath%\include\libxml\c14n.h"              
copy /Y "%VCMakeRootPath%Source\%SourceCodeName%\include\libxml\catalog.h"           "%InstallSDKPath%\include\libxml\catalog.h"           
copy /Y "%VCMakeRootPath%Source\%SourceCodeName%\include\libxml\chvalid.h"           "%InstallSDKPath%\include\libxml\chvalid.h"           
copy /Y "%VCMakeRootPath%Source\%SourceCodeName%\include\libxml\debugXML.h"          "%InstallSDKPath%\include\libxml\debugXML.h"          
copy /Y "%VCMakeRootPath%Source\%SourceCodeName%\include\libxml\dict.h"              "%InstallSDKPath%\include\libxml\dict.h"              
copy /Y "%VCMakeRootPath%Source\%SourceCodeName%\include\libxml\DOCBparser.h"        "%InstallSDKPath%\include\libxml\DOCBparser.h"        
copy /Y "%VCMakeRootPath%Source\%SourceCodeName%\include\libxml\encoding.h"          "%InstallSDKPath%\include\libxml\encoding.h"          
copy /Y "%VCMakeRootPath%Source\%SourceCodeName%\include\libxml\entities.h"          "%InstallSDKPath%\include\libxml\entities.h"          
copy /Y "%VCMakeRootPath%Source\%SourceCodeName%\include\libxml\globals.h"           "%InstallSDKPath%\include\libxml\globals.h"           
copy /Y "%VCMakeRootPath%Source\%SourceCodeName%\include\libxml\hash.h"              "%InstallSDKPath%\include\libxml\hash.h"              
copy /Y "%VCMakeRootPath%Source\%SourceCodeName%\include\libxml\HTMLparser.h"        "%InstallSDKPath%\include\libxml\HTMLparser.h"        
copy /Y "%VCMakeRootPath%Source\%SourceCodeName%\include\libxml\HTMLtree.h"          "%InstallSDKPath%\include\libxml\HTMLtree.h"          
copy /Y "%VCMakeRootPath%Source\%SourceCodeName%\include\libxml\list.h"              "%InstallSDKPath%\include\libxml\list.h"              
copy /Y "%VCMakeRootPath%Source\%SourceCodeName%\include\libxml\nanoftp.h"           "%InstallSDKPath%\include\libxml\nanoftp.h"           
copy /Y "%VCMakeRootPath%Source\%SourceCodeName%\include\libxml\nanohttp.h"          "%InstallSDKPath%\include\libxml\nanohttp.h"          
copy /Y "%VCMakeRootPath%Source\%SourceCodeName%\include\libxml\parser.h"            "%InstallSDKPath%\include\libxml\parser.h"            
copy /Y "%VCMakeRootPath%Source\%SourceCodeName%\include\libxml\parserInternals.h"   "%InstallSDKPath%\include\libxml\parserInternals.h"   
copy /Y "%VCMakeRootPath%Source\%SourceCodeName%\include\libxml\pattern.h"           "%InstallSDKPath%\include\libxml\pattern.h"           
copy /Y "%VCMakeRootPath%Source\%SourceCodeName%\include\libxml\relaxng.h"           "%InstallSDKPath%\include\libxml\relaxng.h"           
copy /Y "%VCMakeRootPath%Source\%SourceCodeName%\include\libxml\SAX.h"               "%InstallSDKPath%\include\libxml\SAX.h"               
copy /Y "%VCMakeRootPath%Source\%SourceCodeName%\include\libxml\SAX2.h"              "%InstallSDKPath%\include\libxml\SAX2.h"              
copy /Y "%VCMakeRootPath%Source\%SourceCodeName%\include\libxml\schemasInternals.h"  "%InstallSDKPath%\include\libxml\schemasInternals.h"  
copy /Y "%VCMakeRootPath%Source\%SourceCodeName%\include\libxml\schematron.h"        "%InstallSDKPath%\include\libxml\schematron.h"        
copy /Y "%VCMakeRootPath%Source\%SourceCodeName%\include\libxml\threads.h"           "%InstallSDKPath%\include\libxml\threads.h"           
copy /Y "%VCMakeRootPath%Source\%SourceCodeName%\include\libxml\tree.h"              "%InstallSDKPath%\include\libxml\tree.h"              
copy /Y "%VCMakeRootPath%Source\%SourceCodeName%\include\libxml\uri.h"               "%InstallSDKPath%\include\libxml\uri.h"               
copy /Y "%VCMakeRootPath%Source\%SourceCodeName%\include\libxml\valid.h"             "%InstallSDKPath%\include\libxml\valid.h"             
copy /Y "%VCMakeRootPath%Source\%SourceCodeName%\include\libxml\xinclude.h"          "%InstallSDKPath%\include\libxml\xinclude.h"          
copy /Y "%VCMakeRootPath%Source\%SourceCodeName%\include\libxml\xlink.h"             "%InstallSDKPath%\include\libxml\xlink.h"             
copy /Y "%VCMakeRootPath%Source\%SourceCodeName%\include\libxml\xmlautomata.h"       "%InstallSDKPath%\include\libxml\xmlautomata.h"       
copy /Y "%VCMakeRootPath%Source\%SourceCodeName%\include\libxml\xmlerror.h"          "%InstallSDKPath%\include\libxml\xmlerror.h"          
copy /Y "%VCMakeRootPath%Source\%SourceCodeName%\include\libxml\xmlexports.h"        "%InstallSDKPath%\include\libxml\xmlexports.h"        
copy /Y "%VCMakeRootPath%Source\%SourceCodeName%\include\libxml\xmlIO.h"             "%InstallSDKPath%\include\libxml\xmlIO.h"             
copy /Y "%VCMakeRootPath%Source\%SourceCodeName%\include\libxml\xmlmemory.h"         "%InstallSDKPath%\include\libxml\xmlmemory.h"         
copy /Y "%VCMakeRootPath%Source\%SourceCodeName%\include\libxml\xmlmodule.h"         "%InstallSDKPath%\include\libxml\xmlmodule.h"         
copy /Y "%VCMakeRootPath%Source\%SourceCodeName%\include\libxml\xmlreader.h"         "%InstallSDKPath%\include\libxml\xmlreader.h"         
copy /Y "%VCMakeRootPath%Source\%SourceCodeName%\include\libxml\xmlregexp.h"         "%InstallSDKPath%\include\libxml\xmlregexp.h"         
copy /Y "%VCMakeRootPath%Source\%SourceCodeName%\include\libxml\xmlsave.h"           "%InstallSDKPath%\include\libxml\xmlsave.h"           
copy /Y "%VCMakeRootPath%Source\%SourceCodeName%\include\libxml\xmlschemas.h"        "%InstallSDKPath%\include\libxml\xmlschemas.h"        
copy /Y "%VCMakeRootPath%Source\%SourceCodeName%\include\libxml\xmlschemastypes.h"   "%InstallSDKPath%\include\libxml\xmlschemastypes.h"   
copy /Y "%VCMakeRootPath%Source\%SourceCodeName%\include\libxml\xmlstring.h"         "%InstallSDKPath%\include\libxml\xmlstring.h"         
copy /Y "%VCMakeRootPath%Source\%SourceCodeName%\include\libxml\xmlunicode.h"        "%InstallSDKPath%\include\libxml\xmlunicode.h"        
copy /Y "%VCMakeRootPath%Source\%SourceCodeName%\include\libxml\xmlversion.h"        "%InstallSDKPath%\include\libxml\xmlversion.h"        
copy /Y "%VCMakeRootPath%Source\%SourceCodeName%\include\libxml\xmlwriter.h"         "%InstallSDKPath%\include\libxml\xmlwriter.h"         
copy /Y "%VCMakeRootPath%Source\%SourceCodeName%\include\libxml\xpath.h"             "%InstallSDKPath%\include\libxml\xpath.h"             
copy /Y "%VCMakeRootPath%Source\%SourceCodeName%\include\libxml\xpathInternals.h"    "%InstallSDKPath%\include\libxml\xpathInternals.h"    
copy /Y "%VCMakeRootPath%Source\%SourceCodeName%\include\libxml\xpointer.h"          "%InstallSDKPath%\include\libxml\xpointer.h"          

:: 安装 PC 文件
set "InstallPCPath=%InstallSDKPath:\=/%"
@echo prefix=%InstallPCPath%>%InstallSDKPath%\lib\pkgconfig\libxml-2.0.pc
@echo exec_prefix=${prefix}>>%InstallSDKPath%\lib\pkgconfig\libxml-2.0.pc
@echo libdir=${exec_prefix}/lib>>%InstallSDKPath%\lib\pkgconfig\libxml-2.0.pc
@echo includedir=${prefix}/include>>%InstallSDKPath%\lib\pkgconfig\libxml-2.0.pc
@echo modules=1

@echo Name: libXML>>%InstallSDKPath%\lib\pkgconfig\libxml-2.0.pc
@echo Version: 2.9.10>>%InstallSDKPath%\lib\pkgconfig\libxml-2.0.pc
@echo Description: libXML library version2.>>%InstallSDKPath%\lib\pkgconfig\libxml-2.0.pc
@echo Requires:>>%InstallSDKPath%\lib\pkgconfig\libxml-2.0.pc
@echo Libs: -L${libdir} -lxml2>>%InstallSDKPath%\lib\pkgconfig\libxml-2.0.pc
@echo Libs.private:   -L${libdir} -lz -L${libdir} -llzma  -liconv  -lws2_32 >>%InstallSDKPath%\lib\pkgconfig\libxml-2.0.pc
@echo Cflags: -I${includedir}/libxml2 >>%InstallSDKPath%\lib\pkgconfig\libxml-2.0.pc

:: 源代码还原
git clean -d  -fx -f %libxml2SRC%
git checkout %libxml2SRC%
