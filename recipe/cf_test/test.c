#include <string.h>
#include <zstd.h>

int main(void) {
    const char input[] = "Zstd CMake target round trip";
    char compressed[128];
    char decompressed[sizeof(input)];
    size_t size = ZSTD_compress(compressed, sizeof(compressed), input, sizeof(input), 1);
    if (ZSTD_isError(size)) return 1;
    size = ZSTD_decompress(decompressed, sizeof(decompressed), compressed, size);
    return ZSTD_isError(size) || size != sizeof(input) ||
           memcmp(input, decompressed, sizeof(input)) != 0;
}
