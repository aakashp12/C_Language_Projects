
#ifndef _PPMIO_H_
#define _PPMIO_H_

typedef struct
{
    int r, g, b;
} pixel;

typedef struct
{
    char type[3];
    int rows, cols;
    int max_val;
    pixel *image;
} ppm;

/* read PPM file from disk, return pointer to image in memory */
ppm* LoadPPM(char *name);

/* save image frommemory to disk */
int SavePPM(ppm *image, char *name);

/* allocate memory for image */

ppm* AllocPPM(int r, int c, int m);

/* deallocate memory for image */
void FreePPM(ppm *image);

#endif

