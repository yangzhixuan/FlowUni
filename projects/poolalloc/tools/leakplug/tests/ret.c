int *f()
{
  int *a = malloc(4);
  return a;
}

struct Ptr{
  struct Ptr2 {
    int* p2;
  }s2;
  int *p;
  int x;
};
struct Ptr g()
{
  int *a = malloc(4);
  struct Ptr p;
  p.p = a;
  p.s2.p2 = malloc(4);
  return p;
}
