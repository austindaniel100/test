# Makefile
# Generic Makefile for making cuda programs
#
BIN               := LinKeccakTree
 
# Cuda toolkit path
CUDA_INSTALL_PATH := C:\Program Files\NVIDIA_GPU_Computing_Toolkit\CUDA\v11.6\bin

#
# Cuda SDK path MUST BE CHANGED 
# 
CUDA_SDK_PATH     := C:\Program Files\NVIDIA_GPU_Computing_Toolkit\CUDA\v11.6\bin


INCLUDES += -I. -I$(CUDA_INSTALL_PATH)/include -I$(CUDA_SDK_PATH)/common/inc
#warning 64 bits lib linking
LIBS              := -L$(CUDA_INSTALL_PATH)/lib64

#warning 64 bits compiling 
CFLAGS            := -O2 -m64
NVCCFLAGS         := -O2 -m64 -Xptxas -v -arch sm_11
# -arch sm_11
 

LDFLAGS           := -lrt -lm -lcudart
# compilers
NVCC              := nvcc
CC                := gcc
LINKER            := gcc
# files
C_SOURCES         := $(wildcard *.c)
CU_SOURCES        := $(wildcard *.cu)
HEADERS           := $(wildcard *.h)
C_OBJS            := $(patsubst %.c, %.o, $(C_SOURCES))
CU_OBJS           := $(patsubst %.cu, %.o, $(CU_SOURCES))
 
$(BIN): clean $(C_OBJS) $(CU_OBJS) $(HEADERS)
	$(LINKER) -o $(BIN) $(CU_OBJS) $(C_OBJS) $(LDFLAGS) $(INCLUDES) $(LIBS)
 
$(C_OBJS): $(C_SOURCES) $(HEADERS)
	$(CC) -c $(C_SOURCES) $(CFLAGS) $(INCLUDES)
 
$(CU_OBJS): $(CU_SOURCES) $(HEADERS)
	$(NVCC) -c $(CU_SOURCES) $(NVCCFLAGS) $(INCLUDES)
 
run: $(BIN)
	LD_LIBRARY_PATH=$(CUDA_INSTALL_PATH)/lib ./$(BIN)
 
clean:
	rm -f $(BIN) *.o
