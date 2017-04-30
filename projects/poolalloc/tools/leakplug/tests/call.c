
int g(int** a, int** b);
int f(int** a, int** b) {
  g(a, b);
  return 0;
}

int* x;
int f1(int** a, int** b) {
  int z;
  x = &z;
  g(a, b);
  return 0;
}
