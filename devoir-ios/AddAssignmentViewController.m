//
//  AddAssignmentViewController.m
//  devoir-ios
//
//  Created by Candice Davis on 2/28/15.
//  Copyright (c) 2015 Candice Davis. All rights reserved.
//

#import "AddAssignmentViewController.h"
#import "Assignment.h"
#import "Course.h"
#import "DBAccess.h"

@interface AddAssignmentViewController () <UITextFieldDelegate, UITextViewDelegate>
@property (strong, nonatomic) DBAccess *database;
@property (nonatomic, assign) BOOL isNew;
@property (weak, nonatomic) IBOutlet UIButton *colorButton;
@property (weak, nonatomic) IBOutlet UITextField *assignmentText;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *reminderLabel;
@property (weak, nonatomic) IBOutlet UITextView *noteText;
@property (weak, nonatomic) IBOutlet UILabel *courseLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation AddAssignmentViewController

- (void)viewDidLoad {
    self.database = [[DBAccess alloc] init];
    
    // datepicker setup
    self.datePicker = [[UIDatePicker alloc]init];
    [self.datePicker setDatePickerMode:UIDatePickerModeDate];
    [self.datePicker setDate:[NSDate date]];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [self.datePicker addTarget:self action:@selector(dateTextField:) forControlEvents:UIControlEventValueChanged];
    
    if(self.assignment != nil) {
        Course *course = [self.database getCourseByID:self.assignment.courseID];
        self.assignmentText.text = self.assignment.name;
//        self.assignmentText.textColor = [UIColor dbColor:course.color];
        self.dateLabel.text = self.assignment.dueDateAsString;
        [[self.colorButton layer] setBackgroundColor: [UIColor dbColor:course.color].CGColor];
        [self.navigationController.navigationBar setBarTintColor:[UIColor dbColor:course.color]];
        self.courseLabel.text = course.name;
        [[self.deleteButton layer] setBorderWidth:1.0f];
        [self.deleteButton.layer setCornerRadius:5.0f];
        [self.deleteButton.layer setBorderColor: [UIColor devRed].CGColor];
    }
    
    [self setupNavBar];
    self.colorButton.layer.cornerRadius = self.colorButton.bounds.size.width / 2.0;
    
}

#pragma mark - UI setup

- (void)setupNavBar {
    [self.navigationItem setHidesBackButton:NO];
    if (self.assignment != nil) {
        self.navigationItem.title = self.assignment.name;
        self.isNew = FALSE;
    } else {
         self.navigationItem.title = @"Add Assignment";
        self.isNew = TRUE;
    }

}

- (IBAction)cancelButtonTapped:(id)sender {
    [self.delegate didCancelAssignment];
}

- (IBAction)deleteButtonTapped:(id)sender {
    [self.delegate didDeleteAssignment: self.assignment];
}

- (IBAction)DoneButtonTapped:(id)sender {
    if(self.isNew) {
        [self.delegate didEditAssignment: self.assignment];
    }
    else {
        
        [self.delegate didAddAssignment: self.assignment];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
        [textView resignFirstResponder];
    return YES;
}

- (IBAction)dateButtonTapped:(id)sender {
    
}

- (IBAction)reminderButtonTapped:(id)sender {
    
}

-(void) dateTextField:(id)sender
{
//    UIDatePicker *picker = (UIDatePicker*)txtFieldBranchYear.inputView;
//    [picker setMaximumDate:[NSDate date]];
//    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//    NSDate *eventDate = picker.date;
//    [dateFormat setDateFormat:@"dd/MM/yyyy"];
//    
//    NSString *dateString = [dateFormat stringFromDate:eventDate];

}























@end