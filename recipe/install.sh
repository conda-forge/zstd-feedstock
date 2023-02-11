#!/bin/bash

set -exo pipefail

export CFLAGS="${CFLAGS} -O3 -fPIC"

# Fix undefined clock_gettime
declare -a _CMAKE_EXTRA_CONFIG
if [[ ${target_platform} =~ linux.* ]] && [[ ${CDT_NAME} == "cos6" ]]; then
  # I hate you so much CMake.
  LIBPTHREAD=$(find ${CONDA_BUILD_SYSROOT} -name "libpthread.so")
  _CMAKE_EXTRA_CONFIG+=(-DPTHREAD_LIBRARY=${LIBPTHREAD})
  LIBRT=$(find ${CONDA_BUILD_SYSROOT} -name "librt.so")
  _CMAKE_EXTRA_CONFIG+=(-DRT_LIBRARIES=${LIBRT})
  export LDFLAGS="${LDFLAGS} -lrt"
fi

make -j$CPU_COUNT -C contrib/pzstd all

if [[ "$PKG_NAME" == *static ]]; then
  ZSTD_BUILD_STATIC=ON
  # cannot build CLI without shared lib
  ZSTD_BUILD_SHARED=ON
else
  ZSTD_BUILD_STATIC=OFF
  ZSTD_BUILD_SHARED=ON
fi

pushd build/cmake
  FULL_AR=`which ${AR}`
  cmake -GNinja                            \
        -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
        -DCMAKE_INSTALL_LIBDIR="lib"       \
        -DCMAKE_PREFIX_PATH="${PREFIX}"    \
        -DCMAKE_AR=${FULL_AR}              \
        -DZSTD_BUILD_STATIC=${ZSTD_BUILD_STATIC} \
        -DZSTD_BUILD_SHARED=${ZSTD_BUILD_SHARED} \
        -DZSTD_PROGRAMS_LINK_SHARED=ON     \
        "${_CMAKE_EXTRA_CONFIG[@]}"

  ninja install
popd
