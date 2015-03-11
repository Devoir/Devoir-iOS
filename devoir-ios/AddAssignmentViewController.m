//
//  AddAssignmentViewController.m
//  devoir-ios
//
//  Created by Candice Davis on 2/28/15.
//  Copyright (c) 2015 Candice Davis. All rights reserved.
//

#import "AddAssignmentViewController.h"
#import "Assignment.h"

@interface AddAssignmentViewController ()
@property (nonatomic, assign) BOOL isNew;
@end

@implementation AddAssignmentViewController

- (void)viewDidLoad {
    [self setupNavBar];
    
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