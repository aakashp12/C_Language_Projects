#include <stdio.h>
#include <stdlib.h>
#include "ppmio.h"
#include "image.h"


void getPixel(int *image, int height, int width, int x, int y, int *r, int *g, int *b)
{
 /* implement me */
 	
 	int i; int j;
 	
 	for(i = 0; i < height; i++) // y in picture
 	{
 		for(j = 0; j < width; j++) //x in picture
 		{
 			if( ( i == y) && (j == x)) // if we are the right cordinate, get pixel values
 			{
 				r[i*width+j] = image[( ((i*width) + j) * 3) + 1]; // get red value
 				g[i*width+j] = image[( ((i*width) + j) * 3) + 2]; // get blue value
 				b[i*width+j] = image[( ((i*width) + j) * 3) + 3]; // get green value
 			}
 		}
 	}
 
 
}

void setPixel(int *image, int height, int width, int x, int y, int r, int g, int b)
{
 /* implement me */
 
 	int i; int j;
 	
 	for(i = 0; i < height; i++) // y in picture
 	{
 		for(j = 0; j < width; j++) //x in picture
 		{
 			if( ( i == y) && (j == x)) // if we are the right cordinate, get pixel values
 			{
 				image[( ((i*width) + j) * 3) + 1] = r; // set red value
 				image[( ((i*width) + j) * 3) + 2] = g; // set blue value
 				image[( ((i*width) + j) * 3) + 3] = b; // set green value
 			}
 		}
 	}
}


void invertImage(int *inImage, int *outImage, int height, int width)
{
 /* implement me */
 int i; int j;
 int r[height * width];
 int g[height * width];
 int b[height * width];
 
 for(i = 0; i < height; i++)
 {
 	for(j = 0; j < width; j++)
 	{
 		getPixel(inImage, height, width, j, i, r, g, b); // here we pass the value of X and Y into getPIxel
 		
 		r[i* width + j] = 255 - r[i*width +j]; //save the R G B values into an array
 		g[i* width + j] = 255 - g[i*width +j];
 		b[i* width + j] = 255 - b[i*width +j];
 		
 		setPixel(outImage, height, width, j, i, r[i*width +j], g[i*width +j], b[i*width +j]); //Pass X and Y and R G B values	
 	}
 }
 	
}


