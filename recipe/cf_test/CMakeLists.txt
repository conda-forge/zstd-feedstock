project(cf_test LANGUAGES C)
cmake_minimum_required(VERSION 3.12)
find_package(zstd CONFIG REQUIRED)

# Build the test program
add_executable(test_zstd test_zstd.c)
target_link_libraries(test_zstd zstd)
