
#ifndef _IMAGE_H_
#define _IMAGE_H_

void getPixel(int *image, int height, int width, int x, int y, int *r, int *g, int *b);

void setPixel(int *image, int height, int width, int x, int y, int r, int g, int b);

void invertImage(int *inImage, int *outImage, int height, int width);

#endif

