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

@interface AddAssignmentViewController ()
@property (strong, nonatomic) DBAccess *database;
@property (nonatomic, assign) BOOL isNew;
@property (weak, nonatomic) IBOutlet UIButton *colorButton;
@property (weak, nonatomic) IBOutlet UITextField *assignmentText;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *reminderLabel;
@property (weak, nonatomic) IBOutlet UITextView *noteText;

@end

@implementation AddAssignmentViewController

- (void)viewDidLoad {
    self.database = [[DBAccess alloc] init];
    
    [self setupNavBar];
    if(self.assignment != nil) {
        self.assignmentText.text = self.assignment.name;
        self.dateLabel.text = self.assignment.dueDateAsString;
        Course *course = [self.database getCourseByID:self.assignment.courseID];
        [[self.colorButton layer] setBackgroundColor: [UIColor dbColor:course.color].CGColor];
        self.colorButton.layer.cornerRadius = self.colorButton.bounds.size.width / 2.0;
    }
    
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)DoneButtonTapped:(id)sender {
    if(self.isNew) {
        [self.delegate didEditAssignment: self.assignment];
    }
    else {
        
        [self.delegate didAddAssignment: self.assignment];
    }
}

@end