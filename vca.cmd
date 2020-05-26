@echo off

set VCMakeRootPath=%1
set BuildLanguageX=%2
set BuildPlatform1=%3
set BuildPlatform2=%4
set BuildConfigure=%5
set InstallSDKPath=%6

set "Buildtype=%VCMakeRootPath% %BuildLanguageX% %BuildPlatform1% %BuildPlatform2% %BuildConfigure% %InstallSDKPath%"

:: 备注
:: 1：Windows10下，OpenSSL 编译需要管理员权限，因为它需要向系统盘写入数据；
:: 2：Clang 和 VTK，命令行编译会失败，用 GUI 编译成功后，再回到命令行编译；

:: 编译未成功，待验证
rem call "%VCMakeRootPath%Script\dlgit" ImageMagick-windows          https://github.com/ImageMagick/ImageMagick-windows.git              %Buildtype% nghttp2.sln
rem call "%VCMakeRootPath%Script\dlgit" glib                         https://github.com/GNOME/glib.git                                   %Buildtype% glib.sln
rem call "%VCMakeRootPath%Script\dlzip" ncurses-6.2                  https://ftp.gnu.org/pub/gnu/ncurses/ncurses-6.2.tar.gz              %Buildtype% ncurses.sln
rem call "%VCMakeRootPath%Script\dlgit" fish                         https://git.sr.ht/~faho/fish                                        %Buildtype% fish.sln
rem call "%VCMakeRootPath%Script\dlgit" PDCurses                     https://github.com/Bill-Gray/PDCurses.git                           %Buildtype% PDCurses.sln
rem call "%VCMakeRootPath%Script\dlgit" doxygen                      https://github.com/doxygen/doxygen.git                              %Buildtype% doxygen.sln
rem call "%VCMakeRootPath%Script\dlgit" CastXML                      https://github.com/CastXML/CastXML.git                              %Buildtype% CastXML.sln
rem call "%VCMakeRootPath%Script\dlgit" qTox                         https://github.com/qTox/qTox.git                                    %Buildtype% qTox.sln

