pushd "%SRC_DIR%"\build\cmake
cmake -GNinja ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ^
    -DCMAKE_INSTALL_LIBDIR="lib" ^
    -DCMAKE_PREFIX_PATH="%LIBRARY_PREFIX%" ^
    -DZSTD_BUILD_SHARED=ON
cmake --build . --target install
copy %PREFIX%\Library\bin\zstd.dll %PREFIX%\Library\bin\libzstd.dll
copy %PREFIX%\Library\lib\zstd.lib %PREFIX%\Library\lib\libzstd.lib
