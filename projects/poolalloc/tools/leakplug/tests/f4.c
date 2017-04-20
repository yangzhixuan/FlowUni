#include "FCPAnnotation.h"

// test uninitialized variable
int f4() {
  int *p, *probe, x;
  __print_pointTo(p);
  p = &x;
  __may_pointTo_exactly(p, &x);

  return 0;
}
