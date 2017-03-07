#include <stdlib.h>
#include <string.h>

int *basic(int* x) {
void* ptr_5_16;
  int *a=(int*)ptr_5_16 = malloc(4);
free(ptr_5_16);
  if(*x < 0) {
    return 0;
  } else {
    return a;
  }
}

char *concat(const char* a, const char* b) {
void* ptr_16_13;
  int len = strlen(a) + strlen(b);

free(ptr_16_13);
  char *s = ptr_16_13 = malloc(len + 1);
  strcpy(s, a);
  strcat(s, b);
  return s;
}

int concat_use() {
  char *s = concat(concat("a", "b"), "c");
  return 0;
}

