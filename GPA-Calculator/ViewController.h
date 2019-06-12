//
//  ViewController.h
//  GPA Calculator
//
//  Created by Burak Can ÖZTER on 2019-06-03.
//  Copyright © 2019 Burak Can ÖZTER. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CREDIT_HOURS_ROWS 4
#define ALL_GRADES_ROWS 13
#define GRADE_PICKER_TAG 8
#define MAX_RCVD_GRADES 7

@interface ViewController : UIViewController <UITextFieldDelegate,UIPickerViewDelegate, UIPickerViewDataSource>

{
    int previous;
    NSArray *gradesArray;
    
}

/* UITextfield */

@property (weak, nonatomic) IBOutlet UITextField *currentGPAValue;
@property (weak, nonatomic) IBOutlet UITextField *totalGPAValue;
@property (weak, nonatomic) IBOutlet UITextField *receivedGradeField;
@property (weak, nonatomic) IBOutlet UITextField *calculatedGPAField;
@property (weak, nonatomic) IBOutlet UITextField *overallGPAField;

/* UILabel */

@property (weak, nonatomic) IBOutlet UILabel *cumulativeGpaLabel;
@property (weak, nonatomic) IBOutlet UILabel *termGpaLabel;

/* UIStepper */

@property (weak, nonatomic) IBOutlet UIStepper *stepper;


/* Array of UIPickers for credit hours */
@property (strong, nonatomic) IBOutletCollection(UIPickerView) NSArray *pickers;

/* Array of UITextfields for grades received */
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *gradeFields;


/* UIPickerView for grade picking */
@property (weak, nonatomic) IBOutlet UIPickerView *gradePicker;

- (IBAction)stepperActivated:(id)sender;
- (IBAction)calculateButton:(id)sender;
- (IBAction)dismissKeyboardonTap:(id)sender;


-(BOOL)textFieldShouldReturn:(UITextField *)textField;


@property (weak, nonatomic) IBOutlet UIButton *calculateButton;
@property (weak, nonatomic) IBOutlet UIImageView *calculateButtonImg;

/* Picker View Methods */
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component;
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component;





- (void) toggleIOgfx;

@end


