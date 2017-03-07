#include <stdlib.h>
#include <string.h>

int *basic(int* x) {
  int *a=(int*)malloc(4);
  if(*x < 0) {
    return 0;
  } else {
    return a;
  }
}

char *concat(const char* a, const char* b) {
  int len = strlen(a) + strlen(b);

  char *s = malloc(len + 1);
  strcpy(s, a);
  strcat(s, b);
  return s;
}

int concat_use() {
  char *s = concat(concat("a", "b"), "c");
  return 0;
}
