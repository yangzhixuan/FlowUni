#include "FCPAnnotation.h"

int f(int **x) {
  int a, b;
  *x = &a;
  *x = &b;
  __print_pointTo(x);
  __print_pointTo(*x);
  __may_pointTo_exactly(*x, &b);
  return 0;
}

int f2(int ***x) {
  int a, b;
  int **p = *x;
  *p = &a;
  __print_pointTo(x);
  __print_pointTo(*x);
  __print_pointTo(**x);
  __print_pointTo(p);
  __print_pointTo(*p);
  __may_pointTo_exactly(**x, &a);
  return 0;
}

int ***x;
int f3() {
  int a, b;
  int **p = *x;
  *p = &a;
  __print_pointTo(x);
  __print_pointTo(*x);
  __print_pointTo(**x);
  __print_pointTo(p);
  __print_pointTo(*p);
  __may_pointTo_exactly(**x, &a);
  return 0;
}

int f4() {
  int ***p3, *p1, a;
  p3 = x;
  *p3 = &p1;
  **x = &a;
  __may_pointTo_exactly(p1, &a);
  __may_pointTo_exactly(**x, &a);
  __may_pointTo_exactly(**p3, &a);
  __may_pointTo_exactly(**p3, **x);
  return 0;
}
