//
//  AddCourseViewController.m
//  devoir-ios
//
//  Created by Candice Davis on 3/1/15.
//  Copyright (c) 2015 Candice Davis. All rights reserved.
//

#import "AddCourseViewController.h"
#import "UIColor+DevoirColors.h"

@interface AddCourseViewController() <UITextFieldDelegate>
@property (nonatomic, assign) BOOL isNew;
@property (strong, nonatomic)  NSArray *colorButtons;
@property (weak, nonatomic) IBOutlet UITextField *courseNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *iCalURLText;

@property DevColor origColor;
@end

@implementation AddCourseViewController

- (void)viewDidLoad {
    if(self.course)
    {
        self.isNew = NO;
        
        self.courseNameTextField.text = self.course.name;
        self.iCalURLText.text = self.course.iCalFeed;
        [self.iCalURLText setEnabled:NO];
        
        self.origColor = self.course.color;
    }
    else
    {
        self.isNew = YES;
        self.course = [[Course alloc] init];
    }
    self.view.backgroundColor = [UIColor devAccentColor];
    self.courseNameTextField.textColor = [UIColor devAccentTextColor];
    self.iCalURLText.textColor = [UIColor devAccentTextColor];

    [self setupNavBar];
    [self setupColorButtons];
}

- (void)drawPlaceholderInRect:(CGRect)rect {
    [[UIColor blueColor] setFill];
    NSLog(@"HERERE");
    [self.courseNameTextField.placeholder drawInRect:rect withAttributes:nil];
}

#pragma mark - UI setup

- (void)setupColorButtons {
    NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:7];
    self.colorButtons = [[NSArray alloc] init];
    for(int i = 1; i < 8; i++)
    {
        UIButton *colorButton;
        
        if(i == 1)
            colorButton = [[UIButton alloc] initWithFrame:CGRectMake(4, 350, 40, 40)];
        else
            colorButton = [[UIButton alloc] initWithFrame:CGRectMake((i - 1) * 55, 350, 40, 40)];
            
        [[colorButton layer] setBackgroundColor: [UIColor dbColor:i].CGColor];
        
        if(i == self.course.color)
        {
            [[colorButton layer] setBorderWidth:1.0f];
            [[colorButton layer] setBorderColor: [UIColor blackColor].CGColor];
        }
        
        colorButton.layer.cornerRadius = colorButton.bounds.size.width / 2.0;
        
        colorButton.tag = i;
        
        [colorButton addTarget:self
                   action:@selector(ColorButtonPressed:)
              forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:colorButton];
        buttons[i - 1] = colorButton;
    }
    self.colorButtons = [buttons copy];
}

- (void)setupNavBar {
    if(self.isNew)
    {
        [self.navigationController.navigationBar setBarTintColor:[UIColor devMainColor]];
        self.navigationItem.title = @"Add Course";
    }
    else
    {
        [self.navigationController.navigationBar setBarTintColor:[UIColor dbColor:self.course.color]];
        self.navigationItem.title = self.course.name;
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

- (void)ColorButtonPressed:(id)sender {
    for(UIButton *colorButton in self.colorButtons)
    {
        if(colorButton == (UIButton*)sender)
        {
            [[colorButton layer] setBorderWidth:1.0f];
            [[colorButton layer] setBorderColor: [UIColor blackColor].CGColor];
            [self.navigationController.navigationBar setBarTintColor:colorButton.backgroundColor];
            self.course.color = (int)colorButton.tag;
        }
        else
        {
            [[colorButton layer] setBorderWidth:0.0f];
            [[colorButton layer] setBorderColor: [UIColor clearColor].CGColor];
        }
    }
}

- (void)cancelButtonPressed:(id)sender {
    self.course.color = self.origColor;
    [self.delegate didCancelCourse];
}

- (void)DoneButtonPressed:(id)sender {
    if(self.isNew)
    {
        self.course.name = self.courseNameTextField.text;
        self.course.iCalFeed = self.iCalURLText.text;
        [self.delegate didAddCourse: self.course];
    }
    else
    {
        self.course.name = self.courseNameTextField.text;
        [self.delegate didEditCourse: self.course];
    }
}

@end