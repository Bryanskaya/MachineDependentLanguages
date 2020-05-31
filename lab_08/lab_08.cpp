// Скалярное произведение двумерных векторов

#include <iostream>

using namespace std;

double scalar_mult2(double x1, double y1, double x2, double y2)
{
    double mul = 0;

    __asm
    {
        finit

        fld     x1
        fld     x2
        fmul

        fld     y1
        fld     y2
        fmul

        fadd

        fstp    mul
    }

    return mul;
}

double scalar_mult3(double x1, double y1, double z1, double x2, double y2, double z2)
{
    double mul = 0;

    __asm
    {
        finit

        fld     x1
        fld     x2
        fmul

        fld     y1
        fld     y2
        fmul

        fld     z1
        fld     z2
        fmul

        fadd
        fadd

        fstp    mul
    }

    return mul;
}

int main()
{
    double x1, y1;
    double x2, y2;
    double x3, y3, z3;
    double x4, y4, z4;

    cout << "Input vector1: ";
    cin >> x1 >> y1;
    cout << endl;

    cout << "Input vector2: ";
    cin >> x2 >> y2;
    cout << endl;

    cout << ">>Scalar multiplication: " << scalar_mult2(x1, y1, x2, y2) << endl << endl;

    cout << "Input vector3: ";
    cin >> x3 >> y3 >> z3;
    cout << endl;

    cout << "Input vector4: ";
    cin >> x4 >> y4 >> z4;
    cout << endl;

    cout << ">>Scalar multiplication: " << scalar_mult3(x3, y3, z3, x4, y4, z4) << endl << endl;

    return EXIT_SUCCESS;
}


