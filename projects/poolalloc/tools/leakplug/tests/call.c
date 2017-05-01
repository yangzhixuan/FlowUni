#include "FCPAnnotation.h"

int g(int** a, int** b);
int f(int** a, int** b) {
  g(a, b);
  f(a, b);
  return 0;
}

int* x;
int f1(int** a, int** b) {
  int z;
  x = &z;
  g(a, b);

  __print_pointTo(x);
  return 0;
}

