#include "FCPAnnotation.h"

int f(int **x);
int g(int **y);

int f(int **x) {
  int a, *p;
  p = &a;
  g(&p);
  __print_pointTo(p);
  __print_pointTo(*x);
  return 0;
}

int g(int **y) {
  int b;
  *y = &b;
  f(y);
  __print_pointTo(*y);
  return 0;
}

int gvar;
int rec(int *x) {
  __print_pointTo(x);
  int a;
  rec(&a);
  rec(&gvar);
  return 0;
}
