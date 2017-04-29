void a();
void b();
void c();
void d();
void e(void (*)());
void f();

void a() {
  b();
}

void b() {
  d();
}

void c() {
  b();
}

void d() {
  e(c);
}

void e(void (*x)()) {
  x();
  f();
}

void f() {


}
