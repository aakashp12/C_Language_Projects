#include "functions.h"
/*	
 *	This MP was a little hard, had to re-do a lot of the functions becuase of the array math
 *  Sometimes I was  getting out of bound, so had segmentation fault, it was mainly logic error
 *  Once i fixed those it was smooth sailing after that. Radius function was the easiest to do.
 *  CalculasGausFilter was actually not working, which i didnt realize until i found out why 
 *  It took forever command 0 to run adnd then gave me a black image. So i went back and fixed it 
 *  Aparently I thought gausfilter was just an equation and i didnt realize that the weighted sum
 *  Was for us to calcuate it. Soon after messing around with the code, I figured out what to do
 *  And i finally got the bounds right and how to access the array. ConvolveImage was little easy to
 *  Do . At first i had 3 different loops, then relaized it was easier to manage with just one loop
 *  Transform Image and nearestPixel were easy too but i messed up with inversing the Transform
 *  So it threw my Y shift about 40 pixels to the right. The extra credit functions weren't that bad to
 *  Do either. 
 */
 
 
 
/*
 * getRadius - returns the radius based on the sigma value
 * INPUTS: sigma - sigma in the Guassian distribution
 * OUTPUTS: none
 * RETURN VALUE: radius - radius of the filter
 */
int getRadius(double sigma)
{
  int radius;
  radius = ceil(3*sigma);
  return radius;
}

/*
 * calculateGausFilter - calculates the Gaussian filter
 * INTPUTS: gausFitler - pointer to the array for the gaussian filter
 *          sigma - the sigma in the Gaussian distribution
 * OUTPUTS: none
 * RETURN VALUE: none
 */
void calculateGausFilter(double *gausFilter,double sigma)
{
  /*Write your function here*/
  
  int i;
  double weight = 0.0;
  int center = getRadius(sigma); //center will be referred to as RADIUS
  int x = 0; int y = 0;
  int radius_SQ = (2*center + 1) * (2*center + 1);
  
	for(i = 0; i < radius_SQ; i++) //create a mask of dimension radius * radius
	{
		y = i / (2*center + 1); //get value for row... ex:- R= 3 (2*R +1) = 7... 0/7 =0... 6/7 =0 7/7 = 1...row change
		x = i % (2*center + 1); //get value for col... ex:- R=3... 0%7 = 0 1%7 = 1, 2 %7 =2 ...12%7 =5...col change
		int x_2 = x - center;
		int y_2 = y - center;
		
		gausFilter[i] = (1/sqrt(2*M_PI*sigma*sigma)) * exp(-( ((x_2*x_2)+(y_2*y_2)) / (2*(sigma*sigma)) ));
		// this function was quiet unexplained. trial and error to find out that we had to find X and Y values
		weight += gausFilter[i]; //getting the toal weight
	}
	
	for(i = 0; i < radius_SQ; i++)
	{
			gausFilter[i] /= weight;
	}
  
  return;
}

/* convolveImage - performs a convolution between a filter and image
 * INPUTS: inRed - pointer to the input red channel
 *         inGreen - pointer to the input green channel
 *         inBlue - pointer to the input blue channel
 *         inAlpha - pointer to the input alpha channel
 *         filter - pointer to the convolution filter
 *         radius - radius of the convolution filter
 *         width - width of the input image
 *         height - height of the input image
 * OUTPUTS: outRed - pointer to the output red channel
 *          outGreen - pointer to the output green channel
 *          outBlue - pointer to the output blue channel
 *          outAlpha - pointer to the output alpha channel
 * RETURN VALUES: none
 */
