
int g(int** a, int** b);
int f(int** a, int** b) {
  g(a, b);
  return 0;
}
