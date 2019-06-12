//
//  ViewController.m
//  GPA Calculator
//
//  Created by Burak Can ÖZTER on 2019-06-03.
//  Copyright © 2019 Burak Can ÖZTER. All rights reserved.
//


#import "ViewController.h"
#import "NSObject+GPA.h"
#import "dataStructures.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _currentGPAValue.delegate = self;
    _totalGPAValue.delegate = self;
    
    UITapGestureRecognizer *tapBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboardonTap:)];
    [tapBackground setNumberOfTapsRequired:1];
    
    [self.view addGestureRecognizer:tapBackground];
    
    for (UIPickerView *tag in _pickers){
        tag.delegate = self;
        tag.dataSource = self;
    }
    _gradePicker.dataSource = self;
    _gradePicker.delegate = self;
    
    /* Grade Scale */
    gradesArray = [NSArray arrayWithObjects:@" ", @"A+",@"A",@"A-",@"B+",@"B",@"B-",@"C+",@"C",@"C-",@"D",@"FM",@"F", nil];
    
    /* Int Variable to store previous stepper value */
    previous = _stepper.value;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    
    if(_gradePicker.isHidden == FALSE){
        for(UIPickerView *picks in _pickers){
            /* Disable other UIPickers other than UIPicker that is for grades */
            picks.userInteractionEnabled = FALSE;
        }
    }
    
    for(UITextField *grades in _gradeFields){
        if(grades.isSelected == TRUE){
            /* Only change the UITextfield that is selected */
            grades.text = gradesArray[row];
        }
    }
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSUInteger numRows;
    /* Different number of rows for different UIPIcker Options */
    if(pickerView.tag != GRADE_PICKER_TAG){
        numRows = CREDIT_HOURS_ROWS;
    }
    else{
        numRows = ALL_GRADES_ROWS;
    }
    return numRows;
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title;
    double credits[] = {0.0, 1.0, 1.5, 3.0};
    if(pickerView.tag != GRADE_PICKER_TAG){
        title = [@"" stringByAppendingFormat:@"%.1f",credits[row]];
    }
    else{
        title = [@"" stringByAppendingFormat:@"%@",gradesArray[row]];
    }
    
    return title;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 50;
    return sectionWidth;
}


-(void) textFieldDidBeginEditing:(UITextField *)textField{
    if((textField.tag < GRADE_PICKER_TAG)){
        [textField resignFirstResponder];
        textField.selected ^= TRUE;
        [self toggleIOgfx];
    }
    else{
        for(UIPickerView *picks in _pickers){
            picks.userInteractionEnabled = TRUE;
        }
    }
    
}


-(void) textFieldDidEndEditing:(UITextField *)textField{
    textField.selected = FALSE;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return TRUE;
}


-(IBAction)dismissKeyboardonTap:(id)sender{
    [[self view] endEditing:TRUE];
    for(UIPickerView *picks in _pickers){
        picks.userInteractionEnabled = TRUE;
    }
    for(UITextField *gradeFields in _gradeFields){
        gradeFields.selected = FALSE;
    }
    /* Show UITextfields and Calculate Button and change properties */
    /* Inspect the toggleIOgfx function for more details */
    [self toggleIOgfx];
    
}

- (IBAction)stepperActivated:(id)sender {
    /* Comparing previous stepper values in order to show hidden UITexfields or hide them*/
    if(_stepper.value > previous){
        previous++;
        for(UITextField *tag in _gradeFields){
            if(tag.tag == (int)_stepper.value){
                /* show grade input (UITextfield) */
                tag.hidden ^= TRUE;
            }
            
        }
        for(UIPickerView *pickertag in _pickers){
            if(pickertag.tag == (int)_stepper.value){
                /* show credit hours input (UIPickerView) */
                pickertag.hidden ^= TRUE;
            }
        }
    }
    else if(_stepper.value < previous){
        
        for(UITextField *tag in _gradeFields){
            /* Hide grade input (UITextfield) */
            if(tag.tag == previous){
                tag.hidden ^= TRUE;
            }
        }
        
        for(UIPickerView *pickertag in _pickers){
            if(pickertag.tag == previous){
                /* Hide credit hours input (UIPickerView) */
                pickertag.hidden ^= TRUE;
            }
            
        }
        previous--;
    }
    
    /* Use setter method to update number of received grades */
    [[GPA sharedInstance] setreceivedGrades:(int)_stepper.value];
    self.receivedGradeField.text = [NSString stringWithFormat:@"%d", (int) _stepper.value];
}

