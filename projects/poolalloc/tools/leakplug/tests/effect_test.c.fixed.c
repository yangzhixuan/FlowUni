char* id(char *s) {
  return s;
}

char* deref(char **s) {
  static char x;
  x = **s;
  return *s;
}

int x;
char *scc1(char*);
char *scc2(char*);

char* scc1(char *s) {
  if(x) {
    return scc2(s);
  } else {
    return 0;
  }
}

char* scc2(char *t) {
  if(x) {
    return scc1(t);
  } else {
    return 0;
  }
}

char* allocator() {
void* ptr_32_10;
free(ptr_32_10);
  return ptr_32_10 = malloc(4);
}

int* g;
void globalvar(int* x) {
  g = x;
}

