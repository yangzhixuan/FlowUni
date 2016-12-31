#include <stdlib.h>

void f(char *b, int c) {
    char *a = malloc(1);
    if(b == a) {
        return;
    }
    b = a;
    free(b);
    return;
}
