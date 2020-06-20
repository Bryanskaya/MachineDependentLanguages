#include <iostream>

using namespace std;

int main()
{
    int n, num;
    double temp, sum = 0;

    printf("Input amount of numbers: ");
    scanf_s("%d", &n);

    if (n <= 0)
    {
        printf("\nERROR\n");
        return EXIT_FAILURE;
    }

    printf("\nInput numbers: \n");

    num = n;
    while (n > 0)
    {
        scanf_s("%lf", &temp);
        sum += temp;
        n -= 1;
    }

    printf("Average: %lf\n\n", sum / num);
    
    return EXIT_SUCCESS;
}

