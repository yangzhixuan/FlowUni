#include "FCPAnnotation.h"

int f() {
  int x ;
  if(x > 0) {
    if(x < 5) {
      x = 10;
    } else {
      x = 12;
    }
  } else {
    x = 19;
  }
  return x;
}

// test branches
int f2() {
  int x, y;
  int *p1, *p2, *p3;
  p1 = &x;
  p2 = &y;
  *p1 = *p2;
  if(x < 4) {
    p3 = &x;
    __may_pointTo_exactly(p3, &x);
  } else {
    p3 = &y;
    __may_pointTo_exactly(p3, &y);
  }
  __may_pointTo_exactly(p3, &x, &y);
  return 0;
}

// test strong update.
int f3() {
  int x, y;
  int *p1;
  p1 = &x;
  __may_pointTo_exactly(p1, &x);

  p1 = &y;
  __may_pointTo_exactly(p1, &y);
  return 0;
}

// test uninitialized variable
int f4() {
  int *p, *probe, x;
  probe = p;
  __print_pointTo(p);
  p = &x;
  __may_pointTo_exactly(p, &x);

  return 0;
}

// test higher order pointers
int f5() {
  int *p, **pp, x, y;
  pp = &p;
  p = &x;
  __may_pointTo_exactly(*pp, &x);
  if(x < 0) {
    p = &y;
  }
  __may_pointTo_exactly(*pp, &x, &y);
  return 0;
}

// test loop
int f6() {
  int **pp, *x, *y, n, m;
  pp = &x;
  x = &m;
  do {
    *pp = &n;
  } while(n);
  __may_pointTo_exactly(x, &n);

  do {
    *pp = &n;
    if(n < 0) {
      x = &m;
    }
  } while(n);
  __may_pointTo_exactly(x, &n, &m);

  return 0;
}



#if 0   // it takes too long to draw the JPEG
int f2_long() {
  int x, y;
  int *p1, *p2, *p3;
  p1 = &x;
  p2 = &y;
  *p1 = *p2;
  if(x < 4) {
    p3 = &x;
  } else {
    p3 = &y;
  }
  *p3 = y;


  *p1 = *p2;
  if(x < 4) {
    p3 = &x;
  } else {
    p3 = &y;
  }
  *p3 = y;


  *p1 = *p2;
  if(x < 4) {
    p3 = &x;
  } else {
    p3 = &y;
  }
  *p3 = y;


  *p1 = *p2;
  if(x < 4) {
    p3 = &x;
  } else {
    p3 = &y;
  }
  *p3 = y;


  *p1 = *p2;
  if(x < 4) {
    p3 = &x;
  } else {
    p3 = &y;
  }
  *p3 = y;


  *p1 = *p2;
  if(x < 4) {
    p3 = &x;
  } else {
    p3 = &y;
  }
  *p3 = y;

  *p1 = *p2;
  if(x < 4) {
    p3 = &x;
  } else {
    p3 = &y;
  }
  *p3 = y;


  *p1 = *p2;
  if(x < 4) {
    p3 = &x;
  } else {
    p3 = &y;
  }
  *p3 = y;


  *p1 = *p2;
  if(x < 4) {
    p3 = &x;
  } else {
    p3 = &y;
  }
  *p3 = y;


  *p1 = *p2;
  if(x < 4) {
    p3 = &x;
  } else {
    p3 = &y;
  }
  *p3 = y;


  *p1 = *p2;
  if(x < 4) {
    p3 = &x;
  } else {
    p3 = &y;
  }
  *p3 = y;


  *p1 = *p2;
  if(x < 4) {
    p3 = &x;
  } else {
    p3 = &y;
  }
  *p3 = y;


  *p1 = *p2;
  if(x < 4) {
    p3 = &x;
  } else {
    p3 = &y;
  }
  *p3 = y;

  return *p3;
}
#endif
