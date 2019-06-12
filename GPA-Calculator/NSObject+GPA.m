//
//  NSObject+GPA.m
//  GPA-Calculator
//
//  Created by Burak Can ÖZTER on 2019-06-12.
//  Copyright © 2019 Burak Can ÖZTER. All rights reserved.
//

#import "NSObject+GPA.h"

@implementation GPA

-(id)init {
    self = [super init];
    if (self) {
        currentGpa = 0;
        totalHoursGpa = 0;
        receivedGrades = 1; //UIStepper set to value minimum of 1
        hoursGpa = 0;
    }
    return self;
}


-(double)getCurrentGPA {
    return currentGpa;
    
}
-(void)setCurrentGpa: (double) x{
    currentGpa = x;
}

-(void)print{
    NSLog(@"Your GPA is %f",currentGpa);
}

-(void)setTotalHoursGpa: (double) y{
    totalHoursGpa = y;
}
-(void)setreceivedGrades: (int) z{
    receivedGrades = z;
}
-(double)getTotalHours{
    return totalHoursGpa;
}
-(int)getReceivedGrades{
    return receivedGrades;
}


+(GPA *) sharedInstance
{
    static id sharedInstance = nil;
    @synchronized(self)
    {
        if (!sharedInstance)
        {
            sharedInstance = [[GPA alloc] init];
        }
        return sharedInstance;
    }
}


@end

