#include <stdio.h>
#include "search.h"

void check_boxes(FBBox* boxes, int ia, int ib){
    bool ix = intersect(&boxes[ia],&boxes[ib]);
    if(ix == true){
         printf("boxes %d and %d intersect \n", ia, ib);
    }else{
        printf("boxes %d and %d dont intersect \n", ia, ib);
    }
}
void check_boxes_b(FBBox* ba,FBBox* bb){
    bool ix = intersect(bb, ba);
    if(ix == true){
         printf("they intersect \n");
    }else{
        printf("they dont intersect \n");
    }
}

void main(){
    const int X=0;
    const int Y=1;
    FBBox box;
    FBBox boxes[10];

    for(int i = 0; i< 10; i++){
        boxes[i][lo][X] = i;
        boxes[i][hi][X] = i+1;
        boxes[i][lo][Y] = 2;
        boxes[i][hi][Y] = 3;
    }

    check_boxes(&boxes[0], 1,2);
    check_boxes(boxes, 1,3);
    check_boxes(boxes, 2,2);
    check_boxes(boxes, 2,3);
    check_boxes(boxes, 2,4); 

    reset(&box, &boxes[1]) ;
    printf("box1_1 and boxes[%d] :", 1);
    check_boxes_b(&box, &boxes[1]);
    getArrayBBox(&box,&boxes[0],3,7);
    printf("box3_7 and  boxes[%d]:", 1);  
    check_boxes_b(&box, &boxes[1]);
    printf("box3_7 and  boxes[%d] :", 2);  
    check_boxes_b(&box, &boxes[2]);
    printf("box3_7 and  boxes[%d] :", 5);  
    check_boxes_b(&box, &boxes[5]);
    printf("box3_7 and  boxes[%d] :", 9);  
    check_boxes_b(&box, &boxes[9]);

    printf("bye bye\n");
}
    