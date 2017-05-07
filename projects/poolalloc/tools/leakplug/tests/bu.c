#include "FCPAnnotation.h"

int* g1() {
  static int x;
  return &x;
}

void g2(int **p) {
  static int x;
  *p = &x;
}

void g3(int ***p) {
  static int x;
  **p = &x;
}


int f() {
  int *p = g1();
  __print_pointTo(p);

  g2(&p);
  __print_pointTo(p);

  int **p2 = &p;
  g3(&p2);
  __print_pointTo(p);
  __print_pointTo(p2);

  return 0;
}
