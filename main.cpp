#include <iostream>
#include <vector>

extern "C" void vvaddint32atomic(int n, const int* x, const int* y, int* z, int* i);

int main(int argc, char* argv[])
{
    size_t n = argc - 1;
    std::vector<int> x(n);
    std::vector<int> y(n);
    std::vector<int> z(n);
    for (int i = 0; i < n; ++i) {
        x[i] = atoi(argv[i + 1]);
        y[i] = atoi(argv[i + 1]);
        z[i] = atoi(argv[i + 1]);
    }
    int i = 0;
    std::cout << "n start " << n << "\n";
    vvaddint32atomic(n, x.data(), y.data(), z.data(), &i);
    std::cout << "i end " << i << "\n";
    for (int i = 0; i < n; ++i) {
        std::cout << "x " << x[i] << " y " << y[i] << " z " << z[i] << "\n";
    }
    return 0;
}