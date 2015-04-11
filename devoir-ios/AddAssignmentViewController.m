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

@interface AddAssignmentViewController () <UITextFieldDelegate, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
@property (strong, nonatomic) DBAccess *database;
@property (nonatomic, assign) BOOL isNew;
@property (strong, nonatomic) NSArray *courses;
@property (weak, nonatomic) IBOutlet UIButton *colorButton;
@property (weak, nonatomic) IBOutlet UITextField *assignmentText;
@property (weak, nonatomic) IBOutlet UITextView *noteText;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UITextField *dateTextfield;
@property (strong, nonatomic) IBOutlet UIPickerView *datePicker;
@property (strong, nonatomic) IBOutlet UIPickerView *coursePicker;
@property (weak, nonatomic) IBOutlet UITextField *courseTextfield;

@end

@implementation AddAssignmentViewController

- (void)viewDidLoad {
    self.database = [[DBAccess alloc] init];
    self.courses = [self.database getAllCoursesOrderedByName];
    
    // datepicker setup
    self.datePicker = [[UIPickerView alloc]init];
    self.datePicker.dataSource = self;
    self.datePicker.delegate = self;
    self.dateTextfield.inputView = self.datePicker;
    
    // coursepicker setup
    self.coursePicker = [[UIPickerView alloc]init];
    self.coursePicker.dataSource = self;
    self.coursePicker.delegate = self;
    self.courseTextfield.inputView = self.coursePicker;
    
    if(self.assignment != nil) {
        Course *course = [self.database getCourseByID:self.assignment.courseID];
        self.assignmentText.text = self.assignment.name;
        self.dateTextfield.text = self.assignment.dueDateAsString;
        [[self.colorButton layer] setBackgroundColor: [UIColor dbColor:course.color].CGColor];
        self.courseTextfield.text = course.name;
        [[self.deleteButton layer] setBorderWidth:1.0f];
        [self.deleteButton.layer setCornerRadius:5.0f];
        [self.deleteButton.layer setBorderColor: [UIColor devRed].CGColor];
        [self.navigationController.navigationBar setBarTintColor:[UIColor dbColor:course.color]];
    } else {
        self.deleteButton.hidden = YES;
    }
    
    [self setupNavBar];
    self.colorButton.layer.cornerRadius = self.colorButton.bounds.size.width / 2.0;
    
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.courses count];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return  1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    Course *course = self.courses[row];
    return course.name;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    Course *course = self.courses[row];
    self.courseTextfield.text = course.name;
    [self.courseTextfield resignFirstResponder];
    self.assignment.courseID = course.ID;
    [[self.colorButton layer] setBackgroundColor: [UIColor dbColor:course.color].CGColor];
    [self.navigationController.navigationBar setBarTintColor:[UIColor dbColor:course.color]];

}

#pragma mark - UI setup

- (void)setupNavBar {
    [self.navigationItem setHidesBackButton:NO];
    if (self.assignment != nil) {
        self.navigationItem.title = self.assignment.name;
        self.isNew = FALSE;
    } else {
         self.navigationItem.title = @"ADD ASSIGNMENT";
        self.isNew = TRUE;
    }

}

#pragma mark - Assignment values changed

- (IBAction)assignmentNameChanged:(id)sender {
    self.assignment.name = self.assignmentText.text;
}

#pragma mark - Button pressed actions

- (IBAction)cancelButtonTapped:(id)sender {
    [self.delegate didCancelAssignment];
}

- (IBAction)deleteButtonTapped:(id)sender {
    [self.delegate didDeleteAssignment: self.assignment];
}

- (IBAction)DoneButtonTapped:(id)sender {
    self.assignment.name = self.assignmentText.text;
//    self.assignment.dueDate = self.dateLabel.text;
//    self.assignment.courseID = self.courseLabel.text;

    if(self.isNew) {
        [self.delegate didAddAssignment: self.assignment];
    }
    else {
        [self.delegate didEditAssignment: self.assignment];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"])
        [textView resignFirstResponder];
    return YES;
}

- (IBAction)dateButtonTapped:(id)sender {
    
}

- (IBAction)reminderButtonTapped:(id)sender {
    
}

-(void) dateTextField:(id)sender {

}























@end