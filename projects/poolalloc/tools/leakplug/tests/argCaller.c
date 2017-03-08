int *g1;
int **g2;
void arg(int **x) {
  *x = malloc(4);
  g1 = *x;
  g2 = &g1;
  return;
}

void argCaller() {
  int *x;
  arg(&x);
}
