int x;
char* f() {
  char *p;
  char a[123];
  if(x) {
    p = malloc(5);
  } else {
    p = a;
  }
  return p;
}

char* wrapper() {
  return malloc(4);
}

void wrapperCaller() {
  char *x = wrapper();
}

void arg(int **x) {
  *x = malloc(4);
  return;
}

void argCaller() {
  int *x;
  arg(&x);
}

void arg2(int **x) {
  static int* r;
  x = malloc(sizeof(int*));
  if(!x) {
    x = &r;
  }
  *x = malloc(sizeof(int));
  return;
}
