int f();
int g();
int h();
int t();

int x;

int f() {
  if(x < 0) {
    return t();
  }
  return g();
}

int g() {
  if(x < 0) {
    return h();
  } else {
    return t();
  }
}

int h() {
  x = 1;
  return g();
}

int t() {
  return x;
}
