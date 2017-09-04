#include "prime.h"

int is_prime(int n) 
{
    /* Return 1 if prime, or 0 otherwise */
    
    int i;
 	   
    for(i = 2; i <= n - 1; i++) /* we repeat the modulo loop until we hit n-1 and if we haven't gotten*/
    {							/* a remainder yet, then it means i == n, so we know its prime*/
		if(n % i == 0)
			return 0;
    }
    
    if( i == n)
    {
    	return 1;
    }
    return 0;
}

