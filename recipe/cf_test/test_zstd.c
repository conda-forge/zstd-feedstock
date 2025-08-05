#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <zstd.h>

int main() {
    const char* test_data = "Hello, zstd! This is a test string to compress and decompress.";
    size_t data_size = strlen(test_data);
    
    // Calculate compression bound
    size_t compressed_bound = ZSTD_compressBound(data_size);
    char* compressed_data = malloc(compressed_bound);
    
    if (!compressed_data) {
        fprintf(stderr, "Failed to allocate memory for compressed data\n");
        return 1;
    }
    
    // Compress the data
    size_t compressed_size = ZSTD_compress(compressed_data, compressed_bound, 
                                          test_data, data_size, 1);
    
    if (ZSTD_isError(compressed_size)) {
        fprintf(stderr, "Compression failed: %s\n", ZSTD_getErrorName(compressed_size));
        free(compressed_data);
        return 1;
    }
    
    // Allocate memory for decompressed data
    char* decompressed_data = malloc(data_size);
    if (!decompressed_data) {
        fprintf(stderr, "Failed to allocate memory for decompressed data\n");
        free(compressed_data);
        return 1;
    }
    
    // Decompress the data
    size_t decompressed_size = ZSTD_decompress(decompressed_data, data_size,
                                              compressed_data, compressed_size);
    
    if (ZSTD_isError(decompressed_size)) {
        fprintf(stderr, "Decompression failed: %s\n", ZSTD_getErrorName(decompressed_size));
        free(compressed_data);
        free(decompressed_data);
        return 1;
    }
    
    // Verify the decompressed data matches the original
    if (decompressed_size != data_size || 
        memcmp(test_data, decompressed_data, data_size) != 0) {
        fprintf(stderr, "Decompressed data does not match original\n");
        free(compressed_data);
        free(decompressed_data);
        return 1;
    }
    
    printf("zstd test passed! Successfully compressed and decompressed data.\n");
    printf("Original size: %zu, Compressed size: %zu\n", data_size, compressed_size);
    
    free(compressed_data);
    free(decompressed_data);
    return 0;
} 