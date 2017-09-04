#include <stdio.h>

int main()
{
	int b[2][3] = {{1,2,3}, {4,5,6}};
	int* ptr = b[0];
	for(int i = 0; i < 2; i++)
	{
		for(int j = 0; j <3; j++)
		{
			printf("B[%d][%d]: %d\n", i, j, b[i][j]);
		}
	}
	printf("\n");
	printf("Print using pointer\n");
	printf("\n");
	for(int i = 0; i < 2; i++)
	{
		for(int j = 0; j <3; j++)
		{
			printf("B[%d][%d]: %d\n", i, j, *(ptr + (i*3 + j)) );
		}
	}
	return 0;
}
