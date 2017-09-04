#include <stdio.h>
#include <stdlib.h>
#include "ppmio.h"
#include "image.h"


int main(int argc, char **argv)
{
    ppm *myimage;
    char *infile, *outfile;
    int x, y;

    if (argc != 5)
    {
       printf("Usage: %s <imput image> <output image> <x> <y>\n", argv[0]);
       return 1;
    }

    infile = argv[1];
    outfile = argv[2];
    x = atoi(argv[3]);
    y = atoi(argv[4]);

    /* load image from disk to memory */
    /*printf("Loading image %s\n", infile);*/
    myimage = LoadPPM(infile);

    /* print pixel (x,y) before transformation */
    printf("before: image[%3d, %3d] = %3d, %3d, %3d\n", x, y, myimage->image[y*myimage->cols+x].r, 
           myimage->image[y*myimage->cols+x].g, myimage->image[y*myimage->cols+x].b);

    /* work on this image */
    invertImage((int*)myimage->image, (int*)myimage->image, myimage->rows, myimage->cols);

    /* print pixel (x,y) after transformation */
    printf(" after: image[%3d, %3d] = %3d, %3d, %3d\n", x, y, myimage->image[y*myimage->cols+x].r, 
           myimage->image[y*myimage->cols+x].g, myimage->image[y*myimage->cols+x].b);

    /* save image back to disk */
    /*printf("Saving image %s\n", outfile);*/
    SavePPM(myimage, outfile);

    /* free memory allocated for the image */
    FreePPM(myimage);

    return 0;
}


