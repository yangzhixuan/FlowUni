#include <stdlib.h>
int f(int *unrel, int x)
{
    char *c = malloc(1);
    if(x < 5) {
        *c = 0;
        free(c);
        return 2;
    }
    char *d = malloc(1);
    free(unrel);
    return 0;
}
