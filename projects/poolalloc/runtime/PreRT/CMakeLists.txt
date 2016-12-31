file(GLOB sources *.cpp *.c)
add_llvm_library( pa_pre_rt ${sources} )
set(SOURCES
  qsort.c
  strdup.c)