void convolveImage(uint8_t *inRed,uint8_t *inGreen,uint8_t *inBlue,
                   uint8_t *inAlpha, uint8_t *outRed,uint8_t *outGreen,
                   uint8_t *outBlue,uint8_t *outAlpha,const double *filter,
                   int radius,int width,int height)
{
  /*Write your function here*/ 
  int i, j;
  int x, y;
  double getRed, getGreen, getBlue; //these hold the sums of individual colors
    
  if(radius < 1)
  	return;
  
  else
  { 
 	// Change Red values
	 for(y = 0; y < height; y++)  //y represents rows
	 {
	  	for(x = 0; x < width; x++) //x represents columns
	  	{
	  		getRed = 0.0; // need to intialize them to 0 for every center
	  		getGreen = 0.0;
	  		getBlue = 0.0;
	  		
	  		for(i = -radius; i <= radius; i ++) //rows
	  		{
	  			for(j = -radius; j <= radius; j ++) //columns
	  			{
	  				if( ((x+j < width) && (x+j >= 0)) && ((y+i < height) && (y+i >= 0)) ) //checking to see if these pixels are out of bound
	  				{
	  					getRed += inRed[((y+i)*width) + (x+j)] * filter[ ((i+radius) * (2*radius +1)) + (j+radius)]; //add the multiplication of convolution kernel and source pixel
	  					getGreen += inGreen[((y+i)*width) + (x+j)] * filter[ ((i+radius) * (2*radius +1)) + (j+radius)]; //add the multiplication of convolution kernel and source pixel
	  					getBlue += inBlue[((y+i)*width) + (x+j)] * filter[ ((i+radius) * (2*radius +1)) + (j+radius)]; //add the multiplication of convolution kernel and source pixel
	  				}	  				
	  			}
	  		}
			getRed = max(getRed, 0); // getRed < 0 ? getRed = 0: getRed = getRed;
			getRed = min(getRed, 255); //getRed > 255 ? getRedd = 255 : getRed = getRed;
			outRed[(y*width) + x] = getRed;
			
			getGreen = max(getGreen, 0);
			getGreen = min(getGreen, 255);
			outGreen[(y*width) + x] = getGreen;
			
			getBlue = max(getBlue, 0);
			getBlue = min(getBlue, 255);
			outBlue[(y*width) + x] = getBlue;
			
			outAlpha[(y*width) + x] = inAlpha[(y*width) + x];
	  	}
	  }
  return;
	} 
}

/* convertToGray - convert the input image to grayscale
 * INPUTS: inRed - pointer to the input red channel
 *         inGreen - pointer to the input green channel
 *         inBlue - pointer to the input blue channel
 *         inAlpha - pointer to the input alpha channel
 *         gMonoMult - pointer to array with constants to be multipiled with 
 *                     RBG channels to convert image to grayscale
 *         width - width of the input image
 *         height - height of the input image
 * OUTPUTS: outRed - pointer to the output red channel
 *          outGreen - pointer to the output green channel
 *          outBlue - pointer to the output blue channel
 *          outAlpha - pointer to the output alpha channel
 * RETURN VALUES: none
 */
void convertToGray(uint8_t *inRed,uint8_t *inGreen,uint8_t *inBlue,
                   uint8_t *inAlpha,uint8_t *outRed,uint8_t *outGreen,
                   uint8_t *outBlue,uint8_t *outAlpha,
                   const double *gMonoMult,int width,int height)
{
  /*Challenge- Write your function here*/
 int i, j;
  double sum_F = 0;
  
  for(i = 0; i < height; i++) //rows
  {
  	for(j = 0; j < width; j++) //columns
  	{
  		sum_F = inRed[i*width + j] * gMonoMult[0] ;
  		sum_F += inGreen[i*width + j] * gMonoMult[1] ;
  		sum_F += inBlue[i*width + j] * gMonoMult[2] ;
  		
  		int sum_R = floor(sum_F);
  		
		outRed[i*width + j] = sum_R;
  		outGreen[i*width +j] = sum_R;
  		outBlue[i*width + j] = sum_R;
  		outAlpha[i*width + j] = inAlpha[i*width + j];
  	}
  }
  return;
}

