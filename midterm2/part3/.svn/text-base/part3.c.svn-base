#include <stdio.h>

/* IMPLEMENT ME: write function prototype here */
int GCD(int M, int N);

/* ! DO NOT MODIFY MAIN() ! */
int main()
{
    int M, N;

    printf("Enter two positive numbers: ");
    scanf("%d %d", &M, &N);
    printf("GCD of %d and %d is %d\n",  M, N, GCD(M, N));

    return 0;
}


/*
 * GCD(M, 0) is M.
 * GCD(M, N) is GCD(N, M) if M < N.
 * GCD(M, N) is N if N ≤ M and N divides M.
 * GCD(M, N) is GCD(N, remainder of M divided by N) otherwise.
 */
int GCD(int M, int N) 
{ 
 /* implement me */
 if(N == 0)
 	return M; //GCD(M, 0) is M.
 	
 else if( M < N)
 {
	int temp = M; //GCD(M, N) is GCD(N, M) if M < N.
	M = N;
	N = temp;
	//GCD(M, N);
 }
 
 else if( (N <= M) && (N / M != 0) ) //GCD(M, N) is N if N ≤ M and N divides M.
 	return N;
 	
	return GCD(N, M % N); // GCD(M, N) is GCD(N, remainder of M divided by N) otherwise.

}

