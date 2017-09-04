/* compute a function */

#include <stdio.h>
#include <math.h>

int main()
{
    /* declare variables */
    int n, i;
    double w1, w2, x, f;

    /* prompt user for input */
    /* get user input*/
    printf("Please Enter a value for n: ");
    scanf("%d", &n);
    
    printf("Please Enter a value for W1: ");
    scanf("%lf", &w1);
    
    printf("Please Enter a value for W2: ");
    scanf("%lf", &w2);

	

    /* for i from 0 to n-1 */
       /* compute and print xi and f(xi) */
       /* use sin() function from math.h */

	for( i = 0; i < n; i ++)
	{
		printf("%d. ", i);
		x = ( (i * 3.14) / (n - 1) );
		printf("%lf\t", x);
		
		f = sin(w1 * x) + ( (1/2) * sin(w2 * x) );
		printf("%lf \n", f);		
	}	
	
    /* exit the program */
    return 0;
}

