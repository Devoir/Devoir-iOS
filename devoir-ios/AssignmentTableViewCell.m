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
        //self.overdueLabel = [[UIView alloc] initWithFrame:CGRectMake(width - 15, 0, 15, height)];
        self.overdueLabel.frame = CGRectMake(width - 15, 0, 15, height);
        [[self.overdueLabel layer] setBackgroundColor: [UIColor devRed].CGColor];
    }
    else
    {
        [[self.overdueLabel layer] setBackgroundColor: [UIColor clearColor].CGColor];

    }
    
    self.colorLabel.frame = CGRectMake(0, 0, 15, height);
    
    self.overdueDate.frame = CGRectMake(width - 120, 0, 100, height);
    self.overdueDate.backgroundColor = [UIColor clearColor];
}

@end
