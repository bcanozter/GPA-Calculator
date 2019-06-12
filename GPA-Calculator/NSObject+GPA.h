//
//  NSObject+GPA.h
//  GPA-Calculator
//
//  Created by Burak Can ÖZTER on 2019-06-12.
//  Copyright © 2019 Burak Can ÖZTER. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GPA: NSObject{
@private
    double currentGpa;
    double totalHoursGpa;
    int receivedGrades;
    double hoursGpa;
    
}


-(id) init;
-(void)print;
-(void)setCurrentGpa: (double) x;
-(void)setTotalHoursGpa: (double) y;
-(void)setreceivedGrades: (int) z;
-(double)getCurrentGPA;
-(double)getTotalHours;
-(int)getReceivedGrades;
+(GPA *) sharedInstance;

@end

NS_ASSUME_NONNULL_END
