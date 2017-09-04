#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#define NofS 3

#define EQUAL 0
#define NOTEQUAL 1

struct studentStruct
{
    char name[100];
    int ID;
    char grade;
};
typedef struct studentStruct Student;

void enterRecords(Student s[], int n);
void writeRecordsToFile(Student s[], int n, char *fname);

/* implement me */
void readRecordsFromFile(Student s[], int n, char *fname);

/* implement me */
int compareRecords(Student s1[], Student s2[], int n);


int main()
{
    Student S1[NofS];
    Student S2[NofS];

    enterRecords(S1, NofS);
    writeRecordsToFile(S1, NofS, "ece220.dat");

    readRecordsFromFile(S2, NofS, "ece220.dat");

    if (compareRecords(S1, S2, NofS) == EQUAL)
        printf("Records are identical\n");
    else    
        printf("Records are different\n");

    return 0;
}

/*
*	INPUT - 
*		Student s[]- struct array that contains space for Name, ID, grade
*		n - Number of Struct Student array's
*
*	OUTPUT-
*		Student s[] - fill the array with information we recieved and scanned
*		from stdin using keyboard.
*
*/

void enterRecords(Student s[], int n)
{
    int i;
    char temp[8];
    for (i = 0; i < n; i++)
    {
        printf("Enter student's name: ");
        fgets(s[i].name, 99, stdin);
        printf("Enter student's ID: ");
        scanf("%d", &(s[i].ID));
  
        printf("Enter student's grade: ");
        scanf("\n%c", &(s[i].grade));
        fgets(temp, 7, stdin);
    }
}

/*
*	INPUT - 
*		Student s[]- struct array that contains space for Name, ID, grade. Array S1
*		n - Number of Struct Student array's
*		fname - name of the file
*
*	OUTPUT-
*		the file in fname gets written with the informataion we got from
*		getRecords function
*
*/

void writeRecordsToFile(Student s[], int n, char *fname)
{
    FILE *f;
    int i;

    if ((f = fopen(fname, "w")) == NULL)
    {
        fprintf(stderr, "Unable to open file %s\n", fname);
        exit(1);
    }
    for (i = 0; i < n; i++)
        fprintf(f, "%s%d\n%c\n", s[i].name, s[i].ID, s[i].grade);

    fclose(f);
}


/*
*	INPUT - 
*		Student s[]- struct array that contains space for Name, ID, grade. Array S2
*		n - Number of Struct Student array's
*		fname - name of the file
*
*	OUTPUT-
*		the file in fname gets read, and the information in the file gets copied into the 
*		array S2, we used Student s[] as a guide for where to store the information
*
*/

void readRecordsFromFile(Student s[], int n, char *fname)
{
/* implement me */
	FILE *f;
	int i;
	
	if(( f = fopen(fname, "r")) == NULL)
	{
		fprintf(stderr, "Unable to open file %s\n", fname);
		exit(1);
	}
	
	for(i = 0; i < n; i++)
	{
		fscanf(f, "%s%d\n%c\n", s[i].name, &s[i].ID, &s[i].grade);
	}
	
	fclose(f);
}


/*
*	INPUT - 
*		Student s1[]- struct array that contains space for Name, ID, grade
*		Student s2[]- struct array that contains space for Name, ID, grade		
*		n - Number of Struct Student array's
*
*	OUTPUT-
*		Returns EQUAL if S1 and S2 are equal
*		Returns NOTEQUAL if S1 and S2 are not equal
*
*/

int compareRecords(Student s1[], Student s2[], int n)
{
/* implement me */
	for(int i = 0; i < n; i++)
	{
		if(strcmp(s1[i].name, s2[i].name))
		{} //if name are equal continue
		else
			return NOTEQUAL;
		if(s1[i].ID == s2[i].ID)
		{} //if ID are equal continue
		else
			return NOTEQUAL;
		if(s1[i].grade == s2[i].grade)
		{} //if grade are equal then return EQUAL
		else
			return NOTEQUAL;
	}
    return EQUAL;
}