/* invertImage - inverts the colors of the image
 * INPUTS: inRed - pointer to the input red channel
 *         inGreen - pointer to the input green channel
 *         inBlue - pointer to the input blue channel
 *         inAlpha - pointer to the input alpha channel
 *         width - width of the input image
 *         height - height of the input image
 * OUTPUTS: outRed - pointer to the output red channel
 *          outGreen - pointer to the output green channel
 *          outBlue - pointer to the output blue channel
 *          outAlpha - pointer to the output alpha channel
 * RETURN VALUES: none
 */
void invertImage(uint8_t *inRed,uint8_t *inGreen,uint8_t *inBlue,
                 uint8_t *inAlpha,uint8_t *outRed,uint8_t *outGreen,
                 uint8_t *outBlue,uint8_t *outAlpha,int width,int height)
{
  /*Challenge- Write your function here*/
  int i, j;
  
  for(i = 0; i < height; i++)
  {
  	for(j = 0; j < width; j++)
  	{
  		outRed[i*width + j] = 255 - inRed[i*width + j];
  		outGreen[i*width + j] = 255 - inGreen[i*width + j];
  		outBlue[i*width + j] = 255 - inBlue[i*width + j];
  		outAlpha[i*width + j] = inAlpha[i*width + j];
  	}
  }
  return; 
}

/* pixelate - pixelates the image
 * INPUTS: inRed - pointer to the input red channel
 *         inGreen - pointer to the input green channel
 *         inBlue - pointer to the input blue channel
 *         inAlpha - pointer to the input alpha channel
 *         pixelateY - height of the block
 *         pixelateX - width of the block
 *         width - width of the input image
 *         height - height of the input image
 * OUTPUTS: outRed - pointer to the output red channel
 *          outGreen - pointer to the output green channel
 *          outBlue - pointer to the output blue channel
 *          outAlpha - pointer to the output alpha channel
 * RETURN VALUES: none
 */
void pixelate(uint8_t *inRed,uint8_t *inGreen,uint8_t *inBlue,uint8_t *inAlpha,
              uint8_t *outRed,uint8_t *outGreen,uint8_t *outBlue,
              uint8_t *outAlpha,int pixelY,int pixelX,int width,int height)
{
  /*Challenge- Write your function here*/
 return;
}

/* colorDodge - blends the bottom layer with the top layer
 * INPUTS: aRed - pointer to the bottom red channel                A - BOTTOM
 *         aGreen - pointer to the bottom green channel
 *         aBlue - pointer to the bottom blue channel
 *         aAlpha - pointer to the bottom alpha channel
 *         bRed - pointer to the top red channel                   B - TOP
 *         bGreen - pointer to the top green channel
 *         bBlue - pointer to the top blue channel
 *         bAlpha - pointer to the top alpha channel
 *         width - width of the input image
 *         height - height of the input image
 * OUTPUTS: outRed - pointer to the output red channel
 *          outGreen - pointer to the output green channel
 *          outBlue - pointer to the output blue channel
 *          outAlpha - pointer to the output alpha channel
 * RETURN VALUES: none
 */
void colorDodge(uint8_t *aRed,uint8_t *aGreen,uint8_t *aBlue,
                uint8_t *aAlpha,uint8_t *bRed,uint8_t *bGreen,
                uint8_t *bBlue,uint8_t *bAlpha,uint8_t *outRed,
                uint8_t *outGreen,uint8_t *outBlue,uint8_t *outAlpha,
                int width,int height)
{
   /*Challenge- Write your function here*/
   int i, j;
   for(i = 0; i < height; i++)
   {
   	for(j = 0; j < width; j++)
   	{
   		outRed[i*width + j] = ( (bRed[i*width + j]==255) ? bRed[i*width + j]: min( ((aRed[i*width + j]<<8) / (255-bRed[i*width + j])), 255) );
   		
   		outGreen[i*width + j] = ((bGreen[i*width + j]==255) ? bGreen[i*width + j]:  min( ((aGreen[i*width + j]<<8) / (255-bGreen[i*width + j]) ), 255) );
   		
   		outBlue[i*width + j] = ((bBlue[i*width + j]==255) ? bBlue[i*width + j]: min( ((aBlue[i*width + j]<<8) / (255-bBlue[i*width + j]) ), 255) );
   		
   		outAlpha[i*width + j] = aAlpha[i*width + j];
   	}
   }
   return;
}

