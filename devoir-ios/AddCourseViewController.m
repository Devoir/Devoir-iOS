//
//  AddCourseViewController.m
//  devoir-ios
//
//  Created by Candice Davis on 3/1/15.
//  Copyright (c) 2015 Candice Davis. All rights reserved.
//

#import "AddCourseViewController.h"
#import "UIColor+DevoirColors.h"

@interface AddCourseViewController() <UITextFieldDelegate, UITextViewDelegate>
@property (nonatomic, assign) BOOL isNew;
//@property (weak, nonatomic) IBOutlet UIButton *colorButton;
@property (weak, nonatomic) IBOutlet UITextField *assignmentText;
@property (weak, nonatomic) IBOutlet UITextField *iCalURLText;
@end

@implementation AddCourseViewController

- (void)viewDidLoad {
    [self setupNavBar];
    
    [self setupColorButtons];
    
    if(self.course)
    {
        self.isNew = NO;
        
        self.assignmentText.text = self.course.name;
        
        self.iCalURLText.text = self.course.iCalFeed;
        
        [self setupNavBar];
    }
    else
    {
        self.isNew = YES;
    }
}

#pragma mark - UI setup

- (void)setupColorButtons {
    for(int i = 0; i < 8; i ++)
    {
        UIButton *colorButton;
        
        if(i == 0)
            colorButton = [[UIButton alloc] initWithFrame:CGRectMake(4, 350, 40, 40)];
        else
            colorButton = [[UIButton alloc] initWithFrame:CGRectMake(i * 47, 350, 40, 40)];
            
        [[colorButton layer] setBackgroundColor: [UIColor dbColor:i].CGColor];
        colorButton.layer.cornerRadius = colorButton.bounds.size.width / 2.0;
        [self.view addSubview:colorButton];
    }
}

- (void)setupNavBar {
    if(self.course)
    {
        [self.navigationController.navigationBar setBarTintColor:[UIColor dbColor:self.course.color]];
        self.navigationItem.title = self.course.name;
    }
    else
    {
        [self.navigationController.navigationBar setBarTintColor:[UIColor devMainColor]];
        self.navigationItem.title = @"Add Course";
    }
    

    [self.navigationItem setHidesBackButton:YES];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                   target:self
                                   action:@selector(DoneButtonPressed:)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
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