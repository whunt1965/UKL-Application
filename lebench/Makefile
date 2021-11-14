.PHONY: lebench

PARALLEL= -j$(shell nproc)

#PATHS
GCC_LIB=gcc-build/x86_64-pc-linux-gnu/libgcc/
LC_DIR=glibc-build/
CRT_LIB=$(LC_DIR)csu/
C_LIB=$(LC_DIR)libc.a
PTHREAD_LIB=$(LC_DIR)nptl/libpthread.a
RT_LIB=$(LC_DIR)rt/librt.a
MATH_LIB=$(LC_DIR)math/libm.a
CRT_STARTS=$(CRT_LIB)crt1.o $(CRT_LIB)crti.o $(GCC_LIB)crtbeginT.o
CRT_ENDS=$(GCC_LIB)crtend.o $(CRT_LIB)crtn.o
SYS_LIBS=$(GCC_LIB)libgcc.a $(GCC_LIB)libgcc_eh.a

LEBench_UKL_FLAGS=-ggdb -mno-red-zone -mcmodel=kernel -fno-pic
UKL_FLAGS=-ggdb -mno-red-zone -mcmodel=kernel -fno-pic

#-----------------------------------------------------------------------------
#-----------------------------------------------------------------------------

#LE Bench
lebench: undefined_sys_hack.o gcc-build glibc-build
	- rm -rf UKL.a lebench.o 
	gcc -c -o lebench.o lebench.c $(UKL_FLAGS) -UUSE_VMALLOC -UBYPASS -UUSE_MALLOC \
                -DREF_TEST -DWRITE_TEST -DREAD_TEST -DMMAP_TEST -DMUNMAP_TEST -DPF_TEST -DEPOLL_TEST \
                -USELECT_TEST -UPOLL_TEST
	ld -r -o lebench.ukl --allow-multiple-definition $(CRT_STARTS) mybench_small.o \
                --start-group --whole-archive  $(PTHREAD_LIB) \
                $(C_LIB) --no-whole-archive $(SYS_LIBS) --end-group $(CRT_ENDS)
	ar cr UKL.a lebench.ukl undefined_sys_hack.o
	objcopy --prefix-symbols=ukl_ UKL.a
	objcopy --redefine-syms=redef_sym_names UKL.a
	- rm -rf linux/vmlinux

#-----------------------------------------------------------------------------
#-----------------------------------------------------------------------------



