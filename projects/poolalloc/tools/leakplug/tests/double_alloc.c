#include <stdlib.h>

int x;

char* new_char() {
    char *c = malloc(1);
    if(x < 0) {
        return 0;
    } else {
        return c;
    }
}

int main() {
    char *c1 = new_char();
    use(c1);
    c1 = new_char();
    use(c1);
    free(c1);
    return 0;
}
