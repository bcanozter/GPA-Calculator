//
//  dataStructures.c
//  GPA Calculator
//
//  Created by Burak Can ÖZTER on 2019-06-10.
//  Copyright © 2019 Burak Can ÖZTER. All rights reserved.
//

#include "dataStructures.h"
#include "string.h"

#define NUM_OF_GRADES 12

/* DALHOUSIE UNIVERSITY OFFICIAL GRADE SCALE */

struct gradeScale table[NUM_OF_GRADES] = {
    {"A+",4.30},
    {"A",4.00},
    {"A-",3.70},
    {"B+",3.30},
    {"B",3.00},
    {"B-",2.70},
    {"C+",2.30},
    {"C",2.00},
    {"C-",1.70},
    {"D",1.00},
    {"FM",0.00},
    {"F",0.00}
    
};

double searchScale(char* letter){
    for(int i = 0; i<NUM_OF_GRADES; i++){
        if(!(int)strcmp(letter,table[i].grade)){
            return table[i].credits;
        }
    }
    
    return -1;
}

