#include <stdlib.h>

void f(char *b, int c) {
  void* ptr_4_15;
  void* ptr_5_9;
  char *a = ptr_4_15 = malloc(1);
  a = ptr_5_9 = malloc(2);
  if(b == a) {
    free(ptr_4_15);
    free(ptr_5_9);
    return;
  }
  b = a;
  free(b);
  return;
}

