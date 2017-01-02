#include <stdlib.h>

int f(int *f, int x)
{
    char *c;

    if(x < 5) {
        c = malloc(1);
    } else {
        c = malloc(1);
    }
    *c = 0;
    if(x < 5) {
        *c = 1;
        return x + x;
    }
    *c = *c + x;
    int y = *c + x;
    free(c);
    return y;
}
