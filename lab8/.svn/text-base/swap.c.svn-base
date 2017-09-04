#include <stdio.h>

void swap( int *px, int *py);
/* provide swap function prototype here */

int main()
{
    /* complete main function to demonstrate the use of swap */
    int x = 5;
    int y = 25;
    
    printf("Before\nX: %d\tY: %d\n", x, y);
    
    swap(&x, &y);

	printf("After\nX: %d\tY: %d\n", x, y);
	
	return 0;
}


void swap (int *px, int *py)
{
    int temp;
    temp = *px;
    *px = *py;
    *py = temp;
}

