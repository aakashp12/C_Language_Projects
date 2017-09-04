#include <stdio.h>
#include "prime.h"

int main() 
{
    /* Write the code to take a number n from user and print all the prime numbers between 1 and n. */
  	int n;
  	int i;
  	int result;
  	
    printf("Enter the value for n: ");
    scanf("%d", &n);			/* we get the values for our program*/

	printf("Printing primes less than or equal to %d: \n", n);
	for(i = 1; i <= n; i++)		/*Start a loop from 1 and see check if numbers from 1 to n */
	{							/*Are primes or not by calling the function IS_PRIME*/
		result = is_prime(i);	/*Pass our current number into the function and check for prime*/
		if(result == 1)			/* if we returned 1 meaning Prime, then we print it otherwise dont print*/
		{
			printf("%d, ", i);
		}
	}
	
	printf("\b\b.\n");			/*Website shows -> #, #, #, #. <- with the period, so I took cursor back 2 chars and added a '.'*/
    return 0;
}

