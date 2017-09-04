#include <stdio.h>

int compArray( int a[], int b[])
{
	int sum1 = 0;
	int sum2 = 0;
	
	for(int i = 0; i < 10; i++)
	{
		sum1 = sum1 + a[i];
		sum2 = sum2 + b[i];
	}
	
	if(sum1 == sum2)
		return 0;
	else if(sum1 > sum2)
		return 1;
	else
		return 2;
}

int main()
{
	int a[10];
	int b[10];
	int result;
	
	for(int i = 0; i < 10; i ++)
	{
		a[i] = i;
		b[i] = 20;
	}
	
	result = compArray(a, b);
	
	if(result == 0)
		printf("The arrays have equal sums\n");
	else
		printf("Array %d has a bigger sum\n", result);
		
	return 0;
}
