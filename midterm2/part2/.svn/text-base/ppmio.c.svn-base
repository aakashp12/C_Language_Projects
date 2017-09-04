#include <stdio.h>
#include <stdlib.h>
#include "ppmio.h"

ppm* AllocPPM(int r, int c, int m)
{
    ppm *im;

    im = (ppm *)malloc(sizeof(ppm));

    if (im != NULL)
    {
        im->type[0] = 'P';
        im->type[1] = '3';
        im->type[2] = '\0';

        im->rows = r;
        im->cols = c;
        im->max_val = m;

        im->image = (pixel *)calloc(r * c, sizeof(pixel));
        
        if (im->image == NULL)
        {
           free(im);
           im = NULL;
        }
    }

    return im;
}


void FreePPM(ppm *image)
{
    if (image != NULL)
    {
        if (image->image != NULL)
            free(image->image);
        free(image);
    }
}

ppm* LoadPPM(char *name)
{
    FILE *f;
    char buf[3];
    int r, m, c;
    ppm *img;

    f = fopen(name, "r");
    if (f == NULL)
    {
         printf("Cannot open file %s\n", name);
         return NULL;
    }

    fgets(buf, 3, f);
    /* printf("%s\n", buf); */
    
    if (buf[0] != 'P' || buf[1] != '3')
    {
        printf("Wrong file format in %s\n", name);
        fclose(f);
        return NULL;
    }

    fscanf(f, "%d %d %d", &c, &r, &m);
    img = AllocPPM(r, c, m);

    if (img == NULL)
    {
        printf("Cannot allocate memory for %s\n", name);
        fclose(f);
        return NULL;
    }     
    
    for (r = 0; r < img->rows; r++)
        for (c = 0; c < img->cols; c++)
        {
            long long address = img->cols * r + c;    
            fscanf(f, "%d %d %d", &img->image[address].r, &img->image[address].g, &img->image[address].b);
        } 

    fclose(f);
    return img;
}

int SavePPM(ppm *image, char *name)
{
    FILE *f;
    int r, c;

    if (image == NULL) return -1;

    f = fopen(name, "w");
    if (f == NULL)
    {
         printf("Cannot open file %s\n", name);
         return -1;
    }

    fprintf(f, "%s\n", image->type);
    fprintf(f, "%d %d\n%d\n", image->cols, image->rows, image->max_val);

    for (r = 0; r < image->rows; r++)
        for (c = 0; c < image->cols; c++)
        {
            long long address = image->cols * r + c;    
            fprintf(f, "%d %d %d\n", image->image[address].r, image->image[address].g, image->image[address].b);
        } 

    fclose(f);

    return 0;
}

