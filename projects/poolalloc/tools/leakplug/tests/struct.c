struct ST{
  int a;
  int* b;
};

union UN{
  int a;
  int* b;
};

int* f() {
  struct ST s;
  int *p = s.b;

  union UN n;
  p = n.b;


  int a[5];
  p = a + 4;
  return p;
}
