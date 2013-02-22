
#include <stdio.h>

typedef int (*function_t)(void);

int i = 1;

int func(void) {
    i++;
    i++;
    i++;
    printf("%d\n", i);
    return i;
}

int main(int argc, char **argv) {
    int offset = 5;
    function_t f = &func + offset;
    printf("%d\n", f());
    return 0;
}
