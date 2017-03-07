#include <stdlib.h>


// 1. p will considered as r_user because a() calls p() with r
int p(int* x) {
    return *x;
}


int a(int *r) {
    return p(r);
}

int b() {
    int x;
    // 2. PROBLEM: in the intra-procedural analysis of b, p will be considered as r_user.
    // But in fact it's not.
    return p(&x);
}

int main() {
    int *r = (int*) malloc(4);
    a(r);
    b();
    return 0;
}
