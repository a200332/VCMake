@echo off
SETLOCAL EnableDelayedExpansion

set VCMakeRootPath=%1
set InstallSDKPath=%2
set SourceCodeName=%3
set BuildPlatform_=%4
set BuildLanguageX=%5
set BuildHostX8664=%6
set BuildConfigure=%7

set BuildPath=%VCMakeRootPath%Build\%SourceCodeName%\%BuildHostX8664%

:: 检查是否有 patch 补丁文件
 if exist "%VCMakeRootPath%Patch\%SourceCodeName%.patch" (
    copy /Y "%VCMakeRootPath%Patch\%SourceCodeName%.patch" "%VCMakeRootPath%Source\%SourceCodeName%\%SourceCodeName%.patch"
		set "SRCFullPath=%VCMakeRootPath%Source\%SourceCodeName%"
		set "SRCDisk=%SRCFullPath:~0,2%"
		set "SRCPath=%SRCFullPath:~3%"
		cd\
		%SRCDisk%
		cd\
		cd "%SRCPath%"
    git apply "%SourceCodeName%.patch"
    del "%VCMakeRootPath%Source\%SourceCodeName%\%SourceCodeName%.patch"
 )

:: 建立编译目录
md %BuildPath%
cd %BuildPath%

meson %VCMakeRootPath%Source\%SourceCodeName% --buildtype=release --prefix=%InstallSDKPath% --backend=vs --build_tests=no

:: 字符串搜索替换
rem powershell -Command "(gc %liblzmavcxprojName%) -replace '%strMD%', '%strMT%' | Out-File %liblzmavcxprojName%"

MSBuild.exe %SourceCodeName%.sln /nologo /consoleloggerparameters:Verbosity=minimal /maxcpucount /nodeReuse:true^
 /target:Build ^
 /property:Configuration=Release;Platform=%BuildPlatform_%;DefineConstants="_VISUALC_;NeedFunctionPrototypes;FFI_BUILDING;GIO_COMPILATION;GLIB_COMPILATION;GOBJECT_COMPILATION;HAVE_CONFIG_H;LINK_SIZE=2;MATCH_LIMIT=10000000;MATCH_LIMIT_RECURSION=10000000;MAX_NAME_SIZE=32;MAX_NAME_COUNT=10000;MAX_DUPLENGTH=30000;NEWLINE=-1;PCRE_STATIC;POSIX_MALLOC_THRESHOLD=10;SUPPORT_UCP;SUPPORT_UTF8;_LIB"^
 /flp1:LogFile=zerror.log;errorsonly;Verbosity=diagnostic^
 /flp2:LogFile=zwarns.log;warningsonly;Verbosity=diagnostic

:: 源代码还原
  if exist "%VCMakeRootPath%Source\%SourceCodeName%\.git\" (
  set "SRCFullPath=%VCMakeRootPath%Source\%SourceCodeName%"
  git clean -d  -fx -f %SRCFullPath%
  git checkout %SRCFullPath%
  )
