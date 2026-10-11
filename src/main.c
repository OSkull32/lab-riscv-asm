#include <stdio.h>

#define N 5
#define M 4

/* Тестовые данные */
static const int array[N][M] = {
    {  3,  -7,  12,   5},
    {  0,   9,  -2,  44},
    { 18, -25,   6,   7},
    { 11,   4,  13, -25},
    { -1,   8,   2,  30}
};

/*
 * Поиск минимального элемента двумерного массива, хранящегося построчно.
 *
 *   a      - адрес массива a[0][0]
 *   n      - количество строк
 *   m      - количество столбцов
 *   возврат - значение минимального элемента
 */
int min_element(const int *a, int n, int m)
{
    int min = a[0];

    for (int i = 0; i < n; ++i) {
        for (int j = 0; j < m; ++j) {
            int value = a[i * m + j];
            if (value < min) {
                min = value;
            }
        }
    }

    return min;
}

int main(void)
{
    int result = min_element(&array[0][0], N, M);

    printf("min = %d\n", result);

    return 0;
}
