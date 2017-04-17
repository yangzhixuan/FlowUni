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
  } else {
    p3 = &y;
  }
  *p3 = y;
  return *p3;
}

// test strong update.
int f3() {
  int x, y;
  int *p1, *p2, *p3;
  p1 = &x;
  p2 = p1;

  p1 = &y;
  p3 = p1;
  return 0;
}

// test uninitialized variable
int f4() {
  int *p, *probe, x;
  probe = p;
  p = &x;
  probe = p;

  return 0;
}

// test higher order pointers
int f5() {
  int *p, **pp, x, y;
  pp = &p;
  p = &x;
  int probe = **pp;
  if(x < 0) {
    p = &y;
  }
  probe = **pp;
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
