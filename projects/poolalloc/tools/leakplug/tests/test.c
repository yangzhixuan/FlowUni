int **x, *y, **t;

int f() {
  int a, *p;
  x = &y;
  x = &p;
  t = &p;
  y = &a;
  return 0;
}

