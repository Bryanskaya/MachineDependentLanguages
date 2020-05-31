#include <iostream>

#define NUM	100

using namespace std;

extern "C"
{
	void copy_str(const char* from, const char* to, int len);
}

int len_str(char* s)
{
	int len = 0;

	__asm {
		mov		EDI, s
		mov		AL, 0

		mov		ECX, -1
		repne	scasb

		sub		EDI, s
		sub		EDI, 1

		mov		len, EDI
	}

	return len;
}

int main()
{
	char my_str[NUM];
	char from[] = "abcdefghijklmnopqrstuvwxyz";
	char to[100] = { 0 };
	/*const char* to = my_str + 4;
	const char* from = my_str + 2;*/
	
	int amount;

	cout << "Enter string: ";
	cin >> my_str;

	cout << endl << "String: " << my_str << endl;
	cout << "Length: " << len_str(my_str) << endl << endl;

	cout << "From '" << from << "' to '" << to << "'" << endl << endl;

	cout << "Number letters: ";
	cin >> amount;
	cout << endl << endl;

	copy_str(from, to, amount);

	cout << "Result: " << to << endl << endl;
	//cout << "Result: " << my_str << endl << endl;

	return EXIT_SUCCESS;
}
