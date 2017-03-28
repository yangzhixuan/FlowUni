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

int* *arg2(int **a, int **b) {
  *a = *b;
  return *a;
}


char* wrapper() {
  return malloc(4);
}


char* allocator() {
  char *x = malloc(128);
  return x;
}


int* autovar() {
  int *a;
  int *b;
  a = malloc(4);
  a = b;
  return b;
}
