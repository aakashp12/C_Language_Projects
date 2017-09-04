#include <stdio.h>
#include "maze.h"

#define TRUE 1
#define FALSE 0
/*
 * findStart -- finds the x and y location of the start of the  maze
 * INPUTS:      maze -- 2D char array that holds the contents of the maze
 *              width -- width of the maze
 *              height -- height of the maze
 *              x -- pointer to where x location should be stored
 *              y -- pointer to where y location should be stored
 * OUTPUTS: x and y will hold the values of the start 
 * RETURN: none
 * SIDE EFFECTS: none
 */ 
void findStart(char ** maze, int width, int height, int * x, int * y)
{
	int i; int j;
	for(i = 0; i < height; i++) // rows
	{ 
		for(j = 0; j < width; j++) // cols
		{
			if(maze[i][j] == START)
			{
				*x = j; // assign the col to x
				*y = i; // assign the row to y
				/*printf("%d %d\n", j ,i); //this is so for DEBUG take out LATER */
			}
		}
	}
}

/*
 * printMaze -- prints out the maze in a human readable format (should look like examples)
 * INPUTS:      maze -- 2D char array that holds the contents of the maze 
 *              width -- width of the maze
 *              height -- height of the maze
 * OUTPUTS:     none
 * RETURN:      none
 * SIDE EFFECTS: prints the maze to the console
 */
 
void printMaze(char ** maze, int width, int height)
{
	int i; int j;
	
	for(i = 0; i < height; i++) //rows going from 0 at top to N at bottom
	{
		for(j = 0; j < width; j++) //cols going from 0 at left and N at right
		{
			printf("%c", maze[i][j]); //print it out this way, cuz its 2D array
		}
		printf("\n");
	}
}

/*
 * solveMazeDFS -- recursively solves the maze using depth first search
 * INPUTS:         maze -- 2D char array that holds the contents of the maze
 *                 width -- the width of the maze
 *                 height -- the height of the maze
 *                 xPos -- the current x position within the maze
 *                 yPos -- the current y position within the maze
 * OUTPUTS:        updates maze with the solution path ('.') and visited nodes ('~')
 * RETURNS:        0 if the maze is unsolvable, 1 if it is solved
 * SIDE EFFECTS:   none
 */ 
 
int solveMazeDFS(char ** maze, int width, int height, int xPos, int yPos)
{
	
	if( (xPos < 0) || (xPos >= width) || (yPos < 0) || (yPos >= height ) )
	{ 										// we start from the starting position 
		return 0;						// if we exceed the bounds then return FALSE
	}
		
	if( maze[yPos][xPos] == 'E') //if we are at end then WE ARE DONE!!!! MUAHAHAHAH
	{
		return 1;
	}	

	if( (maze[yPos][xPos] == ' ') || (maze[yPos][xPos] == 'S') ) // if its empty or start
	{														    // then we change it to path
		if(maze[yPos][xPos] != 'S')						    // otherwise return 0;
			maze[yPos][xPos] = '.';
	}
	else 
		return 0;
	
/////////////////////////////////////////////////////////////////////////////////////////////		
		
	if( solveMazeDFS(maze, width, height, xPos - 1, yPos) == 1) //move right
	{
		return 1;
	}

	else if( solveMazeDFS(maze, width, height, xPos + 1, yPos) == 1) //move left
	{
		return 1;
	}

	else if( solveMazeDFS(maze, width, height, xPos, yPos - 1) == 1) //move up
	{
		return 1;
	}	

	else if( solveMazeDFS(maze, width, height, xPos, yPos + 1) == 1) // move down
	{
		return 1;
	}
	
	else
	{
		if( (maze[yPos][xPos] != 'S') && (maze[yPos][xPos] != ' ') )
			maze[yPos][xPos] = '~';
		else
			return 0;
	}
}

/*
 * checkMaze -- checks if a maze has a valid solution or not
 * INPUTS:      maze -- 2D char array that holds the contents of the maze
 *              width -- width of the maze
 *              height -- height of the maze
 *              x -- the starting x position in the maze
 *              y -- the starting y position in the maze
 * OUTPUTS:     none
 * RETURN:      1 if the maze has a valid solution, otherwise 0
 * SIDE EFFECTS: none
 */ 
 
int checkMaze(char ** maze, int width, int height, int x, int y)
{
	int i; int j;
	
	for(i = 0; i < height; i++)
	{
		for(j = 0; j < width; j++)
		{
			if(maze[i][j] == START && (i != y || j != x))
				return 0;
		}
	}	
    return 1;
}

/*
 * solveMazeBFS -- solves the maze using a breadth first search algorithm
 * INPUTS:         maze -- A 2D array that contains the contents of the maze
 *                 width -- the width of the maze
 *                 height -- the height of the maze
 *                 xPos -- the starting x position within the maze
 *                 yPos -- the starting y position within the maze
 * OUTPUTS:        none
 * RETURNS:        0 if the maze is unsolvable, else 1
 * SIDE EFFECTS:   marks the cells within the maze as visited or part of the solution path
 */
 
int solveMazeBFS(char ** maze, int width, int height, int xPos, int yPos)
{
    return 0;
}

/*
 * enqueue -- enqueues an integer onto the given queue
 * INPUTS:    queue -- a pointer to the array that will hold the contents of the queue
 *            value -- the value to  enqueue
 *            head -- a pointer to a variable that contains the head index in the queue
 *            tail -- a pointer to a variable that contains the tail index in the queue
 *            maxSize -- the maximum size of the queue (size of the array)
 * OUTPUTS:   none
 * RETURNS:   none
 * SIDE EFFECTS: adds an item to the queue
 */ 
void enqueue(int * queue, int value, int * head, int * tail, int maxSize)
{
    if ((*tail - maxSize) == *head)
    {
        printf("Queue is full\n");
        return;
    }
    *tail = *tail + 1;
    queue[*tail % maxSize] = value;
}

/* dequeue -- dequeues an item from the given queue
 * INPUTS:    queue -- a pointer to the array that holds the contents of the queue
 *            head -- a pointer to a variable that contains the head index in the queue
 *            tail -- a pointer to a variable that contains the tail index in the queue
 *            maxSize -- the maximum size of the queue (size of the array)
 * OUTPUTS:   none
 * RETURNS:   the value dequeued from the queue
 * SIDE EFFECTS: removes an item from the queue
 */

int dequeue(int * queue, int * head, int * tail, int maxSize)
{
    if (*head == *tail)
    {
        printf("Queue is empty\n");
        return -1;
    }
    *head = *head + 1;
    return queue[*head % maxSize];
}