/* pencilSketch - creates a pencil sketch of the input image
 * INPUTS: inRed - pointer to the input red channel
 *         inGreen - pointer to the input green channel
 *         inBlue - pointer to the input blue channel
 *         inAlpha - pointer to the input alpha channel
 *         invRed - pointer to temporary red channel for inversion
 *         invGreen - pointer to temporary green channel for inversion
 *         invBlue - pointer to temporary blue channel for inversion
 *         invAlpha - pointer to temporary alpha channel for inversion
 *         blurRed - pointer to temporary red channel for blurring
 *         blurGreen - pointer to temporary green channel for blurring
 *         blurBlue - pointer to temporary blue channel for blurring
 *         blurAlpha - pointer to temporary alpha channel for blurring
 *         filter - pointer to the gaussian filter to blur the image
 *         radius - radius of the gaussian filter
 *         width - width of the input image
 *         height - height of the input image
 *         gMonoMult - pointer to array with constants to be multipiled with 
 *                     RBG channels to convert image to grayscale
 * OUTPUTS: outRed - pointer to the output red channel
 *          outGreen - pointer to the output green channel
 *          outBlue - pointer to the output blue channel
 *          outAlpha - pointer to the output alpha channel
 * RETURN VALUES: none
 */
void pencilSketch(uint8_t *inRed,uint8_t *inGreen,uint8_t *inBlue,
                  uint8_t *inAlpha,uint8_t *invRed,uint8_t *invGreen,
                  uint8_t *invBlue,uint8_t *invAlpha,uint8_t *blurRed,
                  uint8_t *blurGreen,uint8_t *blurBlue,uint8_t *blurAlpha,
                  uint8_t *outRed,uint8_t *outGreen,uint8_t *outBlue,
                  uint8_t *outAlpha,const double *filter,int radius,int width,
                  int height,const double *gMonoMult)
{
    /*Challenge- Write your function here*/
    
   //covert to grayscale save the output in OUT
    convertToGray(inRed, inGreen, inBlue, inAlpha, outRed, outGreen, outBlue, outAlpha, gMonoMult, width, height);
    //invert the image save the output in INV
    invertImage(outRed, outGreen, outBlue, outAlpha, invRed, invGreen, invBlue, invAlpha, width, height);
    //gaussian filter and convolve save the output in BLUR
    convolveImage(inRed, inGreen, inBlue, inAlpha, blurRed, blurGreen, blurBlue, blurAlpha, filter, radius, width, height);
    //combine two images together(TOP - INV, BOT - BLUR) save the output in OUT
    colorDodge(blurRed, blurGreen, blurBlue, blurAlpha, invRed, invGreen, invBlue, invAlpha, outRed, outGreen, outBlue, outAlpha, width, height);
    
    return;
}

/* transformImage - Computes an linear transformation of the input image
 * INPUTS: inRed - pointer to the input red channel
 *         inGreen - pointer to the input green channel
 *         inBlue - pointer to the input blue channel
 *         inAlpha - pointer to the input alpha channel
 *	    transform - two dimensional array containing transform coefficients of matrix T and vector S
 *         width - width of the input and output image
 *         height - height of the input and output image
 * OUTPUTS: outRed - pointer to the output red channel
 *          outGreen - pointer to the output green channel
 *          outBlue - pointer to the output blue channel
 *          outAlpha - pointer to the output alpha channel
 * RETURN VALUES: none
 */