- (IBAction)currentGPAActivated:(id)sender {
    _currentGPAValue.clearsOnInsertion = TRUE;
    /* Check for invalid inputs */
    if((_currentGPAValue.text.floatValue) < 0 || ([_currentGPAValue.text rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]].location) == TRUE){
        _currentGPAValue.text = @"0";
    }
    /* Use setter method to update current GPA */
    [[GPA sharedInstance] setCurrentGpa:[_currentGPAValue.text doubleValue]];
    
}

- (IBAction)totalHours:(id)sender {
    _totalGPAValue.clearsOnInsertion = TRUE;
    [[GPA sharedInstance] setTotalHoursGpa:[_totalGPAValue.text doubleValue]];
}
- (IBAction)numberOfGrades:(id)sender {
    [[GPA sharedInstance] setreceivedGrades:[_currentGPAValue.text intValue]];
}

- (IBAction)calculateButton:(id)sender {
    /*
     Final result to be displayed in the "Calculated GPA Label" and "Overall GPA Label"
     */
    double termGPA = 0;
    int i = 0;
    double receivedGrades[MAX_RCVD_GRADES] = {0};
    double receivedCredits[MAX_RCVD_GRADES] = {0};
    NSInteger totalCredits = 0;
    double calculatedGPA = 0;
    double overallGPA = 0;
    
    double previousGPA = [[GPA sharedInstance] getCurrentGPA];
    double previousHours = [[GPA sharedInstance] getTotalHours];
    double NumOfreceivedGrades = [[GPA sharedInstance] getReceivedGrades];
    
    for(UITextField *grades in _gradeFields){
        if(!grades.hidden){
            if(grades.text != NULL){
                const char *tmp =[grades.text UTF8String];
                receivedGrades[i] = searchScale((char *)tmp);
                i++;
            }
        }
    }
    
    i = 0;
    
    for(UIPickerView *credits in _pickers){
        if(!credits.hidden){
            receivedCredits[i] = [credits selectedRowInComponent:0];
            i++;
        }
    }
    
    for(int i = 0; i < NumOfreceivedGrades; i++){
        calculatedGPA += receivedCredits[i] * receivedGrades[i];
        totalCredits += receivedCredits[i];
    }
    /* Term GPA */
    termGPA = (calculatedGPA / totalCredits);
    /* overallGPA aka CGPA */
    overallGPA = ((previousGPA*previousHours) + calculatedGPA) / (previousHours+totalCredits);
    
    /* Display the output */
    _overallGPAField.text =[NSString stringWithFormat:@"%.2f", overallGPA];
    _calculatedGPAField.text = [NSString stringWithFormat:@"%.2f", termGPA];
    
}



-(void) toggleIOgfx{
    /* Reset the previous chosen option */
    [_gradePicker reloadAllComponents];
    [_gradePicker selectRow:0 inComponent:0 animated:YES];
    
    /* Toggle Buttons, Images and Interactions */
    _gradePicker.hidden ^= TRUE;
    _calculatedGPAField.hidden ^= TRUE;
    _calculateButton.hidden ^= TRUE;
    _calculateButtonImg.hidden ^= TRUE;
    _termGpaLabel.hidden ^= TRUE;
    _cumulativeGpaLabel.hidden ^= TRUE;
    _overallGPAField.hidden ^= TRUE;
    _stepper.userInteractionEnabled ^= TRUE;
}


@end






