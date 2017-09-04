#include <stdio.h>
#include <stdlib.h>
#include <math.h>

double step_1(double dt, double omegac);
double step_2(double dt, double omegac);
double step_3(double dt, double omegac);
double step_4(int i, double omega1, double omega2, double dt);
// Do not modify anything. Write your code under the two if statements indicated below.

/*
In this program we are trying to implement the lowpass filter, there's also a graphical part to this as well
We read inputs from a file that we read in this program. We get the values of Omega1, Omega2, OmegaC, the method.
Method 1 - takes in Time, calculated dt, and N, also Omega1, Omega2, OmegaC.
WE basically create and use a equation that gives us the low pass filter values numericallyy instead of graphically..
*/

int main(int argc, char **argv)
{
	double omega1, omega2, omegac, T, dt;
	int N, method;
	FILE *in;

	// Open the file and scan the input variables.
	if (argv[1] == NULL) {
		printf("You need an input file.\n");
		return -1;
	}
	in = fopen(argv[1], "r");
	if (in == NULL)
		return -1;
	fscanf(in, "%lf", &omega1);
	fscanf(in, "%lf", &omega2);
	fscanf(in, "%lf", &omegac);
	fscanf(in, "%d", &method);

	T = 3 * 2 * M_PI / omega1; 		// Total time
	N = 20 * T / (2 * M_PI / omega2); 	// Total number of time steps
	dt = T / N;				// Time step ("delta t")

	// Method number 1 corresponds to the finite difference method.
	if (method == 1) {
		int i;
		double Voutnew = 0, Voutcur = 0, Voutprev = 0;

		// Write your code here!
		
		//input signal V_IN(T)
		for( i = 0; i <= N -1 ; i ++)
		{
			Voutnew = step_1(dt, omegac) * ( ((step_2(dt, omegac) * Voutcur)) + (step_3(dt, omegac) * Voutprev) + step_4(i, omega1, omega2, dt) ) ; //This is the equation we solve to get numbers. This equation uses fucntions to get values.
			printf("%lf\n", Voutcur); //Prints the current Vout value
			Voutprev = Voutcur; //Make the previous value equal to current value
			Voutcur = Voutnew; //Make the current value equal to next value
		}		
	}

	// Method number 2 corresponds to the Runge-Kutta method (only for challenge).
	else if (method == 2) {
		// Write your code here for the challenge problem.
	}

	else {
		// Print error message.
		printf("Incorrect method number.\n");
		return -1;
	}

	fclose(in);
	return 0;
}

//I used functions so the equation looks simpler and is easier to fix if something goes wrong
//Basically split the problem into smaller equations, really helpful to code and debug this problem.
double step_1(double dt, double omegac)
{
	double two = 2.0;
	double ans = 0.0;
	ans = (1.0/ ( (1.0/(sqrt(two)* dt * omegac)) + (1.0/((dt * dt) * (omegac * omegac))) ) );
	return ans;
}

double step_2(double dt, double omegac)
{
	double ans = 0.0;
	ans = ( (2.0/( (dt*dt) * (omegac * omegac) ) ) - 1.0 );
	return ans;
}

double step_3(double dt, double omegac)
{
	double two = 2.0;
	double ans = 0.0;
	ans = (1.0/( sqrt(two) * dt * omegac ) ) - (1.0/( (dt*dt) * (omegac * omegac) )) ;
	return ans;	
}

double step_4(int i, double omega1, double omega2, double dt)
{
	double ans = 0.0;
	ans = sin(omega1 * i * dt) + ( (0.5) * sin(omega2 * i * dt ) );
	return ans;
}