void transformImage(uint8_t *inRed,uint8_t *inGreen,uint8_t *inBlue,uint8_t *inAlpha,
              uint8_t *outRed,uint8_t *outGreen,uint8_t *outBlue,
              uint8_t *outAlpha,double transform[2][3],int width,int height)
{
     /*Write your function here*/
	int i, j;
	int temp = 0; int temp2= 0;
	int *Y; int *X;
     
    Y = &temp;
    X = &temp2;
    
    for(i = 0; i < height; i ++) // increment rows
    {
    	for(j = 0; j < width; j++) //increment cols
    	{
    		nearestPixel(i, j, transform, Y, X, width, height); // according to the MP5 notes we use this function to  find the pixel in the original picture file
    		
    		if( (*X >= 0 && *X <= width - 1) && (*Y >= 0 && *Y <= height -1)) //we need to make sure that our pixel is in bounds
    		{
    			outRed[(i*width) + j] = inRed[ ((*Y) * width) + *X]; // *Y * width + *X is basically same as i* width + j
    			outGreen[(i*width) + j] = inGreen[ ((*Y) * width) + *X];
    			outBlue[(i*width) + j] = inBlue[ ((*Y) * width) + *X];
    			outAlpha[(i*width) + j] = inAlpha[ ((*Y) * width) + *X];
    		} 
    		
    		else //if the pixel is in bound then we go ahead and change the value of it
    		{
    			outRed[(i*width) + j] = 0; //The values set to 0 for the colors 
    			outGreen[(i*width) + j] = 0;
    			outBlue[(i*width) + j] = 0;	
    			outAlpha[(i*width) + j] = 255; //value of outALpha set to 255 
    		}
    	}
    }    
     return;
}

/* nearestPixel - computes the inverse transform to find the closest pixel in the original image
 * INPUTS: pixelYtransform - row value in transformed image
 *         pixelXtransform - column value in transformed image
 *         transform - two dimensional array containing transform coefficients of matrix T and vector S
 *         width - width of the input and output image
 *         height - height of the input and output image
 * OUTPUTS: pixelY - pointer to row value in original image
 *	    pixelX - pointer to column value in original image
 * RETURN VALUES: none
 */
void nearestPixel(int pixelYTransform, int pixelXTransform, double transform[2][3],
              int *pixelY, int *pixelX, int width, int height)
{
     /*Write your function here*/
     double T1, T2, T3, T4, deter;
     double shiftY, shiftX;
     double Xn = 0; double Yn = 0;
     int X_n; int Y_n;
     
     //taking theinverse of the transform matrix   
     deter = ( transform[0][0] * transform[1][1] ) - ( transform[0][1] * transform[1][0]);
     // (t1 * t4) - (t3 * t2) = determinant of the matrix
     
     //manually get the inverse;
     T1 = (1 / deter) * transform[1][1];  // -		-		-		 -
     T2 = -(1 / deter) * transform[0][1]; // | t1 t2  | ->	| T1  T2 | T1 = t4, T2 = -t2. T3 = -t3, T4 = t1
     T3 = -(1 / deter) * transform[1][0];  // | t3 t4  | ->	| T3  T4 |
     T4 = (1 / deter) * transform[0][0]; // -		-		-		  -
     
     shiftX = pixelXTransform - ((width -1)/2) - transform[0][2];
     shiftY = pixelYTransform - ((height-1)/2) - transform[1][2];
     
     Xn = (T1 * shiftX) + (T2 * shiftY) + (width -1)/2;
     Yn = (T3 * shiftX) + (T4 * shiftY) + (height-1)/2;
     
     X_n = Xn; //truncate them
     Y_n = Yn;
     
     if(Xn - X_n >= 0.5)
     	X_n ++;
     if(Yn - Y_n >= 0.5)
     	Y_n ++;
     	
     *pixelX = X_n;
     
     *pixelY = Y_n;
     	
     return;
}
