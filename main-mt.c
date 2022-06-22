#include <util.h>

extern void vvaddint32atomic(int n, const int* x, const int* y, int* z, int* i);

void thread_entry(int cid, int nd)
{
    static int x[4];
    static int y[4];
    static int z[4];
    int n = 4;
    for (int i = 0; i < n; ++i) {
        x[i] = i;
        y[i] = i;
        z[i] = i;
    }
    int i = 0;
    printf("%d\n", n);
    vvaddint32atomic(n, x, y, z, &i);
    printf("%d\n", i);
    for (int i = 0; i < n; ++i) {
        printf("%d\n", z[i]);
    }
    exit(0);
}
