#!/bin/bash
set -ex

export CFLAGS="${CFLAGS} -O3 -fPIC"
export LDFLAGS="${LDFLAGS} -Wl,-rpath,${PREFIX}/lib"

if [ "$(uname)" == "Linux"  ]; then
  # Fix undefined clock_gettime.
  export LDFLAGS="${LDFLAGS} -lrt"
fi

# Build
make -j$CPU_COUNT
make -j$CPU_COUNT -C contrib/pzstd all

# Install
make install PREFIX=$PREFIX
make -C contrib/pzstd install PREFIX=$PREFIX
