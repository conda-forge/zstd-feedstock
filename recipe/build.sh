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

# Install
make install PREFIX=$PREFIX
