//
//  AddCourseViewController.m
//  devoir-ios
//
//  Created by Candice Davis on 3/1/15.
//  Copyright (c) 2015 Candice Davis. All rights reserved.
//

#import "AddCourseViewController.h"
#import "UIColor+DevoirColors.h"

@interface AddCourseViewController()
@property (nonatomic, assign) BOOL isNew;
@end

@implementation AddCourseViewController

- (void)viewDidLoad {
    [self setupNavBar];
    
    if(self.course)
    {
        self.isNew = NO;
        
        self.url.text = self.course.iCalFeed;
        self.name.text = self.course.name;
        self.color.backgroundColor = [UIColor dbColor:self.course.color];
        
    }
    else
    {
        self.isNew = YES;
    }
}

#pragma mark - UI setup

- (void)setupNavBar {
    [self.navigationController.navigationBar setBarTintColor:[UIColor dbColor:self.course.color]];
    self.navigationItem.title = self.course.name;

    [self.navigationItem setHidesBackButton:YES];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                   target:self
                                   action:@selector(DoneButtonPressed:)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                     target:self
                                     action:@selector(cancelButtonPressed:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
}

#pragma mark - Button pressed actions

- (void)cancelButtonPressed:(id)sender {
    [self.delegate didCancelCourse];
}

- (void)DoneButtonPressed:(id)sender {
    if(self.isNew)
    {
        [self.delegate didEditCourse: self.course];
    }
    else
    {
        
        [self.delegate didAddCourse: self.course];
    }
}

@end