:: 编译成功
rem call "%VCMakeRootPath%Script\dlzip" zlib-1.2.11                  https://www.zlib.net/zlib-1.2.11.tar.gz                             %Buildtype% zlib.sln
rem call "%VCMakeRootPath%Script\dlgit" xz                           https://git.tukaani.org/xz.git                                      %Buildtype% xz.sln
rem call "%VCMakeRootPath%Script\dlgit" bzip2                        https://github.com/osrf/bzip2_cmake.git                             %Buildtype% bzip2.sln
rem call "%VCMakeRootPath%Script\dlgit" z3                           https://github.com/Z3Prover/z3.git                                  %Buildtype% z3.sln
rem call "%VCMakeRootPath%Script\dlgit" lz4                          https://github.com/lz4/lz4.git                                      %Buildtype% lz4.sln
rem call "%VCMakeRootPath%Script\dlgit" snappy                       https://github.com/willyd/snappy.git                                %Buildtype% snappy.sln
rem call "%VCMakeRootPath%Script\dlgit" zstd                         https://github.com/facebook/zstd.git                                %Buildtype% zstd.sln
rem call "%VCMakeRootPath%Script\dlgit" giflib                       https://github.com/xbmc/giflib.git                                  %Buildtype% giflib.sln
rem call "%VCMakeRootPath%Script\dlgit" libjpeg-turbo                https://github.com/libjpeg-turbo/libjpeg-turbo.git                  %Buildtype% libjpeg-turbo.sln
rem call "%VCMakeRootPath%Script\dlgit" libpng                       https://github.com/glennrp/libpng.git                               %Buildtype% libpng.sln
rem call "%VCMakeRootPath%Script\dlgit" libtiff                      https://gitlab.com/libtiff/libtiff.git                              %Buildtype% tiff.sln
rem call "%VCMakeRootPath%Script\dlgit" openjpeg                     https://github.com/uclouvain/openjpeg.git                           %Buildtype% openjpeg.sln
rem call "%VCMakeRootPath%Script\dlgit" libwebp                      https://chromium.googlesource.com/webm/libwebp                      %Buildtype% webp.sln
rem call "%VCMakeRootPath%Script\dlgit" leptonica                    https://github.com/DanBloomberg/leptonica.git                       %Buildtype% leptonica.sln
rem call "%VCMakeRootPath%Script\dlgit" tesseract                    https://github.com/tesseract-ocr/tesseract.git                      %Buildtype% tesseract.sln
rem call "%VCMakeRootPath%Script\dlzip" SDL2-2.0.12                  http://www.libsdl.org/release/SDL2-2.0.12.tar.gz                    %Buildtype% sdl2.sln
rem call "%VCMakeRootPath%Script\dlgit" gflags                       https://github.com/gflags/gflags.git                                %Buildtype% gflags.sln
rem call "%VCMakeRootPath%Script\dlgit" glog                         https://github.com/google/glog.git                                  %Buildtype% glog.sln
rem call "%VCMakeRootPath%Script\dlgit" gtest                        https://github.com/google/googletest.git                            %Buildtype% googletest-distribution.sln
rem call "%VCMakeRootPath%Script\dlzip" sqlite-snapshot-202003121754 https://www.sqlite.org/snapshot/sqlite-snapshot-202003121754.tar.gz %Buildtype% sqlite.sln
rem call "%VCMakeRootPath%Script\dlgit" libssh2                      https://github.com/libssh2/libssh2.git                              %Buildtype% libssh2.sln
rem call "%VCMakeRootPath%Script\dlgit" freetype                     https://github.com/winlibs/freetype.git                             %Buildtype% freetype.sln
rem call "%VCMakeRootPath%Script\dlgit" harfbuzz                     https://github.com/harfbuzz/harfbuzz.git                            %Buildtype% harfbuzz.sln
rem call "%VCMakeRootPath%Script\dlgit" hdf5                         https://github.com/live-clones/hdf5.git                             %Buildtype% hdf5.sln
rem call "%VCMakeRootPath%Script\dlgit" libiconv                     https://github.com/LuaDist/libiconv.git                             %Buildtype% libiconv.sln
rem call "%VCMakeRootPath%Script\dlgit" gettext                      https://github.com/winlibs/gettext.git                              %Buildtype% gettext.sln
rem call "%VCMakeRootPath%Script\dlgit" libxml2                      https://github.com/GNOME/libxml2.git                                %Buildtype% libxml2.sln
rem call "%VCMakeRootPath%Script\dlgit" pcre                         https://github.com/svn2github/pcre.git                              %Buildtype% pcre.sln
rem call "%VCMakeRootPath%Script\dlzip" pcre2-10.34                  https://downloads.sourceforge.net/pcre/pcre2-10.34.tar.bz2          %Buildtype% pcre2.sln
rem call "%VCMakeRootPath%Script\dlgit" boost                        https://github.com/boostorg/boost.git                               %Buildtype% boost.sln
rem call "%VCMakeRootPath%Script\dlgit" leveldb                      https://github.com/willyd/leveldb.git                               %Buildtype% leveldb.sln
rem call "%VCMakeRootPath%Script\dlgit" openssl                      https://github.com/openssl/openssl.git                              %Buildtype% openssl.sln
rem call "%VCMakeRootPath%Script\dlgit" nghttp2                      https://github.com/nghttp2/nghttp2.git                              %Buildtype% nghttp2.sln
rem call "%VCMakeRootPath%Script\dlgit" brotli                       https://github.com/google/brotli.git                                %Buildtype% brotli.sln
rem call "%VCMakeRootPath%Script\dlgit" eigen                        https://github.com/eigenteam/eigen-git-mirror.git                   %Buildtype% eigen3.sln
rem call "%VCMakeRootPath%Script\dlgit" c-ares                       https://github.com/c-ares/c-ares.git                                %Buildtype% c-ares.sln
rem call "%VCMakeRootPath%Script\dlgit" curl                         https://github.com/curl/curl.git                                    %Buildtype% curl.sln
rem call "%VCMakeRootPath%Script\dlgit" fribidi-cmake                https://github.com/tamaskenez/fribidi-cmake.git                     %Buildtype% fribidi.sln
rem call "%VCMakeRootPath%Script\dlgit" tinyxml2                     https://github.com/leethomason/tinyxml2.git                         %Buildtype% tinyxml2.sln
rem call "%VCMakeRootPath%Script\dlgit" llvm                         https://github.com/llvm/llvm-project.git                            %Buildtype% llvm.sln
rem call "%VCMakeRootPath%Script\dlgit" libexpat                     https://github.com/libexpat/libexpat.git                            %Buildtype% expat.sln
rem call "%VCMakeRootPath%Script\dlgit" fontconfig                   https://github.com/georgegerdin/fontconfig-cmake.git                %Buildtype% fontconfig.sln
rem call "%VCMakeRootPath%Script\dlgit" icu                          https://github.com/hunter-packages/icu.git                          %Buildtype% icu.sln
rem call "%VCMakeRootPath%Script\dlgit" websocketpp                  https://github.com/zaphoyd/websocketpp.git                          %Buildtype% websocketpp.sln
rem call "%VCMakeRootPath%Script\dlgit" PROJ                         https://github.com/OSGeo/PROJ.git                                   %Buildtype% PROJ.sln
rem call "%VCMakeRootPath%Script\dlgit" ceres                        https://github.com/ceres-solver/ceres-solver.git                    %Buildtype% ceres.sln
rem call "%VCMakeRootPath%Script\dlgit" pixman                       https://gitlab.freedesktop.org/pixman/pixman                        %Buildtype% pixman.sln
rem call "%VCMakeRootPath%Script\dlgit" cairo                        https://github.com/freedesktop/cairo.git                            %Buildtype% cairo.sln
rem call "%VCMakeRootPath%Script\dlzip" qt-everywhere-src-5.14.2     http://download.qt.io/official_releases/qt/5.14/5.14.2/single/qt-everywhere-src-5.14.2.tar.xz   %Buildtype% QT.sln
rem call "%VCMakeRootPath%Script\dlzip" VTK-9.0.0                    https://www.vtk.org/files/release/9.0/VTK-9.0.0.tar.gz              %Buildtype% VTK.sln
rem call "%VCMakeRootPath%Script\dlzip" libogg-1.3.4                 http://downloads.xiph.org/releases/ogg/libogg-1.3.4.tar.gz          %Buildtype% libogg.sln
rem call "%VCMakeRootPath%Script\dlzip" libvorbis-1.3.6              http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.6.tar.gz    %Buildtype% libvorbis.sln
rem call "%VCMakeRootPath%Script\dlzip" libtheora-1.1.1              http://downloads.xiph.org/releases/theora/libtheora-1.1.1.tar.bz2   %Buildtype% libtheora.sln
rem call "%VCMakeRootPath%Script\dlzip" flac-1.3.2                   http://downloads.xiph.org/releases/flac/flac-1.3.2.tar.xz           %Buildtype% flac.sln
rem call "%VCMakeRootPath%Script\dlgit" tbb                          https://github.com/intel/tbb.git                                    %Buildtype% tbb.sln
call "%VCMakeRootPath%Script\dlgit" opencv                       https://github.com/opencv/opencv.git                                %Buildtype%\opencv\static opencv.sln
rem call "%VCMakeRootPath%Script\dlgit" rocksdb                      https://github.com/facebook/rocksdb.git                             %Buildtype% rocksdb.sln
rem call "%VCMakeRootPath%Script\dlgit" pytorch                      https://github.com/pytorch/pytorch.git                              %Buildtype% Caffe2.sln
