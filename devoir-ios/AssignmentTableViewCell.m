//
//  AssignmentTableViewCell.m
//  devoir-ios
//
//  Created by Candice Davis on 2/28/15.
//  Copyright (c) 2015 Candice Davis. All rights reserved.
//

#import "AssignmentTableViewCell.h"
#import "UIColor+DevoirColors.h"

@implementation AssignmentTableViewCell

- (void)setupCellWithWidth:(int)width Height:(int)height Overdue:(BOOL)overdue {
    if(overdue)
    {
        self.overdueLabel.frame = CGRectMake(width-8, 0, 8, height);
        [[self.overdueLabel layer] setBackgroundColor: [UIColor devRed].CGColor];
        [self.overdueDate setHidden:NO];
    }
    else
    {
        [[self.overdueLabel layer] setBackgroundColor: [UIColor clearColor].CGColor];
        [self.overdueDate setHidden:YES];
    }
    self.colorLabel.frame = CGRectMake(0, 0, 15, height);
    self.overdueDate.backgroundColor = [UIColor clearColor];
    
    self.courseLabel.textColor = [UIColor devMainTextColor];
    self.overdueDate.textColor = [UIColor devMainTextColor];
    self.assignmentLabel.textColor = [UIColor devMainTextColor];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
