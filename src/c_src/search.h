#ifndef _NCT_SEARCH_COMMON_H
#define _NCT_SEARCH_COMMON_H

#include "stdbool.h"

static const int lo=0;
static const int hi=1;
/* Some axis-aligned bounding box (AABB) definitions and utilities */

// A bbox; two dimensional, of floats
typedef  float FBBox[2][2];  //DIM is in the second dimension!

bool isBoxLeftOfBoxMed(FBBox * x, FBBox * y, int dim) {
  return (((*x)[lo][dim] + (*x)[hi][dim]) <
	  ((*y)[lo][dim] + (*y)[hi][dim]));
}
bool isBoxMedLeftOfVal(FBBox* b, float val, int dim){
  return (((*b)[lo][dim] + (*b)[hi][dim]) < 2.0f * val);
}


bool intersect(FBBox* ba, FBBox * bb) {
  if ((*ba)[lo][0] > (*bb)[hi][0] || (*ba)[lo][1] > (*bb)[hi][1]  ||
      (*ba)[hi][0] < (*bb)[lo][0] || (*ba)[hi][1] < (*bb)[lo][1] )
    return false;
  else
    return true;
}

/* Reset bb with the data from ba in all dimentions */
void reset(FBBox* bb, const FBBox* ba ) {
  for (int i = 0; i < 2; i++) {
    (*bb)[lo][i] = (*ba)[lo][i];
    (*bb)[hi][i] = (*ba)[hi][i];
  }
}
			       
void augment(FBBox* ba, FBBox *bb) {
  for (int i = 0; i < 2; i++) {
    if ((*bb)[lo][i] < (*ba)[lo][i])
      (*ba)[lo][i] = (*bb)[lo][i];
    if ((*bb)[hi][i] > (*ba)[hi][i])
      (*ba)[hi][i] = (*bb)[hi][i];
  }
}
float median(FBBox* b, int d) {
  return (0.5 * ((*b)[hi][d] + ((*b)[lo][d])));
}


  //Get the bounding box rb of the array of boxes;
  //Assumes rb is pre-allocated
void getArrayBBox (FBBox* rb, FBBox* boxes, unsigned int si, unsigned int se){
    reset(rb, &boxes[si]);
    for (int i = si + 1; i<se; ++i){
      augment(rb, &boxes[i]);
    }
}
#endif
